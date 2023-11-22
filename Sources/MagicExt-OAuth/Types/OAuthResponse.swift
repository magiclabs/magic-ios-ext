//
//  OAuthResult.swift
//  MagicExt-OAuth
//
//  Created by Wentao Liu on 9/29/20.
//

import Foundation
import MagicSDK

public struct OAuthResponse: MagicResponse {
    public let oauth: OauthPartialResult
    public let magic: MagicPartialResult
}

public struct OauthPartialResult: Codable {
    public let provider: String;
    public let scope: [String];
    public let accessToken: String;
    public let userHandle: String;
    public let userInfo: OpenIDConnectProfile;

}
public struct MagicPartialResult: Codable {
    public let idToken: String;
    public let userInfo: UserInfo;
}
