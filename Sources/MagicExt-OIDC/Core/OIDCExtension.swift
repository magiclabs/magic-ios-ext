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

public class OIDCExtension: BaseModule {

}

extension Magic {
    public var openid: OIDCExtension {
        return OIDCExtension(rpcProvider: self.rpcProvider)
    }
}
