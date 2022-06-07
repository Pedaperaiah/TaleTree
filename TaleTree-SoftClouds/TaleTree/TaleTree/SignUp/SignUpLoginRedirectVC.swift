//
//  SignUpLoginRedirectVC.swift
//  TaleTree
//
//  Created by apple on 17/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import SVProgressHUD
import ImageIO

class SignUpLoginRedirectVC: UIViewController {
    
    
    @IBOutlet weak var crossMark: UIButton!
    
    @IBOutlet weak var taleTreeLogo: UIImageView!
    
    @IBOutlet weak var setUpLbl: UILabel!
    @IBOutlet weak var parentSignUpBtn: UIButton!
    @IBOutlet weak var kidLoginBtn: UIButton!
    @IBOutlet weak var taleTreeWelcomeLbl: UILabel!
    @IBOutlet weak var skipForNowBtn: UIButton!
    
    var logoutMethod : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Getting device information wheather ipad or iphone.
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            self.iPadCustomDesignMethod()
        // print("iPad style UI")
        case .phone:
            self.CustomDesignMethod()
        //  print("iPhone and iPod touch style UI")
        case .tv:
            print("tvOS style UI")
        default:
            print("")
        }
        
        
        if logoutMethod == true {
            showToast(message: "You've been logged out.")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        logoutMethod = false
    }
    // MARK: Toste Method...
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        toastLabel.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4901960784, blue: 1, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        //    toastLabel.font = UIFont(name: "SF Pro Text Semibold", size: 15.0)
        ///   toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 4;
        toastLabel.clipsToBounds  =  true
        toastLabel.contentMode = .bottom
        
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: 30))
        
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        //  label.font = UIFont(name: "SF Pro Text Semibold", size: 20.0)
        label.text = message
        label.alpha = 1.0
        label.layer.cornerRadius = 4;
        label.clipsToBounds  =  true
        toastLabel.addSubview(label)
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 1.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        
    }
    // MARK: - class methods..
    class VerticalAlignedLabel: UILabel {
        override func drawText(in rect: CGRect) {
            var newRect = rect
            switch contentMode {
            case .top:
                newRect.size.height = sizeThatFits(rect.size).height
            case .bottom:
                let height = sizeThatFits(rect.size).height
                newRect.origin.y += rect.size.height - height
                newRect.size.height = height
            default:
                ()
            }
            super.drawText(in: newRect)
        }
    }
    
    // MARK: - Butoon Events...
    @IBAction func crossMarkBtnTapped(_ sender: Any) {
        
        print("exit from login screen")
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func temporaryFavBtnTapped(_ sender: Any) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func kidLoginBtnTapped(_ sender: Any) {
        
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //  print("enter login screen")
        
    }
    @IBAction func parentSignUpBtnTapped(_ sender: Any) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func skipForNowBtnTapped(_ sender: Any) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:- Custom TextField Validations
    func isAccountHasValidDetails()  -> Bool {
        
        return true
    }
    
    //Mark:- textfileds corner radius set for iPad
    func iPadCustomDesignMethod(){
        
        kidLoginBtn.layer.cornerRadius = 25
        kidLoginBtn.layer.borderWidth = 0.1
        kidLoginBtn.layer.masksToBounds = true
        
        parentSignUpBtn.layer.cornerRadius = 25
        parentSignUpBtn.layer.borderWidth = 0.1
        parentSignUpBtn.layer.masksToBounds = true
    }
    
    //Mark:- textfileds corner radius set for iPhone
    func CustomDesignMethod() {
        
        
        self.kidLoginBtn.layer.cornerRadius = 20
        self.kidLoginBtn.layer.borderWidth = 0.1
        self.kidLoginBtn.layer.masksToBounds = true
        
        self.parentSignUpBtn.layer.cornerRadius = 20
        self.parentSignUpBtn.layer.borderWidth = 0.1
        self.parentSignUpBtn.layer.masksToBounds = true
    }
    
}

