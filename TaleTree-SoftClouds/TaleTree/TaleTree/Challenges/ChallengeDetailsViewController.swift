//
//  ChallengeDetailsViewController.swift
//  TaleTree
//
//  Created by UFL on 30/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import MJRefresh

class ChallengeDetailsViewController: UIViewController, UICollectionViewDataSource,PinterestLayoutDelegate,UICollectionViewDelegate{
    
    @IBOutlet var detailImgView: UIImageView!
    
    @IBOutlet var challengeSubmissionCollectionview: UICollectionView!
    @IBOutlet var detailTittleLbl: UILabel!
    @IBOutlet var characterTypeImg: UIImageView!
    
    @IBOutlet var detailDesLbl: UILabel!
    
    @IBOutlet var submitImg: UIImageView!
    @IBOutlet var submissionLbl: UILabel!
    @IBOutlet var challengeSubmitBtn: UIButton!
    @IBOutlet var challengeBackBtn: UIButton!
    @IBOutlet var navSubmissionLbl: UILabel!
    
    @IBOutlet var zeroSubmissionView: UIView!
    
    var selectedChallengeId : Int?
    
    var getSubmissionDataArray: [getAllSubmissions]?
    
    let dataModel = [1,2,3,4,5,6,1,2,3,4,5,6,7,8,9,10,11,12]
    
    
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    var challengesUploadYes : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.zeroSubmissionView.isHidden = true
        self.challengeSubmitBtn.layer.cornerRadius = 24
        challengeSubmitBtn.layer.masksToBounds = true
        
        self.submitImg.isHidden = true
        
        characterTypeImg.layer.borderWidth = 0
        characterTypeImg.layer.masksToBounds = false
        characterTypeImg.layer.cornerRadius = characterTypeImg.frame.height/2
        characterTypeImg.clipsToBounds = true
        
        
        header.setRefreshingTarget(self, refreshingAction: #selector(HomeViewController.headerRefresh))
        self.challengeSubmissionCollectionview.mj_header = header
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(ChallengeViewController.footerRefresh))
        self.challengeSubmissionCollectionview.mj_footer?.isHidden = true
        self.challengeSubmissionCollectionview.mj_footer = footer
        self.footer.stateLabel?.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tabBarController?.tabBar.isHidden = true
        
        let detailUpdate = UserDefaults.standard.string(forKey: "challengesdetail")
        if detailUpdate == "challengesdetail"
        {
            UserDefaults.standard.set("removedd", forKey: "challengesdetail")
            UserDefaults.standard.removeObject(forKey: "challengesdetail")
            self.showToast(message: "Upload completed!")
            
        }
        
        if selectedChallengeId != nil{
            self.challengeDeatilAPICallMethod(selectedID: selectedChallengeId!)
        }
        
        self.allSubmissionsAPICallMethod(startAfter: "0")
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    // MARK: - Custom header methods...
    @objc func headerRefresh(){
        
        self.challengeSubmissionCollectionview.mj_header?.endRefreshing()
        
        self.allSubmissionsAPICallMethod(startAfter: "0")
        
        
    }
    
    @objc func footerRefresh(){
        footer.endRefreshingWithNoMoreData()
        //     self.footer.stateLabel?.isHidden = false
        
        let lastObject = self.getSubmissionDataArray?.last
        
      //  print(lastObject as Any)
        
        let lastObjectID = lastObject?.id
        
        if lastObjectID != nil
        {
            self.allSubmissionsAPICallMethod(startAfter: "\(String(describing: lastObjectID!))")
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
        //   label.font = UIFont(name: "SF Pro Text Semibold", size: 20.0)
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
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
    // MARK: -  Button Events...
    @IBAction func challengeSubmitBtnActn(_ sender: Any) {
        
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        if loginOrNotFlag == "loginYes"
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "NewCreationViewController") as! NewCreationViewController
            
            vc.selectedChallengeID = selectedChallengeId
            vc.userFromchallenges = true
            
            UserDefaults.standard.set("challengesdetail", forKey: "challengesdetail")
            UserDefaults.standard.synchronize()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        
    }
    
    @IBAction func challengeBackBtnActn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -  Collection view Data source and Delegate methods..
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getSubmissionDataArray?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "custom", for: indexPath) as? myRoomCollectionViewCell {
            
            cell.binkyButton.isHidden = true
            cell.commentsButton.isHidden = true
            cell.binkyCountDis.isHidden = true
            cell.commentsCountLbl.isHidden = true
            
            
            if getSubmissionDataArray![indexPath.item].media![0].s640_url != nil
            {
                cell.imageViewDis.sd_setImage(with: URL(string: (getSubmissionDataArray![indexPath.item].media![0].s640_url)!), placeholderImage: nil)
            }
            else
            {
                cell.imageViewDis.sd_setImage(with: URL(string: (getSubmissionDataArray![indexPath.item].media![0].url)!), placeholderImage: nil)
            }
            
            
            let mediaMore = getSubmissionDataArray![indexPath.row].media_count
            
            //  print(mediaMore)
            if mediaMore! <= 1
            {
                cell.morePhotosBtn.isHidden = true
            }else{
                
                cell.morePhotosBtn.isHidden = false
            }
            
            
            //    cell.imageViewDis.image = UIImage(named: "\(dataModel[indexPath.row]).jpg")
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 5
            cell.imageViewDis.contentMode = .scaleAspectFill
            
            
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        var displayImg:UIImage?
        
        if getSubmissionDataArray?.count != nil
        {
            
            if getSubmissionDataArray![indexPath.item].media![0].s640_url != nil
            {
                let outPutStr = String(describing:getSubmissionDataArray![indexPath.item].media![0].s640_url!)
                let imageUrl = URL(string: outPutStr)!
                
                let imageData = try! Data(contentsOf: imageUrl)
                displayImg = UIImage(data: imageData)
                
                
            }
            else
            {
                let outPutStr = String(describing:getSubmissionDataArray![indexPath.item].media![0].url!)
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
        
        vc.selectedCreationID = getSubmissionDataArray![indexPath.item].id
        vc.userIDMatch = getSubmissionDataArray![indexPath.item].user?.id
        
        vc.selectBinkyIdStr = getSubmissionDataArray![indexPath.item].binky_id
        
        vc.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    // MARK: - API Call Method...
    func challengeDeatilAPICallMethod(selectedID: Int)
    {
        SVProgressHUD.show()
        
        //            guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
        //                let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        //            {
        //                return
        //            }
        
        let selectIDStr = String(selectedID)
        
        var url = URL(string: API.challengesDetailAPI)!
        
        url.appendPathComponent(selectIDStr)
      //  print(url)
        
        let request = NSMutableURLRequest(url: url as URL)
        
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
        }
        else
        {
            
        }
        
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
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
                
                SVProgressHUD.dismiss()
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    //  print(json)
                    
                    if json["data"] != nil
                    {
                        if let challengedict: NSDictionary = json["data"] as? NSDictionary{
                            
                            //  print(challengedict)
                            
                            let theJSONData = try? JSONSerialization.data(withJSONObject: json["data"] as! [String: Any] , options:[])
                            
                            let chalengeSelectedData = try JSONDecoder().decode(challengeDetailData.self, from: theJSONData!)
                            
                            // print(chalengeSelectedData)
                            
                            DispatchQueue.main.async {
                                let submissionCount = chalengeSelectedData.creation_count
                                
                                if submissionCount! == 0
                                {
                                    self.navSubmissionLbl.text = "\(submissionCount!) submissions"
                                    self.submissionLbl.text = "Submissions (\(submissionCount!))"
                                }
                                else if (submissionCount! == 1)
                                {
                                    self.navSubmissionLbl.text = "\(submissionCount!) submission"
                                    self.submissionLbl.text = "Submissions (\(submissionCount!))"
                                }
                                else
                                {
                                    self.navSubmissionLbl.text = "\(submissionCount!) submissions"
                                    self.submissionLbl.text = "Submissions (\(submissionCount!))"
                                }
                                
                                self.detailTittleLbl.text = chalengeSelectedData.title
                                self.detailDesLbl.text = chalengeSelectedData.description
                                
                                self.detailImgView.sd_setImage(with: URL(string: chalengeSelectedData.picture_url!), placeholderImage: nil)
                                
                                if chalengeSelectedData.has_submitted == true
                                {
                                    self.submitImg.isHidden = false
                                }
                                else
                                {
                                    self.submitImg.isHidden = true
                                }
                                
                                if chalengeSelectedData.character_type == "letsgo" {
                                    self.characterTypeImg.image = UIImage(named: "letsprofile")
                                }
                                else if (chalengeSelectedData.character_type == "uni")
                                {
                                    self.characterTypeImg.image = UIImage(named: "uniprofile")
                                }
                                else if (chalengeSelectedData.character_type == "rushmore")
                                {
                                    self.characterTypeImg.image = UIImage(named: "rushmoreprofile")
                                }
                                else if (chalengeSelectedData.character_type == "cody")
                                {
                                    self.characterTypeImg.image = UIImage(named: "codyprofile")
                                }
                                else if (chalengeSelectedData.character_type == "rooty")
                                {
                                    self.characterTypeImg.image = UIImage(named: "rootyprofile")
                                }
                                else if (chalengeSelectedData.character_type == "doma")
                                {
                                    self.characterTypeImg.image = UIImage(named: "domaprofile")
                                }
                                else
                                {
                                    
                                    self.characterTypeImg.image = UIImage(named: "noprofile")
                                }
                                
                                
                            }
                        }
                        else
                        {
                            
                        }
                        
                    }
                    else
                    {
                        
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
    
    func allSubmissionsAPICallMethod(startAfter : String)
    {
        SVProgressHUD.show()
        
        
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
        }
        
        let url = URL(string: API.allCreationsAPI)
        
        let challengeIDStr = String(selectedChallengeId!)
        
        let queryItems = [URLQueryItem(name: "challenge_id", value: challengeIDStr),
                          
                          URLQueryItem(name: "limit", value: "10"),
                          URLQueryItem(name: "starting_after", value: startAfter)
            
        ]
        
        let newUrl = url!.appending(queryItems)!
        
      //  print(newUrl)
        
        var request = URLRequest(url: newUrl)
        
        if loginTokenData.access_token != nil
        {
            let barerToken = "Bearer \(loginTokenData.access_token!)"
            request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
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
                SVProgressHUD.dismiss()
                
                let submissionRespone = try JSONDecoder().decode(submissionAPIStatus.self, from: data)
                
                
                if let ssdata = try? JSONEncoder().encode(submissionRespone.data) {
                    
                    UserDefaults.standard.set(ssdata, forKey: "submissionData")
                }
                
                guard let sData = UserDefaults.standard.value(forKey: "submissionData") as? Data,
                    
                    let submissionData = try? JSONDecoder().decode([getAllSubmissions].self, from: sData) else
                    
                {
                    return
                }
                
                
                self.challengeSubmissionCollectionview.mj_footer?.endRefreshing()
                self.challengeSubmissionCollectionview.mj_header?.endRefreshing()
                
                
                if startAfter == "0"
                {
                    
                    self.getSubmissionDataArray?.removeAll()
                    self.getSubmissionDataArray = submissionData
                    
                    if submissionData.count > 0
                    {
                        
                        DispatchQueue.main.async {
                            self.zeroSubmissionView.isHidden = true
                            self.challengeSubmissionCollectionview.delegate = self
                            self.challengeSubmissionCollectionview.dataSource = self
                            self.challengeSubmissionCollectionview.reloadData()
                            
                            if let layout = self.challengeSubmissionCollectionview.collectionViewLayout as? PinterestLayout{
                                layout.delegate = self
                            }
                            
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.zeroSubmissionView.isHidden = false
                        }
                    }
                }
                else
                {
                    
                    if submissionData.count > 0
                    {
                        for item in submissionData
                        {
                            self.getSubmissionDataArray?.append(item)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.challengeSubmissionCollectionview.reloadData()
                        
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
