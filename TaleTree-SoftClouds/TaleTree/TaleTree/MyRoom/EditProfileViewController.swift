//
//  EditProfileViewController.swift
//  TaleTree
//
//  Created by apple on 22/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import TZImagePickerControllerSwift
import SVProgressHUD


class EditProfileViewController: UIViewController,UITextFieldDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var displayImageView: UIImageView!
    
    @IBOutlet var profilePicBtn: UIButton!
    @IBOutlet weak var favColorTF: UITextField!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var favAnimalTF: UITextField!
    
    @IBOutlet weak var editProfileTitle: UILabel!
    @IBOutlet weak var favAnimalErrorLbl: UILabel!
    @IBOutlet weak var favSportErrorLbl: UILabel!
    @IBOutlet weak var favColorErrorLbl: UILabel!
    @IBOutlet weak var favSportTF: UITextField!
    
    
    var favColor:String?
    var favSport:String?
    var favAnimal:String?
    var userDependentId : String?
    var profileImageString:String?
    var profileNamee:String?
    
    var isImageChange:Bool?
    
    var imageView : UIImage?
    
    var profilePicUpdate : Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favSportErrorLbl.isHidden = true
        favColorErrorLbl.isHidden = true
        favAnimalErrorLbl.isHidden = true
        
        hideKeyboardWhenTappedAround()
        
        
        isImageChange = false
        
        // Adding corner radius
        iphoneCustomDesignMethod()
        
        // Adding some space to left side of textfield
        favColorTF.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        favSportTF.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        favAnimalTF.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        
        //Delegate
        favColorTF.delegate = self
        favSportTF.delegate = self
        favAnimalTF.delegate = self
        
        
        favColorTF.isUserInteractionEnabled = true
        favSportTF.isUserInteractionEnabled = true
        favAnimalTF.isUserInteractionEnabled = true
        
        
        //When user tap on textfiled,textfiled border colro turn to another color
        
        favColorTF.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
        favSportTF.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
        favAnimalTF.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
        
        
        displayImageView.layer.cornerRadius = displayImageView.frame.height / 2
        displayImageView.clipsToBounds = true
        
        favColorTF.text = favColor
        favSportTF.text = favSport
        favAnimalTF.text = favAnimal
        profileNameLbl.text = profileNamee
        
        //print(profileImageString)
        
        if profileImageString != nil
        {
            displayImageView.sd_setImage(with: URL(string:profileImageString!), placeholderImage: UIImage(named: "HolderImage"))
        }
        else
        {
            displayImageView.image = UIImage(named: "HolderImage")
        }
        
        // Getting device information wheather ipad or iphone.
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            
            editProfileTitle.font = editProfileTitle.font.withSize(22)
            saveBtn.titleLabel?.font = .systemFont(ofSize: 22)
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: navigationView.frame.size.height-1, width: navigationView.frame.width + 400, height: 1.0)
            bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            navigationView.layer.addSublayer(bottomBorder)
        case .phone:
            editProfileTitle.font = editProfileTitle.font.withSize(16)
            saveBtn.titleLabel?.font = .systemFont(ofSize: 17)
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: navigationView.frame.size.height-1, width: navigationView.frame.width , height: 1.0)
            bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            navigationView.layer.addSublayer(bottomBorder)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: navigationView.frame.size.height-1, width: navigationView.frame.width, height: 1.0)
        bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        navigationView.layer.addSublayer(bottomBorder)
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    // MARK: - Keyboard methods...
    @objc func keyboardWillShow(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 0 - keyboardSize.height
        // self.view.frame.origin.y -= 150
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        // self.view.frame.origin.y += 150
        self.view.frame.origin.y = 0
    }
    
    // MARK: - TextField methods....
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == favColorTF || textField == favSportTF || textField == favAnimalTF  {
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = #colorLiteral(red: 0.2666666667, green: 0.862745098, blue: 0.862745098, alpha: 1)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
    }
    // MARK:- Image picker methods.
    @IBAction func editBtnTapped(_ sender: Any) {
        
        let imagePickerVc = TZImagePickerController(delegate: self, maxImagesCount: 1, columnNumber: 3, pushPhotoPickerVc: true)
        
        imagePickerVc.isSelectOriginalPhoto = true
        
        imagePickerVc.allowTakePicture = true
        
        imagePickerVc.navigationBar.barTintColor = UIColor.black
        
        imagePickerVc.allowPickingVideo = false
        imagePickerVc.allowPickingImage = true
        imagePickerVc.allowPickingOriginalPhoto = false
        imagePickerVc.allowPickingGif = false
        imagePickerVc.allowPickingMultipleVideo = false
        imagePickerVc.minImagesCount = 1
        imagePickerVc.maxImagesCount = 1
        
        
        imagePickerVc.sortAscendingByModificationDate = false
        
        imagePickerVc.showSelectBtn = false
        imagePickerVc.allowCrop = true
        imagePickerVc.needCircleCrop = true
        
        
        imagePickerVc.isStatusBarDefault = false
        
        
        let left: CGFloat = 30;
        let widthHeight: CGFloat = self.view.frame.width - 2 * left
        let top: CGFloat = (self.view.frame.height - widthHeight) / 2
        imagePickerVc.cropRect = CGRect(x: left, y: top, width: widthHeight, height: widthHeight)
        
        imagePickerVc.didFinishPickingPhotosWithInfosHandle = { (photos, assets, isSelectOriginalPhoto, infoArr) -> (Void) in
            
            
            self.imageView = photos[0]
            //  print(self.imageView)
            
            
            self.displayImageView.image = self.imageView
            self.isImageChange = true
            
        }
        
        imagePickerVc.modalPresentationStyle = .fullScreen
        
        self.present(imagePickerVc, animated: true, completion: nil)
        
    }
    
    func iphoneCustomDesignMethod() {
        
        favColorTF.layer.cornerRadius = 6
        favColorTF.layer.borderWidth = 0.1
        favColorTF.layer.masksToBounds = true
        favColorTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        favColorTF.layer.borderWidth = 1.2
        
        favSportTF.layer.cornerRadius = 6
        favSportTF.layer.borderWidth = 0.1
        favSportTF.layer.masksToBounds = true
        favSportTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        favSportTF.layer.borderWidth = 1.2
        
        favAnimalTF.layer.cornerRadius = 6
        favAnimalTF.layer.borderWidth = 0.1
        favAnimalTF.layer.masksToBounds = true
        favAnimalTF.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        favAnimalTF.layer.borderWidth = 1.2
        
    }
    
    // MARK: - Upload API Call Method...
    func uploadAPICall()
    {
        SVProgressHUD.show()
        
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
        }
        
        var urlString = API.uploadingProfilePic
        
        let finalString = urlString + "\(String(describing: userDependentId!))" + "\("/picture")"
        //  print(finalString)
        
        
        var url = URL(string: finalString)!
        let request = NSMutableURLRequest(url: url as URL)
        //  request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        
        let imgData = imageView!.jpegData(compressionQuality: 0.5)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let someDateTime = formatter.string(from: date)
        let fileName = "\(someDateTime).jpg"
       // print(fileName)
        
        request.httpBody = createBody(parameters: [:], boundary: boundary, data:imgData! , mimeType: "image/jpeg", filename: fileName, fieldname: "image")
        
        
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
                    
                    //  print(json)
                    DispatchQueue.main.async {
                        
                        
                        UserDefaults.standard.set("updated", forKey: "UserProfilePic")
                        UserDefaults.standard.synchronize()
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    
                    
                    
                }
                else
                {
                  //  print("favorites error")
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
    }
    
    // MARK: - Button events...
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        
        let deletealert:UIAlertController=UIAlertController(title: "Cancel Editing", message: "Are you sure you want to cancel editing your profile?", preferredStyle: UIAlertController.Style.alert)
        let deleteaction = UIAlertAction(title: "Yes, cancel editing", style: UIAlertAction.Style.destructive)
        {
            UIAlertAction in
            
            self.navigationController?.popViewController(animated: true)
            
        }
        let deletecancel = UIAlertAction(title: "Continue editing", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        deletealert.addAction(deleteaction)
        deletealert.addAction(deletecancel)
        
        self.present(deletealert, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        favoritesAPICall()
    }
    
    @IBAction func profilePicBtnActn(_ sender: Any) {
        
        let imagePickerVc = TZImagePickerController(delegate: self, maxImagesCount: 1, columnNumber: 3, pushPhotoPickerVc: true)
        
        imagePickerVc.isSelectOriginalPhoto = true
        
        
        imagePickerVc.allowTakePicture = true
        
        imagePickerVc.navigationBar.barTintColor = UIColor.black
        
        imagePickerVc.allowPickingVideo = false
        imagePickerVc.allowPickingImage = true
        imagePickerVc.allowPickingOriginalPhoto = false
        imagePickerVc.allowPickingGif = false
        imagePickerVc.allowPickingMultipleVideo = false
        imagePickerVc.minImagesCount = 1
        imagePickerVc.maxImagesCount = 1
        
        
        imagePickerVc.sortAscendingByModificationDate = false
        
        imagePickerVc.showSelectBtn = false
        imagePickerVc.allowCrop = true
        imagePickerVc.needCircleCrop = true
        
        imagePickerVc.isStatusBarDefault = false
        
        
        let left: CGFloat = 30;
        let widthHeight: CGFloat = self.view.frame.width - 2 * left
        let top: CGFloat = (self.view.frame.height - widthHeight) / 2
        imagePickerVc.cropRect = CGRect(x: left, y: top, width: widthHeight, height: widthHeight)
        
        imagePickerVc.didFinishPickingPhotosWithInfosHandle = { (photos, assets, isSelectOriginalPhoto, infoArr) -> (Void) in
            
            self.imageView = photos[0]
            //  print(self.imageView)
            
            self.displayImageView.image = self.imageView
            self.isImageChange = true
            
        }
        
        
        imagePickerVc.modalPresentationStyle = .fullScreen
        
        self.present(imagePickerVc, animated: true, completion: nil)
        
        
        
    }
    // MARK: - Custom Method
    @objc func textFieldDidChange(_ sender: UITextField) {
        
        if favColorTF.text == "" || favSportTF.text == "" || favAnimalTF.text == "" {
            
            saveBtn.isEnabled = false
            
            saveBtn.setTitleColor(.gray, for: .normal)
            
        }else{
            
            saveBtn.isEnabled = true
            
            saveBtn.setTitleColor(#colorLiteral(red: 0.0/255, green: 122.0/255, blue: 255.0/255, alpha: 1.0), for: .normal)
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == favColorTF || textField == favSportTF || textField == favAnimalTF  {
            let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
            if newLength <= 12 {
                return true
            }
            else
            {
                return false
            }
            
        }
        return false
    }
    
    // MARK: - Favorites API Call
    func favoritesAPICall()
    {
        
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
        }
        
        let userID = userDependentId
        //  print(userID)
        
        var url = URL(string: API.favoritesAPI)!
        url.appendPathComponent(userID!)
      //  print(url)
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PATCH"
        
        let colorStr = favColorTF.text!
        let sportStr = favSportTF.text!
        let animalStr = favAnimalTF.text!
        
        let parameters: [String: Any] = [
            "favorites": [colorStr, sportStr, animalStr]
        ]
        let newParams : [String: Any] = ["profile": parameters]
      //  print(newParams)
        
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
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    
                    let jsonCode = json["result_code"] as! Int
                    
                    let jsonStr = "\(jsonCode)"
                    
                    if jsonStr == "1"
                    {
                        DispatchQueue.main.async {
                            if self.isImageChange == true
                            {
                                self.uploadAPICall()
                            }
                            else
                            {
                                
                                UserDefaults.standard.set("updated", forKey: "UserProfilePic")
                                UserDefaults.standard.synchronize()
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            
                            let resStr = json["error_info"]
                            
                            let string = "\(String(describing: resStr!))"
                            
                            print(string)
                            
                            var stringResult = string.contains("\(String(describing: self.favColorTF.text!))")
                            
                            //    print(stringResult)
                            
                            if stringResult == true
                            {
                                self.favColorErrorLbl.isHidden = false
                            }
                            else
                            {
                                self.favColorErrorLbl.isHidden = true
                            }
                            
                            var strResult = string.contains("\(String(describing: self.favSportTF.text!))")
                            
                            if strResult == true
                            {
                                self.favSportErrorLbl.isHidden = false
                            }
                            else
                            {
                                self.favSportErrorLbl.isHidden = true
                            }
                            
                            var resul = string.contains("\(String(describing: self.favAnimalTF.text!))")
                            if resul == true
                            {
                                self.favAnimalErrorLbl.isHidden = false
                            }
                            else
                            {
                                self.favAnimalErrorLbl.isHidden = true
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
    // MARK: - Custom methods...
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String, fieldname: String) -> Data {
        
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        //  body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        
        body.appendString("Content-Disposition: form-data; name=\"\(fieldname)\"; filename=\"\(filename)\"\r\n")
        
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
}

