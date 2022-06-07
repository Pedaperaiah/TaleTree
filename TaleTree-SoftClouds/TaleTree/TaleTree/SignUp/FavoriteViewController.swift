//
//  FavoriteViewController.swift
//  TaleTree
//
//  Created by apple on 18/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import  IQKeyboardManagerSwift
import SVProgressHUD

class FavoriteViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var myFavColorLbl: UILabel!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var myFavColorTF: UITextField!
    @IBOutlet weak var myFavAnimalErrorLbl: UILabel!
    
    @IBOutlet weak var viewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var myFavAnimalTF: UITextField!
    @IBOutlet weak var myFavSportErrorLbl: UILabel!
    @IBOutlet weak var myFavSportTF: UITextField!
    @IBOutlet weak var myFavSportLbl: UILabel!
    @IBOutlet weak var myFavColorErrorLbl: UILabel!
    @IBOutlet weak var myFavAnimalLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var letsGetStartedLbl: UILabel!
    
    @IBOutlet weak var imageTopConstant: NSLayoutConstraint!
    @IBOutlet weak var saveAndContinueBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Hidding Keyboard when user touch any where
        self.hideKeyboardWhenTappedAround()
        
        // Adding some space to left side of textfield
        myFavColorTF.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        myFavSportTF.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        myFavAnimalTF.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        // Adding corner radius
        iphoneCustomDesignMethod()
        
        myFavColorErrorLbl.text = "Your input contains characters or words we don't allow. Please try again"
        myFavSportErrorLbl.text = "Your input contains characters or words we don't allow. Please try again"
        myFavAnimalErrorLbl.text = "Your input contains characters or words we don't allow. Please try again"
        
        myFavColorErrorLbl.isHidden = true
        myFavSportErrorLbl.isHidden = true
        myFavAnimalErrorLbl.isHidden = true
        
        myFavAnimalTF.delegate = self
        myFavSportTF.delegate = self
        myFavColorTF.delegate = self
        
        //Mark:- if any textfield is empty...disable save and continue button
        saveAndContinueBtn.isEnabled = false;
        saveAndContinueBtn.backgroundColor =  UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        myFavColorTF.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
        myFavSportTF.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
        myFavAnimalTF.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
        
        
        // Getting device information wheather ipad or iphone.
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            imageTopConstant.constant = 100
            viewHeightConstant.constant = 700
            
          //  print(viewHeightConstant.constant)
            print("iPad style UI")
        case .phone:
            imageTopConstant.constant = 30
            viewHeightConstant.constant = 817
            print("iPhone and iPod touch style UI")
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    // MARK: - Custom Method
    @objc func textFieldDidChange(_ sender: UITextField) {
        
        if myFavColorTF.text == "" || myFavSportTF.text == "" || myFavAnimalTF.text == "" {
            
            saveAndContinueBtn.isEnabled = false;
            saveAndContinueBtn.backgroundColor =  UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
            
        }else{
            
            saveAndContinueBtn.isEnabled = true;
            saveAndContinueBtn.backgroundColor =  UIColor(red: 68.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
            
        }
        
    }
    //MARK:- when user tap on textfiled ..textfiled corner color changes
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if myFavColorTF.text == "" || myFavSportTF.text == "" || myFavAnimalTF.text == "" {
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = #colorLiteral(red: 0.2666666667, green: 0.862745098, blue: 0.862745098, alpha: 1)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        
    }
    func iphoneCustomDesignMethod() {
        
        myFavColorTF.layer.cornerRadius = 6
        myFavColorTF.layer.borderWidth = 0.1
        myFavColorTF.layer.masksToBounds = true
        myFavColorTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        myFavColorTF.layer.borderWidth = 1.2
        
        myFavSportTF.layer.cornerRadius = 6
        myFavSportTF.layer.borderWidth = 0.1
        myFavSportTF.layer.masksToBounds = true
        myFavSportTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        myFavSportTF.layer.borderWidth = 1.2
        
        myFavAnimalTF.layer.cornerRadius = 6
        myFavAnimalTF.layer.borderWidth = 0.1
        myFavAnimalTF.layer.masksToBounds = true
        myFavAnimalTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        myFavAnimalTF.layer.borderWidth = 1.2
        
        saveAndContinueBtn.layer.cornerRadius = 23
        saveAndContinueBtn.layer.borderWidth = 0.1
        saveAndContinueBtn.layer.masksToBounds = true
        
    }
    
    // MARK: -  Button Event...
    @IBAction func saveAndContinueBtnTapped(_ sender: Any) {
        
        self.favoritesAPICall()
        
    }
    // MARK: - Favorites API Call
    func favoritesAPICall()
    {
        SVProgressHUD.show()
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
        }
        
        guard let Ldata = UserDefaults.standard.value(forKey: "loggedUserData") as? Data,
            let loginData = try? JSONDecoder().decode(userProfileDetails.self, from: Ldata) else
        {
            return
        }
        
       // print(loginData.id as Any)
        
        
        
        let userID = "\(loginData.id!)"
        
        var url = URL(string: API.favoritesAPI)!
        url.appendPathComponent(userID)
        //     print(url)
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PATCH"
        
        let colorStr = myFavColorTF.text!
        let sportStr = myFavSportTF.text!
        let animalStr = myFavAnimalTF.text!
        
        let parameters: [String: Any] = [
            "favorites": [colorStr, sportStr, animalStr]
        ]
        let newParams : [String: Any] = ["profile": parameters]
        print(newParams)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: newParams, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        //  print(jsonString)
        
        request.httpBody = jsonString.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
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
                    //    print(json)
                    
                    
                    let jsonCode = json["result_code"] as! Int
                    
                    let jsonStr = "\(jsonCode)"
                    
                    if jsonStr == "1"
                    {
                        DispatchQueue.main.async {
                            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            
                            let resStr = json["error_info"]
                            
                            let string = "\(String(describing: resStr!))"
                            
                          //  print(string)
                            
                            var stringResult = string.contains("\(String(describing: self.myFavColorTF.text!))")
                            
                         //   print(stringResult)
                            
                            if stringResult == true
                            {
                                self.myFavColorErrorLbl.isHidden = false
                            }
                            else
                            {
                                self.myFavColorErrorLbl.isHidden = true
                            }
                            
                            var strResult = string.contains("\(String(describing: self.myFavSportTF.text!))")
                            
                            if strResult == true
                            {
                                self.myFavSportErrorLbl.isHidden = false
                            }
                            else
                            {
                                self.myFavSportErrorLbl.isHidden = true
                            }
                            
                            var resul = string.contains("\(String(describing: self.myFavAnimalTF.text!))")
                            if resul == true
                            {
                                self.myFavAnimalErrorLbl.isHidden = false
                            }
                            else
                            {
                                self.myFavAnimalErrorLbl.isHidden = true
                            }
                            
                        }
                        
                    }
                }
                else
                {
                    print("favorites error")
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
    }
    
}
