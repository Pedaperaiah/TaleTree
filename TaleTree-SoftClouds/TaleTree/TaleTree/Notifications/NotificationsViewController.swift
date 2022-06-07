//
//  NotificationsViewController.swift
//  TaleTree
//
//  Created by UFL on 19/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class NotificationHeader{
    var headerName :String?
    
    init(headerName:String ) {
        self.headerName = headerName
        
    }
}

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var NoticationDataArray: [notifcationDetailData]?
    
    var notifications = [NotificationHeader]()
    
    var earlierArray = [notifcationDetailData]()
    var mostRecentArray = [notifcationDetailData]()
    var thisWeekArray = [notifcationDetailData]()
    
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    
    @IBOutlet var notificationTblObj: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //         let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        //               if loginOrNotFlag == "loginYes"
        //               {
        //
        //               }else
        //               {
        //                 let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //                          let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
        //                   vc.hidesBottomBarWhenPushed = true
        //                   self.navigationController?.pushViewController(vc, animated: false)
        //               }
        
        self.navigationItem.title = "Notifications"
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1.0)
        
        notifications.append(NotificationHeader.init(headerName: "Most Recent"))
        
        notifications.append(NotificationHeader.init(headerName:"This Week"))
        
        notifications.append(NotificationHeader.init(headerName: "Earlier"))
        
        notificationTblObj.tableFooterView = UIView()
        
        
        header.setRefreshingTarget(self, refreshingAction: #selector(HomeViewController.headerRefresh))
        self.notificationTblObj.mj_header = header
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(NotificationsViewController.footerRefresh))
        self.notificationTblObj.mj_footer?.isHidden = true
        self.notificationTblObj.mj_footer = footer
        self.footer.stateLabel?.isHidden = true
        
        
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        if loginOrNotFlag == "loginYes"
        {
            self.GetNotificationsAPI(startAfter: "0")
        }else
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        //  self.GetNotificationsAPI(startAfter: "0")
        
    }
    // MARK: - header refresh methods..
    @objc func headerRefresh(){
        
        self.notificationTblObj.mj_header?.endRefreshing()
        
        self.GetNotificationsAPI(startAfter: "0")
        
    }
    
    @objc func footerRefresh(){
        
        footer.endRefreshingWithNoMoreData()
        //    self.footer.stateLabel?.isHidden = false
        
        let lastObject = NoticationDataArray?.last
        
      //  print(lastObject as Any)
        
        let lastCreationId = lastObject?.id
        
        if lastCreationId != nil
        {
            self.GetNotificationsAPI(startAfter: "\(String(describing: lastCreationId!))")
        }
        
    }
    
    // MARK: - Table View Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return  notifications.count
        
        // return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return self.mostRecentArray.count
        }
        else if section == 1
        {
            return self.thisWeekArray.count
        }else
        {
            return self.earlierArray.count
        }
        
        // return self.NoticationDataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
        lbl.text = notifications[section].headerName
        lbl.textColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
        lbl.font = UIFont(name: "SF Pro Text Bold", size: 17.0)
        //  lbl.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            lbl.font = UIFont.boldSystemFont(ofSize: 24)
        case .phone:
            lbl.font = UIFont.boldSystemFont(ofSize: 20)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(lbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            if mostRecentArray.count == 0
            {
                return 0
            }
            else
            {
                return 40
            }
        }
        else if section == 1
        {
            if thisWeekArray.count == 0
            {
                return 0
            }
            else
            {
                return 40
            }
        }
        else
        {
            if earlierArray.count == 0
            {
                return 0
            }
            else
            {
                return 40
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticationTableViewCell", for: indexPath) as! NoticationTableViewCell
        
        
        if indexPath.section == 0
        {
            
            cell.selectionStyle = .none
            cell.userNameLbl.text = self.mostRecentArray[indexPath.row].from_dependent?.username
            //  cell.commentLbl.text = self.NoticationDataArray![indexPath.row].from_object
            
            let binkyStr = self.mostRecentArray[indexPath.row].from_object
            
            cell.commentLbl.text = binkyStr
            
            if binkyStr == "binky"
            {
                cell.commentLbl.text = "your creation!"
                // cell.binkyPicImg.isHidden = false
                cell.binkyImgwidthCnst.constant = 21
                
                
            }
            else
            {
                cell.commentLbl.text = "commented on your creation!"
                // cell.binkyPicImg.isHidden = true
                cell.binkyImgwidthCnst.constant = 0
                
            }
            
            cell.userProfilePic.sd_setImage(with: URL(string: (self.mostRecentArray[indexPath.row].from_dependent?.profile?.picture_url)!), placeholderImage: UIImage(named: "HolderImage"))
            
            let creatTime = self.mostRecentArray[indexPath.row].from_created_at_ts
            
            let stringValue = "\(String(describing: creatTime!))"
            
            let resultStr = compareCurrentTime(stringValue)
            
            cell.dateLbl.text = resultStr
            
            if self.mostRecentArray[indexPath.row].from_creation?.media![0].s640_url != nil
            {
                cell.disImg.sd_setImage(with: URL(string: (self.mostRecentArray[indexPath.row].from_creation?.media![0].s640_url)!), placeholderImage: UIImage(named: "PlaceHolder"))
            }
            else
            {
                cell.disImg.sd_setImage(with: URL(string: (self.mostRecentArray[indexPath.row].from_creation?.media![0].url)!), placeholderImage: UIImage(named: "PlaceHolder"))
            }
            
            
            
        }
        else if indexPath.section == 1
        {
            cell.selectionStyle = .none
            cell.userNameLbl.text = self.thisWeekArray[indexPath.row].from_dependent?.username
            //  cell.commentLbl.text = self.NoticationDataArray![indexPath.row].from_object
            
            let binkyStr = self.thisWeekArray[indexPath.row].from_object
            
            cell.commentLbl.text = binkyStr
            
            if binkyStr == "binky"
            {
                cell.commentLbl.text = "your creation!"
                // cell.binkyPicImg.isHidden = false
                cell.binkyImgwidthCnst.constant = 21
                
                
            }
            else
            {
                cell.commentLbl.text = "commented on your creation!"
                // cell.binkyPicImg.isHidden = true
                cell.binkyImgwidthCnst.constant = 0
                
            }
            
            cell.userProfilePic.sd_setImage(with: URL(string: (self.thisWeekArray[indexPath.row].from_dependent?.profile?.picture_url)!), placeholderImage: UIImage(named: "HolderImage"))
            
            let creatTime = self.thisWeekArray[indexPath.row].from_created_at_ts
            
            let stringValue = "\(String(describing: creatTime!))"
            
            let resultStr = compareCurrentTime(stringValue)
            
            cell.dateLbl.text = resultStr
            
            if self.thisWeekArray[indexPath.row].from_creation?.media![0].s640_url != nil
            {
                cell.disImg.sd_setImage(with: URL(string: (self.thisWeekArray[indexPath.row].from_creation?.media![0].s640_url)!), placeholderImage: UIImage(named: "PlaceHolder"))
            }
            else
            {
                cell.disImg.sd_setImage(with: URL(string: (self.thisWeekArray[indexPath.row].from_creation?.media![0].url)!), placeholderImage: UIImage(named: "PlaceHolder"))
            }
            
        }
        else
        {
            cell.selectionStyle = .none
            cell.userNameLbl.text = self.earlierArray[indexPath.row].from_dependent?.username
            
            
            let binkyStr = self.earlierArray[indexPath.row].from_object
            
            cell.commentLbl.text = binkyStr
            
            if binkyStr == "binky"
            {
                cell.commentLbl.text = "your creation!"
                // cell.binkyPicImg.isHidden = false
                cell.binkyImgwidthCnst.constant = 21
                
            }
            else
            {
                cell.commentLbl.text = "commented on your creation!"
                // cell.binkyPicImg.isHidden = true
                cell.binkyImgwidthCnst.constant = 0
                
            }
            
            cell.userProfilePic.sd_setImage(with: URL(string: (self.earlierArray[indexPath.row].from_dependent?.profile?.picture_url)!), placeholderImage: UIImage(named: "HolderImage"))
            
            let creatTime = self.earlierArray[indexPath.row].from_created_at_ts
            
            let stringValue = "\(String(describing: creatTime!))"
            
            let resultStr = compareCurrentTime(stringValue)
            
            cell.dateLbl.text = resultStr
            
            if self.earlierArray[indexPath.row].from_creation?.media![0].s640_url != nil
            {
                cell.disImg.sd_setImage(with: URL(string: (self.earlierArray[indexPath.row].from_creation?.media![0].s640_url)!), placeholderImage: UIImage(named: "PlaceHolder"))
            }
            else
            {
                cell.disImg.sd_setImage(with: URL(string: (self.earlierArray[indexPath.row].from_creation?.media![0].url)!), placeholderImage: UIImage(named: "PlaceHolder"))
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    // MARK:- Custom methods..
    func compareCurrentTime(_ str: String?) -> String? {
        
        
        let dateTime = Double(str!)
        
        let myDate = Date(timeIntervalSince1970: dateTime!)
        
        let currentDate = Date()
        
        let timeInterval = currentDate.timeIntervalSince(myDate)
        var result: String? = nil
        
        let dim = Int(round(timeInterval / 60.0))
        
        if dim < 1 {
            result = "Just now"
        } else if dim >= 1 && dim < 2 {
            result = "1m"
        } else if dim >= 2 && dim <= 44 {
            result = String(format: "%ldm", dim)
        } else if dim >= 45 && dim <= 89 {
            result = "an hour"
        } else if dim >= 90 && dim <= 1439 {
            
            //  result = "\(Int(round(dim / 60.0))) hours"
            
            result = String(format: "%dh", (Int(round(Double(dim) / 60.0))))
            
            
        } else if dim >= 1440 && dim <= 2519 {
            result = "1d"
        } else if dim >= 2520 && dim <= 43199 {
            result = "\(Int(round(Double(dim) / 1440.0)))d"
        } else if dim >= 43200 && dim <= 86399 {
            result = "a month"
        } else if dim >= 86400 && dim <= 525599 {
            result = "\(Int(round(Double(dim) / 43200.0)))months"
        } else if dim >= 525600 && dim <= 655199 {
            result = "a year"
        } else if dim >= 655200 && dim <= 914399 {
            result = "over a year"
        } else if dim >= 914400 && dim <= 1051199 {
            result = "almost 2 years"
        } else {
            result = "\(Int(round(Double(dim) / 525600.0)))years"
        }
        return "\(String(describing: result!))"
        
    }
    // MARK:- Notifications API Call
    func GetNotificationsAPI(startAfter: String)
    {
        SVProgressHUD.show()
        
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
            
        }
        
        let url = URL(string: API.notificationAPI)
        
        let queryItems = [URLQueryItem(name: "limit", value: "10"),
                          URLQueryItem(name: "starting_after", value: startAfter)
            
        ]
        
        
        let newUrl = url!.appending(queryItems)!
        
        //  print(newUrl)
        
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
                
                let loginRespone = try JSONDecoder().decode(NotificationAPIStatus.self, from: data)
                
                SVProgressHUD.dismiss()
                
                
                if let nndata = try? JSONEncoder().encode(loginRespone.data) {
                    
                    UserDefaults.standard.set(nndata, forKey: "NotificationData")
                }
                
                guard let rrData = UserDefaults.standard.value(forKey: "NotificationData") as? Data,
                    
                    let nnData = try? JSONDecoder().decode([notifcationDetailData].self, from: rrData) else
                    
                {
                    return
                }
                
                self.notificationTblObj.mj_footer?.endRefreshing()
                self.notificationTblObj.mj_header?.endRefreshing()
                
                
                self.NoticationDataArray = nnData
                
                if startAfter == "0"
                {
                    
                    if self.NoticationDataArray!.count > 0
                    {
                        
                        self.mostRecentArray.removeAll()
                        self.thisWeekArray.removeAll()
                        self.earlierArray.removeAll()
                        
                        for item in self.NoticationDataArray! {
                            
                            let dateIs = item.from_created_at_ts
                            
                            
                            let firstPress = Double(dateIs!)
                            let timestamp = NSDate().timeIntervalSince1970
                            let secondPress = timestamp
                            let diffInSeconds = secondPress - firstPress //total time difference in seconds
                            let hours = diffInSeconds/60/60 //hours=diff in seconds / 60 sec per min / 60 min per hour
                           // print(hours)
                            
                            if hours < 24 {
                                
                               // print("less then 24 hours difference")
                                
                                self.mostRecentArray.append(item)
                                
                            } else if hours < 168{
                                
                             //   print("greater/equal to 48 hours difference")
                                
                                self.thisWeekArray.append(item)
                            }
                            else
                            {
                                self.earlierArray.append(item)
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.notificationTblObj.delegate = self
                            self.notificationTblObj.dataSource = self
                            self.notificationTblObj.reloadData()
                            self.notificationTblObj.tableFooterView = UIView()
                            self.notificationTblObj.separatorStyle = .none
                            
                            self.notificationTblObj.isHidden = false
                            
                            self.notificationTblObj.register(UINib(nibName: "NoticationTableViewCell", bundle: nil), forCellReuseIdentifier: "NoticationTableViewCell")
                            
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.notificationTblObj.isHidden = true
                        }
                    }
                    
                }
                else
                {
                    
                    for item in self.NoticationDataArray! {
                        
                        let dateIs = item.from_created_at_ts
                        
                        let firstPress = Double(dateIs!)
                        let timestamp = NSDate().timeIntervalSince1970
                        let secondPress = timestamp
                        let diffInSeconds = secondPress - firstPress //total time difference in seconds
                        let hours = diffInSeconds/60/60 //hours=diff in seconds / 60 sec per min / 60 min per hour
                       // print(hours)
                        
                        if hours < 24 {
                            
                          //  print("less then 24 hours difference")
                            
                            self.mostRecentArray.append(item)
                            
                        } else if hours < 168{
                            
                         //   print("greater/equal to 48 hours difference")
                            
                            self.thisWeekArray.append(item)
                        }
                        else
                        {
                            self.earlierArray.append(item)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.notificationTblObj.reloadData()
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
extension UIColor {
    class var separatorColor: UIColor {
        return UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
}

