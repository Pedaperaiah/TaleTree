//
//  CantLoginViewController.swift
//  TaleTree
//
//  Created by apple on 17/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD

class CantLoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var crossMark: UIButton!
    @IBOutlet weak var topLogoImage: UIImageView!
    @IBOutlet weak var cantLoginLbl: UILabel!
    
    
    @IBOutlet weak var resetMyPassbtn: UIButton!
    @IBOutlet weak var emailIDTF: UITextField!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var backGroundViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hidding Keyboard when user touch any where
        self.hideKeyboardWhenTappedAround()
        
        // Adding some space to left side of textfield
        emailIDTF.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        emailIDTF.delegate = self
        CustomDesignMethod()
        
        resetMyPassbtn.isEnabled = false;
        
        resetMyPassbtn.backgroundColor =  UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        
    }
    
    // MARK: - Button Events
    @IBAction func crossMarkBtnTapped(_ sender: Any) {
        //Mark:- Hidding the navigation bar
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    // MARK: -  Custom Methods...
    func CustomDesignMethod() {
        
        resetMyPassbtn.layer.cornerRadius = 23
        //   resetMyPassbtn.layer.borderWidth = 0.0
        resetMyPassbtn.layer.masksToBounds = true
        // resetMyPassbtn.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        //  resetMyPassbtn.layer.borderWidth = 1.2
        
        emailIDTF.layer.cornerRadius = 6
        emailIDTF.layer.borderWidth = 0.1
        emailIDTF.layer.masksToBounds = true
        emailIDTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        emailIDTF.layer.borderWidth = 1.2
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Mark:- For emai id validation untill
        func isAccountHasValidDetails()  -> Bool {
            
            if(emailIDTF!.text!.isValidEmail1() == true){
                //showAlert(title: "", msg: "Please Enter Valid Email Address")
                return true
                
            }
            return false
            
        }
        
        if isAccountHasValidDetails() == true{
            
            resetMyPassbtn.isEnabled = true;
            resetMyPassbtn.backgroundColor = #colorLiteral(red: 0.2666666667, green: 0.862745098, blue: 0.862745098, alpha: 1)
            
        }
        else
        {
            resetMyPassbtn.isEnabled = false;
            resetMyPassbtn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        return true
    }
    @objc func textFieldDidChange(_ sender: UITextField) {
        
        if emailIDTF.text == ""  {
            
            resetMyPassbtn.isEnabled = false;
            
            resetMyPassbtn.backgroundColor =  UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
            
        }else{
            
            resetMyPassbtn.isEnabled = true;
            resetMyPassbtn.backgroundColor =  UIColor(red: 68.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
            
        }
    }
    // MARK: - Reset Button Event....
    @IBAction func resetMyPasswordBtnTapped(_ sender: Any) {
        
        if emailIDTF.text?.isEmpty == true {
            showAlert(title: "", msg: "Please enter valid email")
            return
        }
        else
        {
            self.forgotPasswordAPICall()
        }
        
    }
    
    // MARK:-  API Call Method...
    func forgotPasswordAPICall()
    {
        SVProgressHUD.show()
        let url = URL(string: API.forgotPasswordAPI)
        
        var request = URLRequest(url: url!)
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue("Bearer", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        
        let eTextStr = emailIDTF.text!
        let postString = "{\"email\":\"\(eTextStr)\"}"
        request.httpBody = postString.data(using: .utf8)
        
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
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                 //   print(json)
                    
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        //  self.showAlert(title: "", msg: "Success")
                        
                        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = mainStoryboard.instantiateViewController(withIdentifier: "RecoverPasswordVC") as! RecoverPasswordVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                    
                }
                else
                {
                    print("json error")
                    
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            
            
        }
        
        task.resume()
    }
    
}

