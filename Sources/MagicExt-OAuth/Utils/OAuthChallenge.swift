//
//  OAuthChallenge.swift
//  MagicExt-OAuth
//
//  Created by Wentao Liu on 9/24/20.
//

import Foundation
import MagicSDK
import CryptoSwift

internal class OAuthChallenge {
    var state: String
    let verifier: String
    let challenge: String
    
    init() {
        self.state = createRandomString(size: 128)
        self.verifier = createRandomString(size: 128)
        self.challenge = hexToBase64URLSafe(self.verifier.sha256())
    }
}

func createRandomString(size: Int) -> String {
    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
    return String((0..<size).map{ _ in letters.randomElement()! })
}

func hexToBase64URLSafe(_ hexString: String) -> String {
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    var data = Data(capacity: hexString.count / 2)

    let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
    regex.enumerateMatches(in: hexString, range: NSRange(hexString.startIndex..., in: hexString)) { match, _, _ in
        let byteString = (hexString as NSString).substring(with: match!.range)
        let num = UInt8(byteString, radix: 16)!
        data.append(num)
    }

    guard data.count > 0 else { return "" }

    /// Remove or replace +, /, =
    let base64String = data.base64EncodedString()
    return base64String.replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "=", with: "")
}
