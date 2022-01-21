//
//  File.swift
//  MagicExt-OAuth
//
//  Created by Wentao Liu on 9/29/20.
//

import Foundation
import MagicSDK

public struct OpenIDConnectProfile: Codable {
    public let name: String?
    public let familyName: String?
    public let givenName: String?
    public let middleName: String?
    public let nickname: String?
    public let preferredUsername: String?
    public let profile: String?
    public let picture: String?
    public let website: String?
    public let gender: String?
    public let birthdate: String?
    public let zoneinfo: String?
    public let locale: String?
    public let updatedAt: Int?
    
    // OpenIDConnectEmail
    public let email: String?
    public let emailVerified: Bool?
    
    // OpenIDConnectPhone
    public let phoneNumber: String?
    public let phoneNumberVerified: Bool?
    
    // OpenIDConnectAddress
    public let address: OIDAddress?
    
    // OIDAddress
    public struct OIDAddress: Codable {
        let formatted: String;
        let streetAddress: String;
        let locality: String;
        let region: String;
        let postalCode: String;
        let country: String;
    }
}
