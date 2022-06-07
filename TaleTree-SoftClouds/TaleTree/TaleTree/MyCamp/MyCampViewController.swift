//
//  MyCampViewController.swift
//  SampleApplication
//
//  Created by apple on 19/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import  SDWebImage
import  SVProgressHUD
class MyCampViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var myCampCV: UICollectionView!
    
    @IBOutlet weak var joinViaZoomBtn: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var copyZoomLinkView: UIView!
    
    var campMembersData: campMemberDetails?
    
    var  leftButton :UIButton?
    
    // var campMemberBasicDetails:campMemberDetails?
    @IBOutlet weak var campMembersCountLbl: UILabel!
    var namesArray:Array = [String]()
    var imagesArray:Array = [UIImage]()
    
    var urlString:String?
    var copyZoomLink:String?
    var userID : Int?
    var fromMyCamp :Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Camp"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1.0)
        
        
        leftButton = UIButton(type: .custom)
        //set image for button
        leftButton!.setImage(UIImage(named: "returnBtnImage.png"), for: .normal)
        //add function for button
        leftButton!.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        //set frame
        leftButton!.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        
        let barButton = UIBarButtonItem(customView: leftButton!)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        
        
        
        let layout = myCampCV.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 8
        
        
        // For iphone and ipad
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            self.joinViaZoomBtn.layer.cornerRadius = 25
            self.joinViaZoomBtn.clipsToBounds = true
        case .phone:
            self.joinViaZoomBtn.layer.cornerRadius = 18
            self.joinViaZoomBtn.clipsToBounds = true
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        if let data = UserDefaults.standard.value(forKey: "loggedUserData") as? Data,
            let profileData = try? JSONDecoder().decode(userProfileDetails.self, from: data) {
            
            nameLbl.text = profileData.profile?.group?.name
            
            
            var val = profileData.profile?.group?.time
            
            let dateAsString = val
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            
            let date = dateFormatter.date(from: dateAsString!)
            dateFormatter.dateFormat = "h:mm a"
            let Date12 = dateFormatter.string(from: date!)
            print("12 hour formatted Date:",Date12)
            
            
            print(profileData.profile?.group?.day)
            
            var dayTimeStr = "\(String(describing: (profileData.profile?.group?.day)!).capitalized)" + ", " + "\(String(describing: (Date12)))"
            timeLabel.text = dayTimeStr
            
            
            urlString = profileData.profile?.group?.zoom_link
            
            if profileData.profile?.group?.id != nil
            {
                userID = profileData.profile?.group?.id
            }
            
            
        }
        
        loadCampMembersDetails()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        copyZoomLinkView.addGestureRecognizer(tap)
        
        guard let kidData = UserDefaults.standard.value(forKey: "CampMembersDetails") as? Data,
            let profileData = try? JSONDecoder().decode(memberDetails.self, from: kidData) else
        {
            return
        }
        
        print(profileData)
        // Do any additional setup after loading the view.
        
    }
    // MARK: - Custom methods
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        let alert = UIAlertController(title: "", message: "Copied successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                
                UIPasteboard.general.string = self.urlString!
                
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func joinViaZoomBtnTapped(_ sender: Any) {
        
        guard let url = URL(string: urlString!) else { return }
        UIApplication.shared.open(url)
        
    }
    // MARK: - Collection view methods...
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "permission", for: indexPath) as! MyCampCollectionViewCell
        
        cell.profileName.text = campMembersData?.dependents![indexPath.row].username
        
        //  print(campMembersData?.dependents?.count)
        
        if campMembersData?.dependents![indexPath.row].profile?.picture_url != nil
        {
            cell.imageViewPro.sd_setImage(with: URL(string: (campMembersData?.dependents![indexPath.row].profile?.picture_url)!), placeholderImage: UIImage(named: "HolderImage"))
        }
        else
        {
            cell.imageViewPro.image = UIImage(named: "HolderImage")
        }
        
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            
            cell.imageViewPro.layer.cornerRadius = (cell.imageViewPro.frame.size.width ?? 0.0) / 2
            
            cell.imageViewPro.clipsToBounds = true
            cell.imageViewPro.layer.borderWidth = 1.2
            cell.imageViewPro.layer.borderColor = UIColor.white.cgColor
        case .phone:
            
            
            cell.imageViewPro.setRounded()
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (campMembersData?.dependents?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let Ldata = UserDefaults.standard.value(forKey: "loggedUserData") as? Data,
            
            let loginData = try? JSONDecoder().decode(userProfileDetails.self, from: Ldata) else
        {
            return
        }
        
        var userLogin = loginData.id
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MyRoomViewController") as! MyRoomViewController
        
        var userPassVal = campMembersData?.dependents![indexPath.row].id
        
      //  print(userPassVal)
        vc.userPassVal = userPassVal
        
        
        if userLogin == userPassVal {
            vc.getCampLoggedorNot = true
            vc.fromMyCamp = false
            
        }
        else
        {
            vc.getCampLoggedorNot = false
            vc.fromMyCamp = true
            
        }
        
        
        SVProgressHUD.show()
        //vc.fromMyCamp = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = UIScreen.main.bounds.size.width
        
        if collectionView == collectionView || collectionView == collectionView {
            var width = (viewWidth - 30) / 3.5
            var height = (viewWidth - 20) / 3
            if UIDevice.current.userInterfaceIdiom == .pad {
                width = (viewWidth - 30) / 5
                height = (viewWidth - 30) / 5
            }
            return CGSize(width: width, height: height)
        } else  {
            return CGSize(width: 60, height: 60)
        }
    }
    
    // MARK: - API Call method...
    func loadCampMembersDetails()
    {
        // print(API.myCampMembers)
        
        SVProgressHUD.show()
        
        
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
        }
        
        let urlString = API.myCampMembers
        
        let finalString = urlString + "\(String(describing: userID!))"
        
        let url = URL(string: finalString)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
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
                    
                    //  print(json)
                    
                    if json["data"] != nil
                    {
                        if let responsedict: NSDictionary = json["data"] as? NSDictionary{
                            
                            let theJSONData = try? JSONSerialization.data(withJSONObject: json["data"] as! [String: Any] , options:[])
                            
                            UserDefaults.standard.set(theJSONData, forKey: "CampMembersDetails")
                            
                            var defal = UserDefaults.standard.data(forKey: "CampMembersDetails")
                            // print(defal)
                            
                            
                            self.campMembersData = try JSONDecoder().decode(campMemberDetails.self, from: defal!)
                            SVProgressHUD.dismiss()
                            
                            //    print(self.campMembersData?.dependents![0].username)
                            
                            
                            //  print(self.campMembersData?.dependents?.count)
                            
                            
                            
                            
                            do {
                                var defal = UserDefaults.standard.data(forKey: "CampMembersDetails")
                                //   print(defal)
                                self.campMembersData = try JSONDecoder().decode(campMemberDetails.self, from: defal!)
                                
                            }
                            catch{
                                
                            }
                            
                            
                            DispatchQueue.main.async {
                                
                                self.campMembersCountLbl.text = "Camp Members (\(self.campMembersData?.dependents?.count ?? 0))"
                                
                                self.myCampCV.delegate = self
                                self.myCampCV.dataSource = self
                                self.myCampCV.reloadData()
                            }
                            
                            
                        }
                        else
                        {
                            
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async {
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
extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
