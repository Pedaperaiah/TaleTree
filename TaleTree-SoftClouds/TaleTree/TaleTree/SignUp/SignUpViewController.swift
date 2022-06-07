//
//  SignUpViewController.swift
//  TaleTree
//
//  Created by apple on 17/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

import SystemConfiguration

class SignUpViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var signUpPageDisplay: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // loading url into web view
        let url = URL(string: API.signInPageRedirect)
        signUpPageDisplay.navigationDelegate = self
        signUpPageDisplay.load(URLRequest(url: url!))
        

    }
    
    @IBAction func backActn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Web view methods...
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
 
        if Reachability.isConnectedToNetwork(){
            SVProgressHUD.show()
        }else{
            SVProgressHUD.dismiss()
            
          DispatchQueue.main.async {
               
            self.showAlertView(title: "", msg: "No Network Connection")
               
           }
        }
        
    }

}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

