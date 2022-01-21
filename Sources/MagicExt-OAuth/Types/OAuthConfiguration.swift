//
//  OAuthConfiguration.swift
//  MagicExt-OAuth
//
//  Created by Wentao Liu on 9/23/20.
//

import Foundation
import MagicSDK

public struct OAuthConfiguration: BaseConfiguration {
    public var provider: OAuthProvider
    public var redirectURI: String
    public var scope: [String]?
    public var loginHint: String?
    
    public init(provider: OAuthProvider, redirectURI: String, scope: [String]? = nil, loginHint: String? = nil) {
        self.provider = provider
        self.redirectURI = redirectURI
        self.scope = scope
        self.loginHint = loginHint
    }
}

public enum OAuthProvider: String, CaseIterable, Codable {
    case GOOGLE
    case FACEBOOK
    case GITHUB
    case APPLE
    case LINKEDIN
    case BITBUCKET
    case GITLAB
    case TWITTER
    case DISCORD
    case TWITCH
    case MICROSOFT
}
