//
//  DisplayViewController.swift
//  SampleApplication
//
//  Created by apple on 25/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class DisplayViewController: UIViewController,WKNavigationDelegate {
    
    @IBOutlet weak var displayWebView: WKWebView!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var displayPageTitle: UILabel!
    var taleTreeGuide:Bool?
    var termsOfUse:Bool?
    var privacyPolicy:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if taleTreeGuide == true
        {
            displayPageTitle.text = "TaleTree Guidelines"
            var taleTreeGuideSrting = "https://www.taletree.app/taletreepledge"
            if taleTreeGuideSrting != nil
            {
                let  url = URL(string: taleTreeGuideSrting)
                
                displayWebView.navigationDelegate = self
                displayWebView.load(URLRequest(url: url!))
            }
            
            
        }else if termsOfUse == true {
            displayPageTitle.text = "Terms of Use"
            
            var termsOfUseSrting = "https://www.taletree.app/terms-of-service"
            if termsOfUseSrting != nil
            {
                let  url = URL(string: termsOfUseSrting)
                
                displayWebView.navigationDelegate = self
                displayWebView.load(URLRequest(url: url!))
            }
            
            
        }else if privacyPolicy == true{
            displayPageTitle.text = "Privacy Policy"
            var privacyPolicySrting = "https://www.taletree.app/privacy-policy"
            if privacyPolicy != nil
            {
                let  url = URL(string: privacyPolicySrting)
                
                displayWebView.navigationDelegate = self
                displayWebView.load(URLRequest(url: url!))
            }
  
        }
        
    }
    // MARK:- Button event
    @IBAction func backButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    // Web view methods...
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //show your activity
        
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
