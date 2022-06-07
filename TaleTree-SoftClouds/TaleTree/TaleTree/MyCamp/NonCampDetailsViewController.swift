//
//  NonCampDetailsViewController.swift
//  TaleTree
//
//  Created by UFL on 28/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class NonCampDetailsViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var nonCampWebView: WKWebView!
    @IBOutlet var noncampBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: API.nonCampPageredirect)
        nonCampWebView.navigationDelegate = self
        nonCampWebView.load(URLRequest(url: url!))
        
    }
    @IBAction func nonCampBackActn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    // MARK: -  Web view Methods....
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
