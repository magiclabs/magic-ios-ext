//
//  ShimSFViewController.swift
//  MagicExt-OAuth
//
//  Created by Wentao Liu on 9/28/20.
//

import Foundation
import SafariServices
import MagicSDK
import PromiseKit

@available(iOS 11.0, *)
class ShimSFASViewController: UIViewController
{
    var authSession: SFAuthenticationSession?
    
    /// X source url
    var source:URL?
    
    /// callback URL scheme
    var callbackURL:String!
    
    /// resolver
    var resolver: Resolver<String>?

    override func viewDidLoad() {
        
        
        //tries ASWebAuthenticationSession
        authSession = SFAuthenticationSession.init(url: source!, callbackURLScheme: callbackURL, completionHandler: { (callBack:URL?, error:Error?) in
            
            //auto close VC after popup is closed
            self.dismiss(animated: true)
            
            // handle response
            guard error == nil, let successURL = callBack else {
                self.resolver?.reject(error!)
                return
            }
            
            // Resolve data back to send
            self.resolver?.fulfill(successURL.absoluteString)
        })
                        
        authSession?.start()
    }
}
