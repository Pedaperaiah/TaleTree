//
//  LoginViewController.swift
//  TaleTree
//
//  Created by UFL on 16/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import SVProgressHUD
import IQKeyboardManagerSwift

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var userNameTf: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet weak var cantLoginBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var showHideBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        errorLabel.text = ""
        userNameTf.isUserInteractionEnabled = true
        passwordTF.isUserInteractionEnabled = true
        
        // textfileds and buttons corner designs
        iphoneCustomDesignMethod()
        
        // Adding some space to left side of textfield
        userNameTf.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        passwordTF.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        userNameTf.delegate = self
        passwordTF.delegate = self
        
        // grade out button untill textfield filled
        loginBtn.isEnabled = false;
        loginBtn.backgroundColor =  UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        userNameTf.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
        passwordTF.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        // navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Custom Methods...
    @objc func textFieldDidChange(_ sender: UITextField) {
        
        if userNameTf.text == "" || passwordTF.text == "" {
            
            loginBtn.isEnabled = false;
            
            loginBtn.backgroundColor =  UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
            
        }else{
            
            loginBtn.isEnabled = true;
            
            loginBtn.backgroundColor =  UIColor(red: 68.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
            
        }
        
    }
    //MARK:- textfileds corner radius set for iPad
    func iPadCustomDesignMethod(){
        
        userNameTf.layer.cornerRadius = 25
        userNameTf.layer.borderWidth = 0.1
        userNameTf.layer.masksToBounds = true
        
        passwordTF.layer.cornerRadius = 25
        passwordTF.layer.borderWidth = 0.1
        passwordTF.layer.masksToBounds = true
    }
    //Mark:- textfileds corner radius set for iPhone
    func iphoneCustomDesignMethod() {
        
        userNameTf.layer.cornerRadius = 6
        userNameTf.layer.borderWidth = 0.1
        userNameTf.layer.masksToBounds = true
        userNameTf.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        userNameTf.layer.borderWidth = 1.2
        
        passwordTF.layer.cornerRadius = 6
        passwordTF.layer.borderWidth = 0.1
        passwordTF.layer.masksToBounds = true
        passwordTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        passwordTF.layer.borderWidth = 1.2
        
        loginBtn.layer.cornerRadius = 23
        loginBtn.layer.borderWidth = 0.1
        loginBtn.layer.masksToBounds = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userNameTf || textField == passwordTF {
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = #colorLiteral(red: 0.2666666667, green: 0.862745098, blue: 0.862745098, alpha: 1)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
    }
    
    // MARK: -  Button Events...
    @IBAction func cantLoginBtnTapped(_ sender: Any) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "CantLoginViewController") as! CantLoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
        self.navigationController?.pushViewController(vc, animated: true)
        //Mark:- Hidding the navigation bar
        //        navigationController?.popViewController(animated: true)
        //        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showHideBtnTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTF.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func loginBtnActn(_ sender: UIButton) {
        
        if userNameTf.text?.isEmpty == true {
            showAlert(title: "", msg: "Please enter username")
            return
        }
        else if passwordTF.text?.isEmpty == true
        {
            showAlert(title: "", msg: "Please enter password")
            return
        }
        else
        {
            self.loginTokenAPICall()
            
        }
        
    }
    // MARK: -  API Calling Method
    func loginTokenAPICall ()
    {
        SVProgressHUD.show()
        
        let url = URL(string: API.loginTokenAPI)
        
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        
        let clientID = API.ClientIDStr
        let client_secret = API.client_secret
        
        let ResultString = "\(clientID):\(client_secret)"
        
        let base64Encoded = Data(ResultString.utf8).base64EncodedString()
        
        let autStr = "Basic \(base64Encoded)"
        
        request.setValue(autStr, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "username": userNameTf.text!,
            "password": passwordTF.text!,
            "grant_type": "password"
        ]
        request.httpBody = parameters.percentEncoded()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    if Reachability.isConnectedToNetwork(){
                        
                    }else{
                        
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.showAlertView(title: "", msg: "No Network Connection")
                            
                        }
                    }
                    
                    
                    return
            }
            
            do {
                
                SVProgressHUD.dismiss()
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    //    print(json)
                    
                    if json["access_token"] != nil
                    {
                     //   print(json)
                        
                        //    SVProgressHUD.dismiss()
                        let loginTokenData = try JSONDecoder().decode(loginToken.self, from: data)
                        
                      //  print(loginTokenData.access_token as Any)
                        
                        if let data = try? JSONEncoder().encode(loginTokenData) {
                            UserDefaults.standard.set(data, forKey: "loginTokens")
                            
                        }
                        
                        
                        let accessToken = json["access_token"] as! String
                        
                        self.loadProfileUserData(accessToken: accessToken)
                        
                    }
                    else
                    {
                        
                        DispatchQueue.main.async {
                            
                            self.userNameTf.layer.cornerRadius = 6
                            self.userNameTf.layer.borderWidth = 0.1
                            self.userNameTf.layer.masksToBounds = true
                            self.userNameTf.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                            self.userNameTf.layer.borderWidth = 1.2
                            
                            self.passwordTF.layer.cornerRadius = 6
                            self.passwordTF.layer.borderWidth = 0.1
                            self.passwordTF.layer.masksToBounds = true
                            self.passwordTF.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                            self.passwordTF.layer.borderWidth = 1.2
                            SVProgressHUD.dismiss()
                            self.errorLabel.text = "Invalid username or password. Please try again"
                            
                        }
                    }
                    
                }
                else
                {
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.showAlert(title: "", msg: "Invalid details. Please try again")
                    }
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            
            
        }
        
        task.resume()
        
    }
    
    func loadProfileUserData(accessToken:String)
    {
        
        SVProgressHUD.show()
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
        }
        
        let url = URL(string: API.loadProfileUser)
        
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    if Reachability.isConnectedToNetwork(){
                        
                    }else{
                        
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.showAlertView(title: "", msg: "No Network Connection")
                            
                        }
                    }
                    return
            }
            
            do {
                SVProgressHUD.dismiss()
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    //  print(json)
                    
                    if json["data"] != nil
                    {
                        if let responsedict: NSDictionary = json["data"] as? NSDictionary{
                            
                            //    print("resp", responsedict)
                            
                            let theJSONData = try? JSONSerialization.data(withJSONObject: json["data"] as! [String: Any] , options:[])
                            
                            let loginUserData = try JSONDecoder().decode(userProfileDetails.self, from: theJSONData!)
                            
                            //  print(loginUserData)
                            
                            if let data = try? JSONEncoder().encode(loginUserData) {
                                UserDefaults.standard.set(data, forKey: "loggedUserData")
                                
                            }
                            
                            UserDefaults.standard.set("loginYes", forKey: "UserLogin")
                            UserDefaults.standard.synchronize()
                            
                            if loginUserData.profile?.favorites?[0] == "" {
                                
                                DispatchQueue.main.async {
                                    
                                    SVProgressHUD.dismiss()
                                    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc = mainStoryboard.instantiateViewController(withIdentifier: "FavoriteViewController")
                                    //  self.present(vc, animated:true, completion:nil)
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    
                                    SVProgressHUD.dismiss()
                                    
                                    let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
                                    self.navigationController?.pushViewController(vc, animated: true)
                                    
                                    
                                }
                            }
                            
                        }
                        else
                        {
                            
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.showAlert(title: "", msg: "Invalid details")
                        }
                        
                    }
                    
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
    }
    
}
// MARK: - Extension Methods...
extension String {
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        // let unreserved = "-._~/?"
        let unreserved = "-._~/?:"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
