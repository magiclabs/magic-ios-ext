//
//  OIDCExtension.swift
//  MagicSDK
//
//  Created by Jerry Liu on 10/16/22.
//

import Foundation
import MagicSDK_Web3
import MagicSDK

public class GDKMSExtension: BaseModule {

    public func encryptWithPrivateKey (_ message:String, response: @escaping Web3ResponseCompletion<String> ) {
        let request = RPCRequest<[String]>(method: GDKMSMethod.magic_auth_encrypt_v1.rawValue, params: [message])
        self.provider.send(request: request, response: response)
    }
    
    public func decryptWithPrivateKey (_ cipherText: String, response: @escaping Web3ResponseCompletion<String> ) {
        let request = RPCRequest<[String]>(method: GDKMSMethod.magic_auth_decrypt_v1.rawValue, params: [cipherText])
        self.provider.send(request: request, response: response)
    }
}

extension Magic {
    
    public var gdkms: GDKMSExtension {
        print("\(self.MA_EXTENSION_ONLY_MSG)")
        return GDKMSExtension(rpcProvider: self.rpcProvider)
    }
}
