//
//  MyRoomViewController.swift
//  TaleTree
//
//  Created by UFL on 19/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import MJRefresh

class MyRoomViewController: UIViewController,UICollectionViewDataSource,PinterestLayoutDelegate,UICollectionViewDelegate,getFeed {
    
    @IBOutlet weak var myCampButton: UIButton!
    
    @IBOutlet weak var myRoomCV: UICollectionView!
    @IBOutlet weak var myCampViewHeightCon: NSLayoutConstraint!
    @IBOutlet weak var myRoomCollectionView: UICollectionView!
    
    
    @IBOutlet weak var myCreations: UILabel!
    @IBOutlet weak var zeroCreationsView: UIView!
    
    @IBOutlet weak var collectionViewTopCon: NSLayoutConstraint!
    @IBOutlet weak var allCreationsLblWidthCon: NSLayoutConstraint!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var myCampView: UIView!
    @IBOutlet weak var allCreationsLbl: UILabel!
    @IBOutlet weak var favSportLbl: UILabel!
    @IBOutlet weak var favAnimalLbl: UILabel!
    @IBOutlet weak var favColorLbl: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var groupDisplayLbl: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    @IBOutlet weak var myCreationsCountLbl: UILabel!
    
    @IBOutlet weak var binkiesCount: UILabel!
    @IBOutlet weak var challegesCount: UILabel!
    
    @IBOutlet var profilePicBtn: UIButton!
    
    var fromMyCamp :Bool?
    var finalString :String?
    var  button :UIButton?
    
    var  leftButton :UIButton?
    
    var sectionsCount:Int?
    
    var campMembersData: campMemDetailsFromMyCamp?
    
    var getData: [getDetailsForCreation]?
    
    var userPassVal:Int?
    
    var usercreationID: Int?
    
    var userIDForAllCre :String?
    // let dataModel = [1,2,3,4,5,6,1,2,3,4,5,6,7,8,9,10,11,12]
    
    var dataModel:Array = [String]()
    
    
    var favColor:String?
    var favSport:String?
    var favAnimal:String?
    var userDependentId : String?
    var profileImageString:String?
    var profileNamee:String?
    
    var fromHomeUser :Bool?
    
    var getLoginUserorNot :Bool?
    
    var getCampLoggedorNot :Bool?
    
    
    
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dataModel = ["1","2","3","4"]
        //   dataModel = []
        
        //  print(userPassVal as Any)
        //  print(SharedData.data.feedsData)
        
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        if loginOrNotFlag == "loginYes"
        {
            
        }else
        {
            SVProgressHUD.dismiss()
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        zeroCreationsView.isHidden = true
        
        //myRoomCollectionView.dataSource = self
        
        self.groupDisplayLbl.layer.cornerRadius = 8
        self.groupDisplayLbl.clipsToBounds = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1.0)
        
        button = UIButton(type: .custom)
        //set image for button
        button!.setImage(UIImage(named: "settings.png"), for: .normal)
        //add function for button
        button!.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        //set frame
        button!.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        
        let barButton = UIBarButtonItem(customView: button!)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        
        if userPassVal != nil{
            DispatchQueue.main.async {
                self.dataFromCamp()
            }
        }
        
        profilePicture.layer.borderWidth = 0
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        
        myCampButton.layer.borderWidth = 0
        myCampButton.layer.masksToBounds = false
        myCampButton.layer.cornerRadius = myCampButton.frame.height/2
        myCampButton.clipsToBounds = true
        
        
        header.setRefreshingTarget(self, refreshingAction: #selector(MyRoomViewController.headerRefresh))
        self.myRoomCollectionView.mj_header = header
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(MyRoomViewController.footerRefresh))
        self.myRoomCollectionView.mj_footer?.isHidden = true
        self.myRoomCollectionView.mj_footer = footer
        self.footer.stateLabel?.isHidden = true
        
        myCampButton.addRightIcon(image: #imageLiteral(resourceName: "Icon_MyCamp_arrow_20px"))
        
        self.allCreationsAPICallanotherMethod(startAfter: "0")
    }
    
    func getdata() {
        
        myRoomCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.dismiss()
        
        self.tabBarController?.tabBar.isHidden = false
        
        if fromHomeUser == true {
            if getLoginUserorNot == true {
                
                self.tabBarController?.tabBar.isHidden = false
                
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
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
                
            }else
            {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
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
                
            }
            
        }
        
        if fromMyCamp == true {
            if getCampLoggedorNot == true
            {
                self.navigationItem.hidesBackButton = true
                
            }else
            {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
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
                
            }
            
        }
        else
        {
            self.navigationItem.hidesBackButton = true
        }
        
        
        if fromMyCamp == nil
        {
            
            loadProfileUser()
            
            //self.title = "My Room"
            self.navigationItem.title = "My Room"
            
            button!.isHidden = false
            myCampButton.isHidden = false
            allCreationsLbl.isHidden = false
            editButton.isHidden = false
            allCreationsLblWidthCon.constant = 21
            myCampViewHeightCon.constant = 35
            collectionViewTopCon.constant = 16
            myCreations.text = "My Creations"
            
            
            //User came from login screen by entering Username/Password
            
            if let data = UserDefaults.standard.value(forKey: "loggedUserData") as? Data,
                let profileData = try? JSONDecoder().decode(userProfileDetails.self, from: data) {
                
                profileName.text = profileData.username
                profileNamee = profileData.username
                
                userDependentId = "\(String(describing: profileData.id!))"
                if profileData.profile?.favorites != nil
                {
                    favSportLbl.text = profileData.profile?.favorites![1] as Any as! String
                    favSport = (profileData.profile?.favorites![1] as Any as! String)
                    
                    favAnimalLbl.text = profileData.profile?.favorites![2] as Any as! String
                    favAnimal = (profileData.profile?.favorites![2] as Any as! String)
                    
                    favColorLbl.text = profileData.profile?.favorites![0] as Any as! String
                    favColor = (profileData.profile?.favorites![0] as Any as! String)
                    
                    
                }
                if profileData.creation_count != nil{
                    myCreationsCountLbl.text = "\(String(describing: profileData.creation_count!))"
                }
                if profileData.challenge_count != nil{
                    challegesCount.text = "\(String(describing: profileData.challenge_count!))"
                }
                if profileData.binky_count != nil{
                    binkiesCount.text = "\(String(describing: profileData.binky_count!))"
                }
                
                if profileData.profile?.group?.name != nil{
                    groupDisplayLbl.text = "  Camp " + "\(String(describing: (profileData.profile?.group?.name)!))" + "  "
                    groupDisplayLbl.isHidden = false
                }
                else
                {
                    groupDisplayLbl.isHidden = true
                }
                
                
                if profileData.profile?.picture_url != nil {
                    profilePicture.sd_setImage(with: URL(string: (profileData.profile?.picture_url)!), placeholderImage: UIImage(named: "HolderImage"))
                    
                    profileImageString = "\(((profileData.profile?.picture_url)!))"
                    //  print(profileImageString!)
                }
                
            }
            
            
        }
        
        if fromMyCamp != nil
        {
            if fromMyCamp == false
            {
                loadProfileUser()
                
                // self.title = "My Room"
                self.navigationItem.title = "My Room"
                
                button!.isHidden = false
                myCampButton.isHidden = false
                allCreationsLbl.isHidden = false
                editButton.isHidden = false
                allCreationsLblWidthCon.constant = 21
                myCampViewHeightCon.constant = 35
                collectionViewTopCon.constant = 16
                myCreations.text = "My Creations"
                //User came from login screen by entering Username/Password
                
                if let data = UserDefaults.standard.value(forKey: "loggedUserData") as? Data,
                    let profileData = try? JSONDecoder().decode(userProfileDetails.self, from: data) {
                    
                    profileName.text = profileData.username
                    
                    if profileData.profile?.favorites != nil
                    {
                        favSportLbl.text = profileData.profile?.favorites![2] as Any as! String
                        
                        //  favSportLbl.text = profileData.profile?.favorites![0] as Any as! String
                        favAnimalLbl.text = profileData.profile?.favorites![1] as Any as! String
                        favColorLbl.text = profileData.profile?.favorites![0] as Any as! String
                    }
                    if profileData.creation_count != nil{
                        myCreationsCountLbl.text = "\(String(describing: profileData.creation_count!))"
                    }
                    if profileData.challenge_count != nil{
                        challegesCount.text = "\(String(describing: profileData.challenge_count!))"
                    }
                    if profileData.binky_count != nil{
                        binkiesCount.text = "\(String(describing: profileData.binky_count!))"
                    }
                    
                    
                    if profileData.profile?.group?.name != nil
                    {
                        groupDisplayLbl.text = "  Camp " + "\(String(describing: (profileData.profile?.group?.name)!))" + "  "
                        groupDisplayLbl.isHidden = false
                    }
                    else
                    {
                        groupDisplayLbl.isHidden = true
                    }
                    
                    
                    
                    if profileData.profile?.picture_url != nil {
                        profilePicture.sd_setImage(with: URL(string: (profileData.profile?.picture_url)!), placeholderImage: UIImage(named: "HolderImage"))
                    }
                    
                    
                }
                
            }else
            {
                
            }
            
        }
        
        let picUpdate = UserDefaults.standard.string(forKey: "UserProfilePic")
        if picUpdate == "updated"
        {
            // print("Updated piccccccc")
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.showToast(message: "Your profile is updated!")
            
            UserDefaults.standard.set("newwww", forKey: "UserProfilePic")
            UserDefaults.standard.removeObject(forKey: "UserProfilePic")
            
        }
        
        let deleteCreate = UserDefaults.standard.string(forKey: "deletecreation")
        if deleteCreate == "Delete"
        {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.showToast(message: "You deleted a creation.")
            
            UserDefaults.standard.set("deleteeee", forKey: "deletecreation")
            UserDefaults.standard.removeObject(forKey: "deletecreation")
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        fromHomeUser = false
    }
    // MARK: - header refresh methods..
    @objc func headerRefresh(){
        
        self.myRoomCollectionView.mj_header?.endRefreshing()
        
        self.allCreationsAPICallanotherMethod(startAfter: "0")
        
    }
    
    @objc func footerRefresh(){
        
        //  self.footer.stateLabel?.isHidden = false
        footer.endRefreshingWithNoMoreData()
        
        let lastObject = getData?.last
        
       // print(lastObject as Any)
        
        let lastCreationId = lastObject?.id
        
        if lastCreationId != nil
        {
            self.allCreationsAPICallanotherMethod(startAfter: "\(lastCreationId!)")
        }
        
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
        //   label.font = UIFont(name: "SF Pro Text Semibold", size: 20.0)
        label.text = message
        label.alpha = 1.0
        label.layer.cornerRadius = 4;
        label.clipsToBounds  =  true
        toastLabel.addSubview(label)
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    // MARK: - Custom Methods....
    func response()
    {
        //   print(getLoginUserorNot)
        if getLoginUserorNot == true || getCampLoggedorNot == true
            
        {
            self.navigationItem.title = "My Room"
            
            button!.isHidden = false
            
            myCampButton.isHidden = false
            
            allCreationsLbl.isHidden = false
            
            editButton.isHidden = false
            
            allCreationsLblWidthCon.constant = 21
            
            myCampViewHeightCon.constant = 35
            
            collectionViewTopCon.constant = 16
            
            myCreations.text = "My Creations"
            
        }
        else
        {
            self.title = "Profile"
            
            button!.isHidden = true
            
            myCampButton.isHidden = true
            
            allCreationsLbl.isHidden = true
            
            editButton.isHidden = true
            
            allCreationsLblWidthCon.constant = 0
            
            myCampViewHeightCon.constant = 35
            
            collectionViewTopCon.constant = -50
            
            myCreations.text = "Creations"
            
            profileName.text = campMembersData?.username
            
        }
        if campMembersData?.profile?.favorites != nil
        {
            
            favSportLbl.text = campMembersData?.profile?.favorites![1] as Any as! String
            
            //  favSportLbl.text = profileData.profile?.favorites![0] as Any as! String
            favAnimalLbl.text = campMembersData?.profile?.favorites![2] as Any as! String
            favColorLbl.text = campMembersData?.profile?.favorites![0] as Any as! String
            
        }
        if campMembersData?.creation_count != nil{
            myCreationsCountLbl.text = "\(String(describing: (campMembersData?.creation_count)!))"
        }
        if campMembersData?.challenge_count != nil{
            challegesCount.text = "\(String(describing: (campMembersData?.challenge_count)!))"
        }
        if campMembersData?.binky_count != nil{
            binkiesCount.text = "\(String(describing: (campMembersData?.binky_count)!))"
        }
        
        if campMembersData?.profile?.group?.name != nil
        {
            groupDisplayLbl.text = "  Camp " + "\(String(describing: (campMembersData?.profile?.group?.name)!))" + "  "
            groupDisplayLbl.isHidden = false
        }
        else
        {
            groupDisplayLbl.isHidden = true
        }
        
        
        
        if campMembersData?.profile?.picture_url != nil {
            profilePicture.sd_setImage(with: URL(string: (campMembersData?.profile?.picture_url)!), placeholderImage: UIImage(named: "HolderImage"))
        }
        else
        {
            profilePicture.image = UIImage(named: "HolderImage")
        }
        
    }
    
    // MARK:- custom button events...
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func settingsTapped() {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc.hidesBottomBarWhenPushed = true
        vc.favColor = favColor
        vc.favSport = favSport
        vc.favAnimal = favAnimal
        vc.profileImageString = profileImageString
        vc.userDependentId = userDependentId
        vc.profileNamee = profileNamee
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func myCampButtonTapped(_ sender: Any) {
        
        if let data = UserDefaults.standard.value(forKey: "loggedUserData") as? Data,
            let profileData = try? JSONDecoder().decode(userProfileDetails.self, from: data) {
            
            if profileData.profile?.group?.id == nil {
                
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "NonCampViewController") as! NonCampViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "MyCampViewController") as! MyCampViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MyCampViewController") as! MyCampViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        
        vc.favColor = favColor
        vc.favSport = favSport
        vc.favAnimal = favAnimal
        vc.profileImageString = profileImageString
        vc.userDependentId = userDependentId
        vc.profileNamee = profileNamee
        
        vc.profilePicUpdate = true
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //  self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func profilePicBtnActn(_ sender: Any) {
        
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        
        vc.favColor = favColor
        vc.favSport = favSport
        vc.favAnimal = favAnimal
        vc.profileImageString = profileImageString
        vc.userDependentId = userDependentId
        vc.profileNamee = profileNamee
        
        vc.profilePicUpdate = true
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - API Call Methods...
    func allCreationsAPICallanotherMethod(startAfter: String)
    {
        // SVProgressHUD.show()
        
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        if loginOrNotFlag == "loginYes"
        {
            SVProgressHUD.show()
            
        }else
        {
            
        }
        
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
        
        if fromMyCamp == true{
            
            if userPassVal != nil{
                userIDForAllCre = "\(String(describing: userPassVal!))"
                
            }
        }
        else
        {
            
            if fromHomeUser == true
            {
                if userPassVal != nil{
                    userIDForAllCre = "\(String(describing: userPassVal!))"
                    
                }
            }
            else
            {
                userIDForAllCre = "\(loginData.id!)"
            }
            
            
        }
        
        
        let url = URL(string: API.allCreationsAPI)
        
        let queryItems = [URLQueryItem(name: "dependent_id", value: userIDForAllCre),
                          
                          URLQueryItem(name: "limit", value: "10"),
                          URLQueryItem(name: "starting_after", value: startAfter)
            
        ]
        
        
        let newUrl = url!.appending(queryItems)!
        
      //  print("creations API", newUrl)
        
        var request = URLRequest(url: newUrl)
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
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
                
                let loginRespone = try JSONDecoder().decode(ApiPayStatus.self, from: data)
                
                SVProgressHUD.dismiss()
                let loginStatus = loginRespone.result_code
                
                //print(loginStatus as Any)
                
                //   print(loginRespone.data as Any)
                
                if let ccdata = try? JSONEncoder().encode(loginRespone.data) {
                    
                    UserDefaults.standard.set(ccdata, forKey: "loggedData")
                }
                
                guard let rrData = UserDefaults.standard.value(forKey: "loggedData") as? Data,
                    
                    let loginData = try? JSONDecoder().decode([getDetailsForCreation].self, from: rrData) else
                    
                {
                    return
                }
                
                //  print(loginData)
                
                self.myRoomCollectionView.mj_footer?.endRefreshing()
                self.myRoomCollectionView.mj_header?.endRefreshing()
                
                
                if startAfter == "0"
                {
                    self.getData?.removeAll()
                    self.getData = loginData
                    
                    if loginData.count > 0 {
                        
                        SharedData.data.creationsDataRoom =  loginData
                        DispatchQueue.main.async {
                            self.myRoomCollectionView.delegate = self
                            self.myRoomCollectionView.dataSource = self
                            self.myRoomCollectionView.reloadData()
                            
                            self.zeroCreationsView.isHidden = true
                            
                            if let layout = self.myRoomCollectionView.collectionViewLayout as? PinterestLayout{
                                layout.delegate = self
                            }
                            
                        }
                        
                    }
                    else
                    {
                        
                        DispatchQueue.main.async {
                            self.zeroCreationsView.isHidden = false
                        }
                    }
                }
                else
                {
                    
                    if loginData.count > 0
                    {
                        for eachObject in loginData
                        {
                            self.getData?.append(eachObject)
                            
                            SharedData.data.creationsDataRoom!.append(eachObject)
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.myRoomCollectionView.reloadData()
                    }
                    
                    
                }
                
            }
                
            catch let error {
                print(error.localizedDescription)
                
            }
            
        }
        task.resume()
        
    }
    
    func dataFromCamp()
    {
        
        SVProgressHUD.show()
        
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
        }
        
        let urlString = API.loadCampMemberDetails
        
        
        if fromMyCamp == true{
            
            if userPassVal != nil{
                
                finalString = urlString + "\(String(describing: userPassVal!))"
                
            }
        }
        else
        {
            if fromHomeUser == true
            {
                if userPassVal != nil{
                    finalString = urlString + "\(String(describing: userPassVal!))"
                    
                }
            }
            
            if userPassVal != nil{
                
                finalString = urlString + "\(String(describing: userPassVal!))"
                
            }
            
        }
        
        
        
        let url = URL(string: finalString!)!
        
        
        //    let url = URL(string: API.loadCampMemberDetails)!
        
        // Add user Id from MyCamp View member screen
        var request = URLRequest(url: url)
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
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    
                    SVProgressHUD.dismiss()
                    //  print(json)
                    
                    if json["data"] != nil
                    {
                        if let responsedict: NSDictionary = json["data"] as? NSDictionary{
                            
                            // print(responsedict)
                            
                            let theJSONData = try? JSONSerialization.data(withJSONObject: json["data"] as! [String: Any] , options:[])
                            
                            
                            UserDefaults.standard.set(theJSONData, forKey: "getsCampMemberDetails")
                            
                            var defal = UserDefaults.standard.data(forKey: "getsCampMemberDetails")
                            // print(defal)
                            
                            let getCampMemberProfileData = try JSONDecoder().decode(campMemDetailsFromMyCamp.self, from: defal!)
                            
                            
                            
                            do {
                                let defal = UserDefaults.standard.data(forKey: "getsCampMemberDetails")
                                //  print(defal)
                                self.campMembersData = try JSONDecoder().decode(campMemDetailsFromMyCamp.self, from: defal!)
                                
                            }
                            catch{
                                
                            }
                            
                            DispatchQueue.main.async {
                                self.response()
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
    
    func loadProfileUser()
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
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    //  print(json)
                    SVProgressHUD.dismiss()
                    
                    if json["data"] != nil
                    {
                        if let responsedict: NSDictionary = json["data"] as? NSDictionary{
                            
                            
                            let theJSONData = try? JSONSerialization.data(withJSONObject: json["data"] as! [String: Any] , options:[])
                            
                            let loginUserData = try JSONDecoder().decode(userProfileDetails.self, from: theJSONData!)
                            
                            
                            if let data = try? JSONEncoder().encode(loginUserData) {
                                UserDefaults.standard.set(data, forKey: "loggedUserData")
                                
                            }
                            
                            
                            if let data = UserDefaults.standard.value(forKey: "loggedUserData") as? Data,
                                let profileData = try? JSONDecoder().decode(userProfileDetails.self, from: data) {
                                
                                DispatchQueue.main.async {
                                    self.profileName.text = profileData.username
                                    
                                    if profileData.profile?.favorites != nil
                                    {
                                        self.favSportLbl.text = profileData.profile?.favorites![1] as Any as! String
                                        self.favSport = (profileData.profile?.favorites![1] as Any as! String)
                                        
                                        self.favAnimalLbl.text = profileData.profile?.favorites![2] as Any as! String
                                        self.favAnimal = (profileData.profile?.favorites![2] as Any as! String)
                                        
                                        self.favColorLbl.text = profileData.profile?.favorites![0] as Any as! String
                                        self.favColor = (profileData.profile?.favorites![0] as Any as! String)
                                        
                                    }
                                    
                                    if profileData.creation_count != nil{
                                        self.myCreationsCountLbl.text = "\(String(describing: profileData.creation_count!))"
                                    }
                                    if profileData.challenge_count != nil{
                                        self.challegesCount.text = "\(String(describing: profileData.challenge_count!))"
                                    }
                                    if profileData.binky_count != nil{
                                        self.binkiesCount.text = "\(String(describing: profileData.binky_count!))"
                                    }
                                    
                                    if profileData.profile?.group?.name != nil
                                    {
                                        self.groupDisplayLbl.text = "  Camp " + "\(String(describing: (profileData.profile?.group?.name)!))" + "  "
                                        self.groupDisplayLbl.isHidden = false
                                    }
                                    else
                                    {
                                        self.groupDisplayLbl.text = ""
                                        self.groupDisplayLbl.isHidden = true
                                    }
                                    
                                    
                                    
                                    if profileData.profile?.picture_url != nil {
                                        self.profilePicture.sd_setImage(with: URL(string: (profileData.profile?.picture_url)!), placeholderImage: UIImage(named: "HolderImage"))
                                        
                                        self.profileImageString = "\(((profileData.profile?.picture_url)!))"
                                        //  print(profileImageString!)
                                    }
                                    
                                }
                                
                            }
                            
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
    
    
    // MARK: -  Collection view Data source and Delegate methods..
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if getData?.count == 0{
            
            if fromMyCamp == true{
                
                zeroCreationsView.isHidden = true
                
            }else{
                
                zeroCreationsView.isHidden = false
                
            }
            
            // zeroCreationsView.isHidden = false
        }else{
            zeroCreationsView.isHidden = true
            
            //  print(getData?.count)
        }
        
        return getData?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custom", for: indexPath) as? myRoomCollectionViewCell {
            
            cell.gradientLayerView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
            
            if fromMyCamp == nil{
                cell.binkyButton.isHidden = false
                cell.commentsButton.isHidden = false
                cell.binkyCountDis.isHidden = false
                cell.commentsCountLbl.isHidden = false
                cell.gradientLayerView.isHidden = false
            }
            
            if fromMyCamp != nil
            {
                if fromMyCamp == false
                {
                    cell.binkyButton.isHidden = false
                    cell.commentsButton.isHidden = false
                    cell.binkyCountDis.isHidden = false
                    cell.commentsCountLbl.isHidden = false
                    cell.gradientLayerView.isHidden = false
                }else{
                    cell.binkyButton.isHidden = true
                    cell.commentsButton.isHidden = true
                    cell.binkyCountDis.isHidden = true
                    cell.commentsCountLbl.isHidden = true
                    cell.gradientLayerView.isHidden = true
                    
                }
            }
            
            //  print("array data count", getData?.count)
            
            if getData![indexPath.row].media![0].s640_url != nil
            {
                cell.imageViewDis.sd_setImage(with: URL(string: (getData![indexPath.item].media![0].s640_url)!), placeholderImage: nil)
                
            }
            else
            {
                // cell.imageViewDis.image = UIImage(named: "HolderImage")
                cell.imageViewDis.sd_setImage(with: URL(string: (getData![indexPath.item].media![0].url)!), placeholderImage: nil)
            }
            
            
            let binkyvalue =  "\(String(describing: (SharedData.data.creationsDataRoom![indexPath.item].binky_count)!))"
            
          //  print(binkyvalue)
            if binkyvalue == "0"
            {
                cell.binkyCountDis.text = ""
                
            }else
            {
                
                
                cell.binkyCountDis.text = binkyvalue
            }
            
            let commentValue = "\(String(describing: (SharedData.data.creationsDataRoom![indexPath.item].comment_count)!))"
            
            if commentValue == "0"
            {
                cell.commentsCountLbl.text = ""
                
            }else
            {
                // cell.commentsCountLbl.text = "\(String(describing: (getData![indexPath.item].comment_count)!))"
                
                cell.commentsCountLbl.text = commentValue
                
            }
            
            let mediaMore = getData![indexPath.item].media_count
            //  print(mediaMore)
            if mediaMore! > 1
            {
                cell.morePhotosBtn.isHidden = false
            }else{
                cell.morePhotosBtn.isHidden = true
            }
            
            
            
            if getData![indexPath.item].challenge != nil
            {
                cell.charTypeImg.isHidden = false
                
                if getData![indexPath.item].challenge?.character_type == "letsgo" {
                    cell.charTypeImg.image = UIImage(named: "roomLets")
                }
                else if ( getData![indexPath.item].challenge?.character_type == "uni")
                {
                    cell.charTypeImg.image = UIImage(named: "roomUni")
                }
                else if ( getData![indexPath.item].challenge?.character_type == "rushmore")
                {
                    cell.charTypeImg.image = UIImage(named: "roomRushmore")
                }
                else if ( getData![indexPath.item].challenge?.character_type == "cody")
                {
                    cell.charTypeImg.image = UIImage(named: "roomCody")
                }
                else if ( getData![indexPath.item].challenge?.character_type == "rooty")
                {
                    cell.charTypeImg.image = UIImage(named: "roomRooty")
                }
                else if ( getData![indexPath.item].challenge?.character_type == "doma")
                {
                    cell.charTypeImg.image = UIImage(named: "roomDoma")
                }
                else
                {
                    cell.charTypeImg.image = UIImage(named: "noprofile")
                }
            }
            else
            {
                cell.charTypeImg.isHidden = true
            }
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 5
            cell.imageViewDis.contentMode = .scaleAspectFill
            
            
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        var displayImg:UIImage?
        
        if getData?.count != nil
        {
            
            
            if getData![indexPath.item].media![0].s640_url != nil {
                let outPutStr = String(describing:getData![indexPath.item].media![0].s640_url!)
                let imageUrl = URL(string: outPutStr)!
                
                let imageData = try! Data(contentsOf: imageUrl)
                displayImg = UIImage(data: imageData)
            }
            else
            {
                let outPutStr = String(describing:getData![indexPath.item].media![0].url!)
                let imageUrl = URL(string: outPutStr)!
                
                let imageData = try! Data(contentsOf: imageUrl)
                displayImg = UIImage(data: imageData)
            }
            
        }
        
        if let height = displayImg?.size.height{
            
            return height
        }
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
      //  print("user click from colelction view")
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeDetailViewController") as! HomeDetailViewController
        
        vc.selectedCreationID = SharedData.data.creationsDataRoom![indexPath.item].id
        vc.userIDMatch = self.getData![indexPath.item].user?.id
        vc.selectBinkyIdStr = SharedData.data.creationsDataRoom![indexPath.item].binky_id
        vc.fromhome = self
        vc.comingFromMyRoom = true
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
// MARK:- Extension methods....
extension URL {
    /// Returns a new URL by adding the query items, or nil if the URL doesn't support it.
    /// URL must conform to RFC 3986.
    func appending(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            // URL is not conforming to RFC 3986 (maybe it is only conforming to RFC 1808, RFC 1738, and RFC 2732)
            return nil
        }
        // append the query items to the existing ones
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        
        // return the url from new url components
        return urlComponents.url
    }
}
extension UIButton {
    func addRightIcon(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        let length = CGFloat(15)
        titleEdgeInsets.right += length
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 5),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: length),
            imageView.heightAnchor.constraint(equalToConstant: length)
        ])
    }
}
