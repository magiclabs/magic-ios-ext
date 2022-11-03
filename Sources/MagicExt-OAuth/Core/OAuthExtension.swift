//
//  OauthModule.swift
//  MagicSDK
//
//  Created by Wentao Liu on 9/16/20.
//

import Foundation
import AuthenticationServices
import SafariServices
import MagicSDK_Web3
import MagicSDK
import PromiseKit

public class OAuthExtension: BaseModule {

    public enum OAuthExtensionError: Swift.Error {
        case parseSuccessURLError(url: String)
        case unsupportedVersions
        case userDeniedAccess(Swift.Error)
        case unableToStartPopup
    }

    public func loginWithPopup (_ configuration: OAuthConfiguration) -> Promise<OAuthResponse> {
        return Promise { resolver in
            loginWithPopup(configuration, response: promiseResolver(resolver))
        }
    }

    public func loginWithPopup (_ configuration: OAuthConfiguration, response: @escaping Web3ResponseCompletion<OAuthResponse>) {
        let oauthChallenge = OAuthChallenge()

        // Construct OAuth URL
        var components = URLComponents()
        components.scheme = "https"
        components.host = "auth.magic.link"
//        components.scheme = "http"
//        components.host = "192.168.0.106"
//        components.port = 3014
        components.path = "/v1/oauth2/\(configuration.provider.rawValue.lowercased())/start"

        components.queryItems = [
            URLQueryItem(name: "magic_api_key", value: self.provider.urlBuilder.apiKey),
            URLQueryItem(name: "magic_challenge", value: oauthChallenge.challenge),
            URLQueryItem(name: "state", value: oauthChallenge.state),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "platform", value: "rn"),
            URLQueryItem(name: "bundleId", value: Bundle.main.bundleIdentifier)
        ]

        if let scope = configuration.scope {
            if scope.count > 0 {
                components.queryItems?.append(URLQueryItem(name: "scope", value: scope.joined(separator: " ")))
            }
        }

        if let loginHint = configuration.loginHint {
            components.queryItems?.append(URLQueryItem(name: "login_hint", value: loginHint))
        }

        let authURL = components.url



        firstly {
            // Pop Authentication Session
            createAuthenticationSession(authURL: authURL, configuration: configuration)
        }.done {successURL -> Void in

            // Remove Percentage Encode to prevent double encoding
            guard let query = URL(string:successURL)?.query?.removingPercentEncoding else {
                throw OAuthExtensionError.parseSuccessURLError(url: successURL)
            }

            // send credential to auth relayer to authenticate
            let request = RPCRequest<[String]>(method: OAuthMethod.magic_oauth_parse_redirect_result.rawValue, params: [           "?\(query)", oauthChallenge.verifier, oauthChallenge.state])
            self.provider.send(request: request, response: response)
        }.catch { error in
            let errResponse = Web3Response<OAuthResponse>(error: OAuthExtensionError.userDeniedAccess(error))
            response(errResponse)
//            handleRollbarError(error, log: false)
        }
    }

    private func createAuthenticationSession(authURL: URL?, configuration: OAuthConfiguration) -> Promise<String> {

        // Remove "://" from app schemes to prevent error
        let callbackURLScheme = configuration.redirectURI.replacingOccurrences(of: "://", with: "", options: NSString.CompareOptions.literal, range: nil)

        return Promise { resolver in

            // find topmost view controller from the hierarchy and attach modal Controller to it
            guard let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
                return resolver.reject(OAuthExtensionError.unableToStartPopup)
            }

            if var topController = keyWindow.rootViewController {
                while let presentedVC = topController.presentedViewController {
                    topController = presentedVC
                }
                if #available(iOS 12, *) {
                    let shimVC = ShimASViewController()
                    shimVC.source = authURL
                    shimVC.callbackURL = callbackURLScheme
                    shimVC.resolver = resolver
                    topController.present(shimVC, animated: true)
                } else if #available(iOS 11.0, *) {
                    let shimVC = ShimSFASViewController()
                    shimVC.source = authURL
                    shimVC.callbackURL = callbackURLScheme
                    shimVC.resolver = resolver
                    topController.present(shimVC, animated: true)
                } else {
                    resolver.reject(OAuthExtensionError.unsupportedVersions)
                }
            } else {
                return resolver.reject(OAuthExtensionError.unableToStartPopup)
            }

        }
    }
}

extension Magic {
    public var oauth: OAuthExtension {
        return OAuthExtension(rpcProvider: self.rpcProvider)
    }
}

// Handles Specific OAuthError
extension Web3Response {
    public var magicExtOAuthError: OAuthExtension.OAuthExtensionError? {
        switch self.status {
        case .failure(let error):
            return error as? OAuthExtension.OAuthExtensionError
        case .success:
            return nil
        @unknown default:
            return nil
        }
    }
}
