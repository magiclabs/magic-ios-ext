//
//  FortmaticShimViewController.swift
//  Fortmatic
//
//  Created by Wentao Liu on 2/3/20.
//

import Foundation
import AuthenticationServices
import SafariServices
import MagicSDK
import PromiseKit

@available(iOS 12.0, *)
class ShimASViewController: UIViewController, ASWebAuthenticationPresentationContextProviding
{
    var authSession: ASWebAuthenticationSession?
    
    /// X source url
    var source:URL?
    
    /// callback URL scheme
    var callbackURL:String!
    
    /// resolver
    var resolver:Resolver<String>?
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        // Perhaps I don't need the window object at all, and can just use:
        // return ASPresentationAnchor()
        return UIApplication.shared.keyWindow ?? ASPresentationAnchor()
    }
    
    override func viewDidLoad() {
        
        
        //tries ASWebAuthenticationSession
        authSession = ASWebAuthenticationSession.init(url: source!, callbackURLScheme: callbackURL, completionHandler: { (callBack:URL?, error:Error?) in
            
            //auto close VC after popup is closed
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            
            // handle response
            guard error == nil, let successURL = callBack else {
                self.resolver?.reject(error!)
                return
            }
            
            self.resolver?.fulfill(successURL.absoluteString)
        })
                        
        if #available(iOS 13, *){
            authSession?.presentationContextProvider = self
        }
                        
        authSession?.start()
    }
}
