//
//  OpenIdConfiguration.swift
//
//
//  Created by Jerry Liu on 10/17/22.
//

import Foundation
import MagicSDK

public struct OpenIdConfiguration: BaseConfiguration {
    public var jwt: String
    public var providerId: String

    public init(jwt: String, providerId: String) {
        self.jwt = jwt
        self.providerId = providerId
    }
}
