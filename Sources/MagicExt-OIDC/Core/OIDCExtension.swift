//
//  OIDCExtension.swift
//  MagicSDK
//
//  Created by Jerry Liu on 10/16/22.
//

import Foundation
import MagicSDK_Web3
import MagicSDK

public class OIDCExtension: BaseModule {

    public func loginWithOIDC (_ configuration: OpenIdConfiguration, response: @escaping Web3ResponseCompletion<String> ) {
        let request = RPCRequest<[OpenIdConfiguration]>(method: OIDCMethod.magic_auth_login_with_oidc.rawValue, params: [configuration])
        self.provider.send(request: request, response: response)
    }
}

extension Magic {
    public var openid: OIDCExtension {
        return OIDCExtension(rpcProvider: self.rpcProvider)
    }
}
