//
//  SettingsViewController.swift
//  SampleApplication
//
//  Created by apple on 25/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SettingsHeader{
    var headerName :String?
    var options:[String]?
    
    var taleTreeGuide:Bool?
    var termsOfUse:Bool?
    var privacyPolicy:Bool?
    
    init(headerName:String, options: [String]) {
        self.headerName = headerName
        self.options = options
    }
}

class SettingsViewController: UIViewController {
    
    
    var settings = [SettingsHeader]()
    
    var favColor:String?
    var favSport:String?
    var favAnimal:String?
    var userDependentId : String?
    var profileImageString:String?
    var profileNamee:String?
    
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var versionNumber: UILabel!
    @IBOutlet weak var settingsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings.append(SettingsHeader.init(headerName: "My Profile", options: ["Edit My Profile"]))
        //  settings.append(SettingsHeader.init(headerName: "Notifications", options: ["Push Notifications"]))
        settings.append(SettingsHeader.init(headerName: "Support", options: ["Send Feedback","TaleTree Guidelines","Terms of Use","Privacy Policy"]))
        settings.append(SettingsHeader.init(headerName: "      ", options: ["Log Out"]))
        
        settingsTableView.tableFooterView = UIView()
        
        settingsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: settingsTableView.frame.size.width, height: 1))
        
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            
            versionNumber.text = "v." + "\(version)"
            
        }
        
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            //  print(build)
        }
        
        // Getting device information wheather ipad or iphone.
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            
            titleLbl.font = titleLbl.font.withSize(22)
            doneBtn.titleLabel?.font = .systemFont(ofSize: 22)
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: navigationView.frame.size.height-1, width: navigationView.frame.width + 400, height: 1.0)
            bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            navigationView.layer.addSublayer(bottomBorder)
        case .phone:
            doneBtn.titleLabel?.font = .systemFont(ofSize: 17)
            titleLbl.font = titleLbl.font.withSize(16)
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: navigationView.frame.size.height-1, width: navigationView.frame.width , height: 1.0)
            bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            navigationView.layer.addSublayer(bottomBorder)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
    }
    // MARK: - Custom button events..
    @IBAction func doneBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        UserDefaults.standard.set("newwww", forKey: "UserProfilePic")
        UserDefaults.standard.removeObject(forKey: "UserProfilePic")
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
}
// MARK: - Table view extension methods..
extension SettingsViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].options!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath)
        
        if indexPath.section == 2
        {
            
            cell.textLabel?.textColor  = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        
        cell.textLabel?.text = settings[indexPath.section].options?[indexPath.row]
        
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            cell.textLabel?.font = UIFont.systemFont(ofSize: 24)
        case .phone:
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9647058824, blue: 0.9725490196, alpha: 1)
        
        let lbl = UILabel(frame: CGRect(x: 20, y: 10, width: view.frame.width - 15, height: 40))
        lbl.text = settings[section].headerName
        //  lbl.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            lbl.font = UIFont.boldSystemFont(ofSize: 22)
        case .phone:
            lbl.font = UIFont.boldSystemFont(ofSize: 18)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        lbl.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        view.addSubview(lbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            return 50
            
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            return 70
            
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            vc.favColor = favColor
            vc.favSport = favSport
            vc.favAnimal = favAnimal
            vc.profileImageString = profileImageString
            vc.userDependentId = userDependentId
            vc.profileNamee = profileNamee
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        /*
         if indexPath.section == 1
         {
         let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = mainStoryboard.instantiateViewController(withIdentifier: "PushNotifiViewController") as! PushNotifiViewController
         vc.hidesBottomBarWhenPushed = true
         self.navigationController?.pushViewController(vc, animated: true)
         
         } */
        
        if indexPath.section == 1
        {
            
            if indexPath.row == 0
            {
                
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "SendFeedBackViewController") as! SendFeedBackViewController
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                //    self.present(vc, animated: true, completion: nil)
                
            }
            if indexPath.row == 1
            {
                var  taleTreeGuide = true
                
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "DisplayViewController") as! DisplayViewController
                vc.taleTreeGuide = taleTreeGuide
                self.present(vc, animated: true, completion: nil)
                
                
               // print("send feedback")
            }
            if indexPath.row == 2{
                
                var termsOfUse = true
                
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "DisplayViewController") as! DisplayViewController
                vc.termsOfUse = termsOfUse
                self.present(vc, animated: true, completion: nil)
               // print("Tale Tree")
            }
            if indexPath.row == 3{
                
                var privacyPolicy = true
                
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "DisplayViewController") as! DisplayViewController
                vc.privacyPolicy = privacyPolicy
                self.present(vc, animated: true, completion: nil)
              //  print("privacy ")
            }
            
        }
        if indexPath.section == 2
        {
            UserDefaults.standard.set("loginNo", forKey: "UserLogin")
            UserDefaults.standard.removeObject(forKey: "UserLogin")
            
            
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
            
            vc.logoutMethod = true
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

