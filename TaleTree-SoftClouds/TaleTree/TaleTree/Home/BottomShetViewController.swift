//
//  BottomShetViewController.swift
//  TaleTree
//
//  Created by UFL on 06/01/21.
//  Copyright © 2021 UnfoldLabs. All rights reserved.
//

import UIKit
import BottomPopup
import SVProgressHUD

class BottomShetViewController: BottomPopupViewController {
    
    @IBOutlet var dismissBtn: UIButton!
    
    @IBOutlet var selectLbl: UILabel!
    
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var commentRemoveBtn: UIButton!
    
    @IBOutlet var selectCommentBtn: UIButton!
    @IBOutlet var beautyBtn: UIButton!
    @IBOutlet var kindBtn: UIButton!
    @IBOutlet var coolBtn: UIButton!
    @IBOutlet var quiteBtn: UIButton!
    @IBOutlet var superBtn: UIButton!
    @IBOutlet var colorsBtn: UIButton!
    @IBOutlet var reallyFunnyBtn: UIButton!
    @IBOutlet var amazingBtn: UIButton!
    
    
    var selectedCommentId : Int?
    
    var selectCreationID : Int?
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    
    var comingFromHome : Bool?
    var comingFromMyRoom : Bool?
    
    
    override var popupHeight: CGFloat { return height ?? CGFloat(300) }
    
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    // override var popupDimmingViewAlpha: CGFloat { return BottomPopupConstants.kDimmingViewDefaultAlphaValue }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectLbl.layer.cornerRadius = 8
        self.selectLbl.layer.borderWidth = 1
        self.selectLbl.layer.borderColor = UIColor.lightGray.cgColor
        self.selectLbl.layer.masksToBounds = true
        
        
        self.selectCommentBtn.layer.cornerRadius = 8
        self.selectCommentBtn.layer.borderWidth = 1
        self.selectCommentBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.selectCommentBtn.layer.masksToBounds = true
        self.selectCommentBtn.isHidden = true
        
        self.commentRemoveBtn.isHidden = true
        
        customBtnDesign()
        
    }
    // MARK: - Custom design method..
    func customBtnDesign()
    {
        self.beautyBtn.layer.cornerRadius = 8
        self.beautyBtn.layer.borderWidth = 0
        //self.beautyBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.beautyBtn.layer.masksToBounds = true
        beautyBtn.setTitle("Very beautiful ❤️", for: .normal)
        
        self.kindBtn.layer.cornerRadius = 8
        self.kindBtn.layer.borderWidth = 0
        // self.kindBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.kindBtn.layer.masksToBounds = true
        kindBtn.setTitle("Kind thoughts 🌹", for: .normal)
        
        self.coolBtn.layer.cornerRadius = 8
        self.coolBtn.layer.borderWidth = 0
        // self.coolBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.coolBtn.layer.masksToBounds = true
        coolBtn.setTitle("So cool 🤩", for: .normal)
        
        self.quiteBtn.layer.cornerRadius = 8
        self.quiteBtn.layer.borderWidth = 0
        //  self.quiteBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.quiteBtn.layer.masksToBounds = true
        quiteBtn.setTitle("Quite interesting 😃", for: .normal)
        
        
        self.superBtn.layer.cornerRadius = 8
        self.superBtn.layer.borderWidth = 0
        //   self.superBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.superBtn.layer.masksToBounds = true
        superBtn.setTitle("Super creative 👏", for: .normal)
        
        
        self.colorsBtn.layer.cornerRadius = 8
        self.colorsBtn.layer.borderWidth = 0
        //      self.colorsBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.colorsBtn.layer.masksToBounds = true
        colorsBtn.setTitle("Great colors 🌈", for: .normal)
        
        self.reallyFunnyBtn.layer.cornerRadius = 8
        self.reallyFunnyBtn.layer.borderWidth = 0
        //     self.reallyFunnyBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.reallyFunnyBtn.layer.masksToBounds = true
        reallyFunnyBtn.setTitle("Really funny 😆", for: .normal)
        
        self.amazingBtn.layer.cornerRadius = 8
        self.amazingBtn.layer.borderWidth = 0
        //    self.amazingBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.amazingBtn.layer.masksToBounds = true
        amazingBtn.setTitle("Amazing details 👀", for: .normal)
        
    }
    // MARK: - Button Events...
    @IBAction func dismissBtnActn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func sendBtnActn(_ sender: Any) {
        
        if self.selectCommentBtn.isHidden == true
        {
            self.showAlertView(title: "", msg: "Select a comment")
        }
        else
        {
            
           // print(selectedCommentId as Any)
            
            self.commentSendAPICall(selectedCreationId: selectCreationID!)
            
        }
        
    }
    
    @IBAction func removeBtnActn(_ sender: Any) {
        self.selectCommentBtn.isHidden = true
        self.commentRemoveBtn.isHidden = true
        kindBtn.layer.borderWidth = 0.0
        coolBtn.layer.borderWidth = 0.0
        quiteBtn.layer.borderWidth = 0.0
        superBtn.layer.borderWidth = 0.0
        colorsBtn.layer.borderWidth = 0.0
        reallyFunnyBtn.layer.borderWidth = 0.0
        amazingBtn.layer.borderWidth = 0.0
        beautyBtn.layer.borderWidth = 0.0
        
    }
    
    @IBAction func beautyBtnActn(_ sender: UIButton) {
        
        self.selectCommentBtn.isHidden = false
        self.commentRemoveBtn.isHidden = false
        
        kindBtn.layer.borderWidth = 0.0
        coolBtn.layer.borderWidth = 0.0
        quiteBtn.layer.borderWidth = 0.0
        superBtn.layer.borderWidth = 0.0
        colorsBtn.layer.borderWidth = 0.0
        reallyFunnyBtn.layer.borderWidth = 0.0
        amazingBtn.layer.borderWidth = 0.0
        
        let btnTitle = sender.title(for: .normal)
        // print(btnTitle)
        
        selectCommentBtn.setTitle(btnTitle!, for: .normal)
        selectCommentBtn.backgroundColor = UIColor(red: 251/255, green: 212/255, blue: 166/255, alpha: 1.0)
        
        
        beautyBtn.layer.borderColor = UIColor(red: 240/255, green: 173/255, blue: 95/255, alpha: 1.0).cgColor
        beautyBtn.layer.borderWidth = 1
        
        // #FBD4A6  F0AD5F
        
        selectedCommentId = 8
    }
    
    @IBAction func kindBtnActn(_ sender: UIButton) {
        self.selectCommentBtn.isHidden = false
        self.commentRemoveBtn.isHidden = false
        
        coolBtn.layer.borderWidth = 0.0
        quiteBtn.layer.borderWidth = 0.0
        superBtn.layer.borderWidth = 0.0
        colorsBtn.layer.borderWidth = 0.0
        reallyFunnyBtn.layer.borderWidth = 0.0
        amazingBtn.layer.borderWidth = 0.0
        beautyBtn.layer.borderWidth = 0.0
        
        let btnTitle = sender.title(for: .normal)
        // print(btnTitle)
        selectCommentBtn.setTitle(btnTitle!, for: .normal)
        selectCommentBtn.backgroundColor = UIColor(red: 205/255, green: 252/255, blue: 210/255, alpha: 1.0)
        
        //  #CDFCD2 7CDFB7
        
        kindBtn.layer.borderColor = UIColor(red: 124/255, green: 223/255, blue: 183/255, alpha: 1.0).cgColor
        kindBtn.layer.borderWidth = 1
        
        selectedCommentId = 7
    }
    
    @IBAction func coolBtnActn(_ sender: UIButton) {
        self.selectCommentBtn.isHidden = false
        self.commentRemoveBtn.isHidden = false
        
        let btnTitle = sender.title(for: .normal)
        // print(btnTitle)
        
        selectCommentBtn.setTitle(btnTitle!, for: .normal)
        selectCommentBtn.backgroundColor = UIColor(red: 243/255, green: 246/255, blue: 180/255, alpha: 1.0)
        coolBtn.layer.borderColor = UIColor(red: 218/255, green: 225/255, blue: 86/255, alpha: 1.0).cgColor
        // #F3F6B4 DAE156
        coolBtn.layer.borderWidth = 1
        
        kindBtn.layer.borderWidth = 0.0
        quiteBtn.layer.borderWidth = 0.0
        superBtn.layer.borderWidth = 0.0
        colorsBtn.layer.borderWidth = 0.0
        reallyFunnyBtn.layer.borderWidth = 0.0
        amazingBtn.layer.borderWidth = 0.0
        beautyBtn.layer.borderWidth = 0.0
        
        selectedCommentId = 6
    }
    
    @IBAction func quiteBtnActn(_ sender: UIButton) {
        self.selectCommentBtn.isHidden = false
        self.commentRemoveBtn.isHidden = false
        
        let btnTitle = sender.title(for: .normal)
        // print(btnTitle)
        
        selectCommentBtn.setTitle(btnTitle!, for: .normal)
        selectCommentBtn.backgroundColor = UIColor(red: 213/255, green: 213/255, blue: 250/255, alpha: 1.0)
        quiteBtn.layer.borderColor = UIColor(red: 134/255, green: 134/255, blue: 231/255, alpha: 1.0).cgColor
        // #D5D5FA #8686E7
        
        quiteBtn.layer.borderWidth = 1
        
        kindBtn.layer.borderWidth = 0.0
        coolBtn.layer.borderWidth = 0.0
        superBtn.layer.borderWidth = 0.0
        colorsBtn.layer.borderWidth = 0.0
        reallyFunnyBtn.layer.borderWidth = 0.0
        amazingBtn.layer.borderWidth = 0.0
        beautyBtn.layer.borderWidth = 0.0
        
        selectedCommentId = 5
    }
    
    @IBAction func superBtnActn(_ sender: UIButton) {
        self.selectCommentBtn.isHidden = false
        self.commentRemoveBtn.isHidden = false
        
        let btnTitle = sender.title(for: .normal)
        // print(btnTitle)
        
        selectCommentBtn.setTitle(btnTitle!, for: .normal)
        selectCommentBtn.backgroundColor = UIColor(red: 254/255, green: 199/255, blue: 228/255, alpha: 1.0)
        superBtn.layer.borderColor = UIColor(red: 244/255, green: 125/255, blue: 188/255, alpha: 1.0).cgColor
        //  #FEC7E4 F47DBC
        
        superBtn.layer.borderWidth = 1
        kindBtn.layer.borderWidth = 0.0
        coolBtn.layer.borderWidth = 0.0
        quiteBtn.layer.borderWidth = 0.0
        colorsBtn.layer.borderWidth = 0.0
        reallyFunnyBtn.layer.borderWidth = 0.0
        amazingBtn.layer.borderWidth = 0.0
        beautyBtn.layer.borderWidth = 0.0
        
        selectedCommentId = 4
    }
    @IBAction func greatColorsBtnActn(_ sender: UIButton) {
        self.selectCommentBtn.isHidden = false
        self.commentRemoveBtn.isHidden = false
        
        let btnTitle = sender.title(for: .normal)
        // print(btnTitle)
        
        selectCommentBtn.setTitle(btnTitle!, for: .normal)
        selectCommentBtn.backgroundColor = UIColor(red: 190/255, green: 228/255, blue: 255/255, alpha: 1.0)
        colorsBtn.layer.borderColor = UIColor(red: 112/255, green: 180/255, blue: 255/255, alpha: 1.0).cgColor
        //  #BEE4FF 70B4FF
        
        colorsBtn.layer.borderWidth = 1
        kindBtn.layer.borderWidth = 0.0
        coolBtn.layer.borderWidth = 0.0
        quiteBtn.layer.borderWidth = 0.0
        superBtn.layer.borderWidth = 0.0
        reallyFunnyBtn.layer.borderWidth = 0.0
        amazingBtn.layer.borderWidth = 0.0
        beautyBtn.layer.borderWidth = 0.0
        
        selectedCommentId = 3
    }
    @IBAction func funnyBtnActn(_ sender: UIButton) {
        self.selectCommentBtn.isHidden = false
        self.commentRemoveBtn.isHidden = false
        
        let btnTitle = sender.title(for: .normal)
        // print(btnTitle)
        
        selectCommentBtn.setTitle(btnTitle!, for: .normal)
        selectCommentBtn.backgroundColor = UIColor(red: 175/255, green: 241/255, blue: 239/255, alpha: 1.0)
        reallyFunnyBtn.layer.borderColor = UIColor(red: 86/255, green: 210/255, blue: 205/255, alpha: 1.0).cgColor
        //  #AFF1EF 56D2CD
        
        reallyFunnyBtn.layer.borderWidth = 1
        kindBtn.layer.borderWidth = 0.0
        coolBtn.layer.borderWidth = 0.0
        quiteBtn.layer.borderWidth = 0.0
        superBtn.layer.borderWidth = 0.0
        colorsBtn.layer.borderWidth = 0.0
        amazingBtn.layer.borderWidth = 0.0
        beautyBtn.layer.borderWidth = 0.0
        selectedCommentId = 2
    }
    @IBAction func amazingBtnActn(_ sender: UIButton) {
        self.selectCommentBtn.isHidden = false
        self.commentRemoveBtn.isHidden = false
        
        let btnTitle = sender.title(for: .normal)
        // print(btnTitle)
        
        selectCommentBtn.setTitle(btnTitle!, for: .normal)
        selectCommentBtn.backgroundColor = UIColor(red: 250/255, green: 234/255, blue: 148/255, alpha: 1.0)
        amazingBtn.layer.borderColor = UIColor(red: 255/255, green: 217/255, blue: 111/255, alpha: 1.0).cgColor
        
        amazingBtn.layer.borderWidth = 1
        kindBtn.layer.borderWidth = 0.0
        coolBtn.layer.borderWidth = 0.0
        quiteBtn.layer.borderWidth = 0.0
        superBtn.layer.borderWidth = 0.0
        colorsBtn.layer.borderWidth = 0.0
        reallyFunnyBtn.layer.borderWidth = 0.0
        beautyBtn.layer.borderWidth = 0.0
        //  #FAEA94 FFD96F
        
        selectedCommentId = 1
    }
    
    // MARK: - API Call Method...
    func getCommentsAPICallMethod()
    {
        //   SVProgressHUD.show()
        
        let url = URL(string: API.homeFeedsListAPI)
        
        
        let queryItems = [
            URLQueryItem(name: "limit", value: "10")
        ]
        
        
        let newUrl = url!.appending(queryItems)!
        
        var request = URLRequest(url: newUrl)
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            
            guard let data = data,
                
                let response = response as? HTTPURLResponse,
                
                error == nil else {                                              // check for fundamental networking error
                    
                    print("error", error ?? "Unknown error")
                    
                    return
                    
            }
            
            do {
                
                SVProgressHUD.dismiss()
                
                let feedsRespone = try JSONDecoder().decode(feedsAPIStatus.self, from: data)
                
                //
                //      print(feedsRespone as Any)
                
                if let fdata = try? JSONEncoder().encode(feedsRespone.data) {
                    
                    UserDefaults.standard.set(fdata, forKey: "feedData")
                }
                
                guard let ffData = UserDefaults.standard.value(forKey: "feedData") as? Data,
                    
                    let feedsData = try? JSONDecoder().decode([feedsList].self, from: ffData) else
                    
                {
                    return
                }
                
                if feedsData.count > 0
                {
                    
                }
                else
                {
                    print("No feeds")
                    
                }
                
            }
                
            catch let error {
                print(error.localizedDescription)
                
            }
            
        }
        task.resume()
        
    }
    
    func commentSendAPICall(selectedCreationId: Int)
    {
        //    SVProgressHUD.show()
        
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
        }
        
        let url = URL(string: API.commentSendAPI)
        
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        
        
        let parameters: [String: Any] = [
            "creation_id": "\(selectedCreationId)",
            "compliment_id": selectedCommentId!
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        
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
                    DispatchQueue.main.async {
                        
                        
                        if self.comingFromHome == true {
                            for (index,each) in SharedData.data.feedsData!.enumerated() {
                                if each.creation_id == selectedCreationId
                                {
                                    SharedData.data.feedsData![index].comment_count =   SharedData.data.feedsData![index].comment_count! + 1
                                }
                            }
                        }
                        
                        if self.comingFromMyRoom == true {
                            for (index,each) in SharedData.data.creationsDataRoom!.enumerated() {
                                if each.id == selectedCreationId
                                {
                                    SharedData.data.creationsDataRoom![index].comment_count =   SharedData.data.creationsDataRoom![index].comment_count! + 1
                                }
                            }
                        }
                        
                        
                        UserDefaults.standard.set("bottomBack", forKey: "BottomBack")
                        UserDefaults.standard.synchronize()
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
                else
                {
                    //print("comment send error")
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
    }
    
}
