//
//  OAuthRedirectError.swift
//  MagicExt-OAuth
//
//  Created by Wentao Liu on 6/25/21.
//

import Foundation
import MagicSDK

public struct OAuthRedirectError: MagicResponse {
    public let provider: OAuthProvider.RawValue
    public let error: String
    public let error_description: String
    public let error_uri: String?
}
