//
//  ChallengeViewController.swift
//  TaleTree
//
//  Created by UFL on 19/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import MJRefresh
import WMSegmentControl

class ChallengeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var segmentViewObj: WMSegment!
    
    @IBOutlet weak var challengeSegment: UISegmentedControl!
    
    @IBOutlet var currentDateLbl: UILabel!
    @IBOutlet var challengeTblObj: UITableView!
    @IBOutlet var dateLblheightCnst: NSLayoutConstraint!
    
    var challengeDataArray: [challengesList]?
    
    let header = MJRefreshNormalHeader()
    
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Challenges"
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1.0)
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        
        segmentViewObj.isRounded = true
        segmentViewObj.selectedSegmentIndex = 1
        segmentViewObj.normalFont = UIFont.boldSystemFont(ofSize: 16)
        segmentViewObj.SelectedFont = UIFont.boldSystemFont(ofSize: 16)
        
        
        challengeSegment.isHidden = true
        if #available(iOS 13.0, *) {
            challengeSegment.layer.cornerRadius = challengeSegment.bounds.height/2
            challengeSegment.backgroundColor = UIColor.lightGray
            //  challengeSegment.layer.borderColor = UIColor.white.cgColor
            challengeSegment.selectedSegmentTintColor = #colorLiteral(red: 0.2470588235, green: 0.9607843137, blue: 0.6039215686, alpha: 1)
            challengeSegment.layer.masksToBounds = true
            
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            challengeSegment.setTitleTextAttributes(titleTextAttributes, for:.normal)
            
            let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
            challengeSegment.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        } else {
            // Fallback on earlier versions
            challengeSegment.layer.cornerRadius = challengeSegment.bounds.height/2
            challengeSegment.layer.masksToBounds = true
            challengeSegment.backgroundColor = UIColor.lightGray
            // challengeSegment.layer.borderColor = UIColor.clear.cgColor
            challengeSegment.tintColor =  #colorLiteral(red: 0.2470588235, green: 0.9607843137, blue: 0.6039215686, alpha: 1)
        }
        
        header.setRefreshingTarget(self, refreshingAction: #selector(ChallengeViewController.headerRefresh))
        self.challengeTblObj.mj_header = header
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(ChallengeViewController.footerRefresh))
        self.challengeTblObj.mj_footer?.isHidden = true
        self.challengeTblObj.mj_footer = footer
        self.footer.stateLabel?.isHidden = true
        
        self.challengesAPICallMethod(challengeType: "current", startAfter: "0")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let startDateStr = dateFormatter.string(from: Date().startOfWeek!)
        
        let edateFormatter = DateFormatter()
        edateFormatter.dateFormat = "MM/dd"
        let enddateStr = edateFormatter.string(from: Date().endOfWeek!)
        
        self.currentDateLbl.text = "\(startDateStr) - \(enddateStr)"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    // MARK: - Custom Methods...
    @objc func headerRefresh(){
        
        self.challengeTblObj.mj_header?.endRefreshing()
        
        //  self.challengesAPICallMethod(challengeType: "current", startAfter: "0")
        
        if segmentViewObj.selectedSegmentIndex == 0
        {
            self.challengesAPICallMethod(challengeType: "previous", startAfter: "0")
        }
        else if segmentViewObj.selectedSegmentIndex == 1
        {
            self.challengesAPICallMethod(challengeType: "current", startAfter: "0")
        }
        else
        {
            self.challengesAPICallMethod(challengeType: "upcoming", startAfter: "0")
        }
        
    }
    
    @objc func footerRefresh(){
        
        //  self.homeTableView.mj_footer?.endRefreshing()
        //  self.footer.stateLabel?.isHidden = false
        footer.endRefreshingWithNoMoreData()
        
        
        let lastObject = challengeDataArray?.last
        
   //     print(lastObject as Any)
        
        let lastId = lastObject?.id
        
        if lastId != nil
        {
            
            if segmentViewObj.selectedSegmentIndex == 0
            {
                self.challengesAPICallMethod(challengeType: "previous", startAfter: "\(lastId!)")
            }
            else if segmentViewObj.selectedSegmentIndex == 1
            {
                self.challengesAPICallMethod(challengeType: "current", startAfter: "\(lastId!)")
            }
            else
            {
                self.challengesAPICallMethod(challengeType: "upcoming", startAfter: "\(lastId!)")
            }
            
        }
        
    }
    // MARK: - Segment Action
    @IBAction func segmentActn(_ sender: WMSegment) {
        
        switch segmentViewObj.selectedSegmentIndex
        {
        case 0:
            
            self.dateLblheightCnst.constant = 0
            self.challengesAPICallMethod(challengeType: "previous", startAfter: "0")
            
        case 1:
            
            self.dateLblheightCnst.constant = 25
            self.challengesAPICallMethod(challengeType: "current", startAfter: "0")
            
        case 2:
            
            self.dateLblheightCnst.constant = 0
            self.challengesAPICallMethod(challengeType: "upcoming", startAfter: "0")
            
        default:
            break;
        }
        
    }
    // MARK: - Table View Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.challengeDataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengesCustomTableViewCell", for: indexPath) as! ChallengesCustomTableViewCell
        
        cell.selectionStyle = .none
        
        cell.challengetittleLbl.text = challengeDataArray![indexPath.row].title
        cell.challengeDescLbl.text = challengeDataArray![indexPath.row].description
        
        
        if challengeDataArray![indexPath.row].picture_url != nil
        {
            cell.displayPicImg.sd_setImage(with: URL(string: (challengeDataArray![indexPath.row].picture_url!)), placeholderImage: nil)
        }
        
        
        
        if challengeDataArray![indexPath.row].has_submitted == true {
            
            cell.submitedImg.isHidden = false
        }
        else
        {
            cell.submitedImg.isHidden = true
        }
        
        if challengeDataArray![indexPath.row].character_type == "letsgo" {
            
            cell.frameImg.image = UIImage(named: "letsgoFrame")
        }
        else if (challengeDataArray![indexPath.row].character_type == "uni")
        {
            cell.frameImg.image = UIImage(named: "uniFrame")
        }
        else if (challengeDataArray![indexPath.row].character_type == "rushmore")
        {
            cell.frameImg.image = UIImage(named: "rushmoreFrame")
        }
        else if (challengeDataArray![indexPath.row].character_type == "cody")
        {
            cell.frameImg.image = UIImage(named: "codyframe")
        }
        else if (challengeDataArray![indexPath.row].character_type == "rooty")
        {
            cell.frameImg.image = UIImage(named: "rootyFrame")
        }
        else if (challengeDataArray![indexPath.row].character_type == "doma")
        {
            cell.frameImg.image = UIImage(named: "domeframe")
        }
        else
        {
            cell.frameImg.image = UIImage(named: "noFrame")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChallengeID  =  challengeDataArray![indexPath.row].id
     //   print(selectedChallengeID as Any)
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ChallengeDetailsViewController") as! ChallengeDetailsViewController
        vc.selectedChallengeId = selectedChallengeID
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - Custom Button Methods...
    @IBAction func challengeSegmentActn(_ sender: UISegmentedControl) {
        
        switch challengeSegment.selectedSegmentIndex
        {
        case 0:
            
            self.challengeSegment.layer.cornerRadius = challengeSegment.bounds.height/2
            //self.currentDateLbl.isHidden = true
            
            self.dateLblheightCnst.constant = 0
            self.challengesAPICallMethod(challengeType: "previous", startAfter: "0")
            
        case 1:
            
            self.challengeSegment.layer.cornerRadius = challengeSegment.bounds.height/2
            //  self.currentDateLbl.isHidden = false
            
            self.dateLblheightCnst.constant = 25
            self.challengesAPICallMethod(challengeType: "current", startAfter: "0")
            
        case 2:
            self.challengeSegment.layer.cornerRadius = challengeSegment.bounds.height/2
            // self.currentDateLbl.isHidden = true
            
            self.dateLblheightCnst.constant = 0
            self.challengesAPICallMethod(challengeType: "upcoming", startAfter: "0")
            
        default:
            break;
        }
    }
    // MARK: - API Call Method...
    func challengesAPICallMethod(challengeType: String, startAfter : String)
    {
        SVProgressHUD.show()
    
        let url = URL(string: API.challengesAPI)
        
        //  print(challengeType)
        
        let queryItems = [URLQueryItem(name: "availability", value: challengeType),
                          
                          URLQueryItem(name: "limit", value: "10"),
                          URLQueryItem(name: "starting_after", value: startAfter)
            
        ]
        
        
        let newUrl = url!.appending(queryItems)!
        
        var request = URLRequest(url: newUrl)
        
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        if loginOrNotFlag == "loginYes"
        {
            
            guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
                let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
            {
                return
            }
            
            if loginTokenData.access_token != nil
            {
                let barerToken = "Bearer \(loginTokenData.access_token!)"
                request.setValue(barerToken, forHTTPHeaderField: "Authorization")
            }
            
        }else
        {
            
        }
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            
            guard let data = data,
                
                let response = response as? HTTPURLResponse,
                
                error == nil else {                                              // check for fundamental networking error
                    SVProgressHUD.dismiss()
                    print("error", error ?? "Unknown error")
                    
                    if Reachability.isConnectedToNetwork(){
                        
                    }else{
                        
                        DispatchQueue.main.async {
                            self.showAlertView(title: "", msg: "No Network Connection")
                            
                        }
                    }
                    
                    return
                    
            }
            
            do {
                
                SVProgressHUD.dismiss()
                
                let challengeRespone = try JSONDecoder().decode(challengesAPIStatus.self, from: data)
                
                if let chdata = try? JSONEncoder().encode(challengeRespone.data) {
                    
                    UserDefaults.standard.set(chdata, forKey: "challengeData")
                }
                
                guard let rrData = UserDefaults.standard.value(forKey: "challengeData") as? Data,
                    
                    let challengesData = try? JSONDecoder().decode([challengesList].self, from: rrData) else
                    
                {
                    return
                }
                
                self.challengeTblObj.mj_footer?.endRefreshing()
                self.challengeTblObj.mj_header?.endRefreshing()
                
                if startAfter == "0"
                {
                    self.challengeDataArray?.removeAll()
                    self.challengeDataArray = challengesData
                    
                    if challengesData.count > 0
                    {
                        DispatchQueue.main.async {
                            self.challengeTblObj.delegate = self
                            self.challengeTblObj.dataSource = self
                            self.challengeTblObj.reloadData()
                            self.challengeTblObj.tableFooterView = UIView()
                            self.challengeTblObj.separatorStyle = .none
                            
                            self.challengeTblObj.isHidden = false
                            
                            self.challengeTblObj.register(UINib(nibName: "ChallengesCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "ChallengesCustomTableViewCell")
                            
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.challengeTblObj.isHidden = true
                        }
                        
                    }
                    
                }else
                {
                    
                    if challengesData.count > 0
                    {
                        for eachItem in challengesData
                        {
                            self.challengeDataArray?.append(eachItem)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.challengeTblObj.reloadData()
                    }
                    
                }
            
                
            }
                
            catch let error {
            //    print(error.localizedDescription)
                
            }
            
        }
        task.resume()
        
    }
    
}
// MARK: - Extension Methods..
extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
}


