//
//  NewCreationViewController.swift
//  TaleTree
//
//  Created by UFL on 19/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import TZImagePickerControllerSwift
import Photos
import SVProgressHUD
import Alamofire

class NewCreationViewController: UIViewController, UIImagePickerControllerDelegate, UICollectionViewDelegate, UIScrollViewDelegate, UITextViewDelegate, TZImagePickerControllerDelegate {
    
    @IBOutlet var imageScrollView: UIScrollView!
    @IBOutlet var bgPictureView: UIView!
    
    @IBOutlet var numberingPageLbl: UILabel!
    @IBOutlet var uploadBtn: UIButton!
    @IBOutlet var tittleTxtView: UITextView!
    @IBOutlet var tittleNumberCountLbl: UILabel!
    
    @IBOutlet var descriptionCountLbl: UILabel!
    @IBOutlet var descriptionTxtView: UITextView!
    @IBOutlet var creationSubmitBtn: UIButton!
    
    var selectedPhotos: [UIImage?] = []
    
    var selectedAssets = [Any]()
    
    var imagesButtonFrameCount : Int?
    var imagesButton = UIButton()
    
    var imagesCloseButton = UIButton()
    var pageControl = UIPageControl()
    
    var selectedChallengeID : Int?
    
    var photosCount: Int = 0
    
    var userFromchallenges : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "New Creation"
        
        
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        if loginOrNotFlag == "loginYes"
        {
            
        }else
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        self.hideKeyboardWhenTappedAround()
        self.imageScrollView.delegate = self
        
        self.tittleTxtView.delegate = self
        self.descriptionTxtView.delegate = self
        
        self.CustomDesign()
        
        if selectedPhotos.count == 0 {
            self.numberingPageLbl.isHidden = true
            
            self.creationSubmitBtn.isUserInteractionEnabled = false
            // self.submitBtn.backgroundColor = UIColor.gray
        }
        
        
        if tittleTxtView.text == "Create a name for your work" {
            self.tittleNumberCountLbl.text = "0/40"
            
        }
        
        if descriptionTxtView.text == "Tell us more about this creation" {
            self.descriptionCountLbl.text = "0/200"
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //  userFromchallenges = false
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    // MARK: -  Custom Methods...
    func CustomDesign ()
    {
        bgPictureView.layer.cornerRadius = 8.0
        bgPictureView.layer.borderWidth = 1.0
        bgPictureView.layer.masksToBounds = true
        bgPictureView.layer.borderColor = UIColor.clear.cgColor
        bgPictureView.clipsToBounds = true
        
        self.creationSubmitBtn.layer.cornerRadius = 22
        creationSubmitBtn.layer.masksToBounds = true
    }
    
    func setLayer(textfield:UITextView)
    {
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.init(red:176.0/255.0, green:176.0/255.0, blue:176.0/255.0, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: textfield.frame.size.height - width, width:  self.view.frame.size.width-10, height: textfield.frame.size.height)
        border.borderWidth = width
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
    }
    
    // MARK: -  Text View Delegate Methods...
    func textViewDidChange(_ textView: UITextView)
    {
        
        if textView == tittleTxtView {
            
            textView.text = String(textView.text.prefix(39))
        }
        else if (textView == descriptionTxtView)
        {
            textView.text = String(textView.text.prefix(199))
            
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == tittleTxtView {
            
            if tittleTxtView.text == "Create a name for your work" {
                tittleTxtView.text = ""
            }
            else{
                
            }
            
        }
        else if (textView == descriptionTxtView)
        {
            if descriptionTxtView.text == "Tell us more about this creation" {
                descriptionTxtView.text = ""
            }
            else{
                
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
      //  print("print2")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(textView == tittleTxtView){
            
            let strLength = textView.text?.count ?? 0
            let lngthToAdd = text.count
            let lengthCount = strLength + lngthToAdd
            self.tittleNumberCountLbl.text = "\(lengthCount)/40"
        }
        else if (textView == descriptionTxtView)
        {
            
            let strLength = textView.text?.count ?? 0
            let lngthToAdd = text.count
            let lengthCount = strLength + lngthToAdd
            self.descriptionCountLbl.text = "\(lengthCount)/200"
            
        }
        
        return true
        
    }
    // MARK: -  Custom images adding to scroll method..
    func addPicturesToScrollView()
    {
        
        imageScrollView.delegate = self
        imageScrollView.isPagingEnabled = true
        imageScrollView.contentMode = .scaleAspectFill
        imageScrollView.bounces = false
        
        bgPictureView.contentMode = .scaleAspectFill
        
        
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.alwaysBounceVertical = false
        imageScrollView.alwaysBounceHorizontal = false
        
        let subviews = imageScrollView.subviews as? [AnyHashable]
        
        for button in subviews ?? [] {
            guard let button = button as? UIButton else {
                continue
            }
            if button is UIButton {
                
                if selectedPhotos.count == 0 {
                    
                    self.creationSubmitBtn.isUserInteractionEnabled = false
                    
                    self.numberingPageLbl.isHidden = true
                    
                    creationSubmitBtn.backgroundColor =  UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
                    self.creationSubmitBtn.titleLabel?.textColor = UIColor.black
                    
                    button.removeFromSuperview()
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        bgPictureView.frame = CGRect(x: 135, y: 5, width: 310, height: 300)
                    } else {
                        bgPictureView.frame = CGRect(x: 55, y: 5, width: 310, height: 300)
                    }
                    
                    imageScrollView.addSubview(bgPictureView)
                } else {
                    button.removeFromSuperview()
                }
            }
        }
        
        
        imagesButtonFrameCount = 0
        for i in 0..<selectedPhotos.count {
            
            imagesButton = UIButton(type: .custom)
            imagesCloseButton = UIButton(type: .custom)
            
            imagesButton.frame = CGRect(x: imagesButtonFrameCount! + 10, y: 5, width: 310, height: 300)
            
            imagesCloseButton.frame = CGRect(x: imagesButtonFrameCount! + 275, y: 15, width: 25, height: 25)
            
            //  imagesButton.setImage(selectedPhotos[i], for: .normal)
            
            
            let size = CGSize(width: 600, height: 600)
            let newImage : UIImage = resizeImage(image: selectedPhotos[i]!, targetSize: size)
            
            imagesButton.frame = CGRect(x: imagesButtonFrameCount! + 10, y: 5, width: 310, height: 300)
            
            imagesCloseButton.frame = CGRect(x: imagesButtonFrameCount! + 275, y: 15, width: 25, height: 25)
            
            //    imagesButton.setImage(selectedPhotos[i], for: .normal)
            
            imagesButton.setImage(newImage, for: .normal)
            
            imagesButton.contentMode = .scaleAspectFill
            
            imagesCloseButton.setImage(UIImage(named: "picDelete.png"), for: .normal)
            
            imagesCloseButton.addTarget(self, action: #selector(imagesCloseButtonAction(_:)), for: .touchUpInside)
            
            imagesCloseButton.tag = i
            imagesButton.layer.cornerRadius = 5.0
            imagesButton.layer.borderWidth = 1.0
            imagesButton.layer.masksToBounds = false
            imagesButton.layer.borderColor = UIColor.clear.cgColor
            imagesButton.clipsToBounds = true
            imageScrollView.addSubview(imagesButton)
            imageScrollView.addSubview(imagesCloseButton)
            imagesButtonFrameCount = imagesButtonFrameCount! + 320
            
            bgPictureView.frame = CGRect(x: imagesButtonFrameCount! + 10, y: 5, width: 310, height: 300)
            
            imageScrollView.addSubview(bgPictureView)
            
            imageScrollView.contentSize = CGSize(width: imagesButtonFrameCount! + 335, height: 240)
            
            let imageCount: Int =  (Int(imageScrollView.contentOffset.x  / 330)) + 1
            
         //   print(Int(imageScrollView.contentOffset.x))
            
            
            if imageCount == self.selectedPhotos.count + 1
            {
                // print("no need show")
                self.numberingPageLbl.text = ""
            }
            else
            {
                //  print(imageCount)
                
                if imageCount == 1 && self.selectedPhotos.count == 1
                {
                    self.numberingPageLbl.text = "1 image"
                }
                else
                {
                    self.numberingPageLbl.text = "\(imageCount) of \(self.selectedPhotos.count) images"
                }
                
            }
        }
        
    }
    @objc func imagesCloseButtonAction(_ sender: UIButton) {
        
        selectedPhotos.remove(at: sender.tag)
        selectedAssets.remove(at: sender.tag)
        
        addPicturesToScrollView()
    }
    // MARK: - Resize Method
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            
        } else {
            
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        return newImage!
        
    }
    
    // MARK:- Scroll swipe method..
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let width = scrollView.frame.width - 15
        var currentPageNumber : Int?
        currentPageNumber = Int(round(scrollView.contentOffset.x/width))
       // print("CurrentPage:\(String(describing: currentPageNumber))")
        
        if currentPageNumber == 0 as Int as Int
        {
            
            if self.selectedPhotos.count == 1 {
                
                self.numberingPageLbl.text = "1 image"
            }
            else
            {
                self.numberingPageLbl.text = "\(currentPageNumber! + 1) of \(self.selectedPhotos.count) images"
            }
            
        }
        else
        {
            if self.selectedPhotos.count == 1 {
                
                if currentPageNumber! > 0
                {
                    self.numberingPageLbl.text = ""
                }
                else
                {
                    self.numberingPageLbl.text = "1 image"
                }
                
            }
            else
            {
                
                if self.selectedPhotos.count == currentPageNumber!
                {
                    self.numberingPageLbl.text = ""
                }
                else
                {
                    self.numberingPageLbl.text = "\(currentPageNumber! + 1) of \(self.selectedPhotos.count) images"
                }
                
            }
            
        }
    }
    
    
    // MARK: -  Button Events...
    @IBAction func uploadBtnActn(_ sender: Any) {
        
        
       // print(self.userFromchallenges)
        //  self.userFromchallenges == true
        
        
        let imagePickerVc = TZImagePickerController(delegate: self, maxImagesCount: 20, columnNumber: 3, pushPhotoPickerVc: true)
        
        imagePickerVc.isSelectOriginalPhoto = true
        
        if (self.selectedPhotos.count > 0) {
            imagePickerVc.selectedAssets = self.selectedAssets as! [PHAsset]
        }
        
        imagePickerVc.allowTakePicture = true
        
        imagePickerVc.navigationBar.barTintColor = UIColor.black
        
        imagePickerVc.allowPickingVideo = false
        imagePickerVc.allowPickingImage = true
        imagePickerVc.allowPickingOriginalPhoto = false
        imagePickerVc.allowPickingGif = false
        imagePickerVc.allowPickingMultipleVideo = false
        imagePickerVc.minImagesCount = 1
        
        imagePickerVc.sortAscendingByModificationDate = false
        
        imagePickerVc.showSelectBtn = false
        imagePickerVc.allowCrop = false
        imagePickerVc.needCircleCrop = false
        
        imagePickerVc.isStatusBarDefault = false
        
        
        // You can get the photos by block, the same as by delegate.
        
        imagePickerVc.didFinishPickingPhotosWithInfosHandle = { (photos, assets, isSelectOriginalPhoto, infoArr) -> (Void) in
            
       //     debugPrint("\(photos.count) ---\(assets.count) ---- \(isSelectOriginalPhoto) --- \((infoArr?.count)!)")
            
            self.selectedPhotos = photos
            
            self.selectedAssets = assets
            
            
        //    print(self.selectedAssets.count)
        //    print(self.selectedPhotos.count)
            
            
            if self.selectedPhotos.count != 0 {
                self.numberingPageLbl.isHidden = false
                self.creationSubmitBtn.isUserInteractionEnabled = true
                self.creationSubmitBtn.backgroundColor = #colorLiteral(red: 0.2666666667, green: 0.862745098, blue: 0.862745098, alpha: 1)
                self.creationSubmitBtn.titleLabel?.textColor = UIColor.black
                
            }
            
            self.addPicturesToScrollView()
            
        }
        
        imagePickerVc.modalPresentationStyle = .fullScreen
        
        self.present(imagePickerVc, animated: true, completion: nil)
        
    }
    
    @IBAction func creationSubmitBtnActn(_ sender: Any) {
        
        self.moreImagesUploadingMethod()
        
    }
    @IBAction func cancelBtnActn(_ sender: Any) {
        
        let deletealert:UIAlertController=UIAlertController(title: "Cancel Uploading", message: "Are you sure you want to cancel uploading this creation?", preferredStyle: UIAlertController.Style.alert)
        let deleteaction = UIAlertAction(title: "Yes, cancel uploading", style: UIAlertAction.Style.destructive)
        {
            UIAlertAction in
            
            let detailUpdate = UserDefaults.standard.string(forKey: "challengesdetail")
            if detailUpdate == "challengesdetail"
            {
                self.navigationController?.popViewController(animated: true)
                UserDefaults.standard.set("removedd", forKey: "challengesdetail")
                UserDefaults.standard.removeObject(forKey: "challengesdetail")
            }
            else
            {
                
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
        let deletecancel = UIAlertAction(title: "Continue uploading", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        deletealert.addAction(deleteaction)
        deletealert.addAction(deletecancel)
        
        self.present(deletealert, animated: true, completion: nil)
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
        
        let url = URL(string: API.uploadAPI)!
        
        var request = NSMutableURLRequest(url: url as URL)
        
        //     request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //  request.setValue("%llu\()", forHTTPHeaderField: "Content-Length")
        
        let parameters: [String: Any]
        
        if self.selectedChallengeID != nil {
            parameters = [
                "title": tittleTxtView.text!,
                "description": descriptionTxtView.text!,
                "challenge_id": self.selectedChallengeID!
            ]
        }
        else
        {
            parameters = [
                "title": tittleTxtView.text!,
                "description": descriptionTxtView.text!
            ]
        }
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        //  print(jsonString)
        
        request.httpBody = jsonString.data(using: .utf8)
        
        //  print(selectedPhotos.count)
        
        for item in self.selectedPhotos {
            
            let imgData = item!.jpegData(compressionQuality: 0.5)
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
            let someDateTime = formatter.string(from: date)
            let fileName = "\(someDateTime).jpg"
           // print(fileName)
            
            request.httpBody = createBody(parameters: [:], boundary: boundary, data:imgData!, mimeType: "image/jpeg", filename: fileName, fieldname: "uploads")
            
        }
        //   print(request)
        
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
                    
                    //      print(json)
                    if self.userFromchallenges == true
                    {
                        //  self.navigationController?.popViewController(animated: true)
                        
                        DispatchQueue.main.async {
                            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = mainStoryboard.instantiateViewController(withIdentifier: "ChallengeDetailsViewController") as! ChallengeDetailsViewController
                            
                            vc.challengesUploadYes = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                }
                else
                {
                    print("uploads error")
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
    }
    
    // MARK: - Upload images method
    func moreImagesUploadingMethod()
    {
        SVProgressHUD.show()
        
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
        }
        
        
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        
        let uploadurl = URL(string: API.uploadAPI)!
        
        let headers: HTTPHeaders = [
            "Authorization": "\(barerToken)",
            "Content-type": "\(contentType)"
        ]
        
        var parameters: [String: Any]
        
        var title : String?
        var description : String?
        
        let titleStr  = tittleTxtView.text!
        if titleStr == "Create a name for your work"
        {
            title = ""
        }
        else
        {
            title = titleStr
        }
        
        let descStr  = descriptionTxtView.text!
        if descStr == "Tell us more about this creation"
        {
            description = ""
        }
        else
        {
            description = descStr
        }
        
        
        if self.selectedChallengeID != nil {
            parameters = [
                "title": title!,
                "description": description!,
                "challenge_id": self.selectedChallengeID!
            ]
        }
        else
        {
            parameters = [
                "title": title!,
                "description": description!
            ]
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            let count = self.selectedPhotos.count
            
            for i in 0..<count{
                
                let imgData = self.selectedPhotos[i]!.jpegData(compressionQuality: 0.5)
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
                let someDateTime = formatter.string(from: date)
                let fileName = "\(someDateTime).jpg"
                
                // print(fileName)
                
                multipartFormData.append(imgData!, withName: "uploads", fileName: fileName, mimeType: "image/jpeg")
                
            }
            
        }, usingThreshold: UInt64.init(), to: uploadurl, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    //    print("Succesfully uploaded")
                    
                    SVProgressHUD.dismiss()
                    
                    //      print(response.result.value)
                    
                    if response.result.value != nil {
                        
                        let detailUpdate = UserDefaults.standard.string(forKey: "challengesdetail")
                        
                        if detailUpdate == "challengesdetail"
                            
                        {
                            
                            DispatchQueue.main.async {
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            }
                            
                        }
                            
                        else
                        {
                            
                            
                            DispatchQueue.main.async {
                                
                                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let vc = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
                                
                                vc.hidesBottomBarWhenPushed = true
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }
                            
                        }
                        
                        
                        
                    }
                        
                    else
                    {
                        DispatchQueue.main.async {
                            
                            SVProgressHUD.dismiss()
                            
                            self.showAlertView(title: "", msg: "No Network Connection")
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
                
            case .failure(let error):
                SVProgressHUD.dismiss()
                //  print("Error in upload: \(error.localizedDescription)")
                
            }
        }
        
        
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
// MARK:- Extension method..
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
