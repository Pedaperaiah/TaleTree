//
//  HomeDetailViewController.swift
//  TaleTree
//
//  Created by UFL on 06/01/21.
//  Copyright © 2021 UnfoldLabs. All rights reserved.
//

import UIKit
import BottomPopup
import SDWebImage
import SVProgressHUD
import MJRefresh

protocol getFeed:class  {
    func getdata()
}


class HomeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UICollectionViewDelegate, UICollectionViewDataSource {
    
    var iconsArray:Array = [UIImage]()
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var binkyView: UIView!
    @IBOutlet var commentView: UIView!
    @IBOutlet var userProfilePicImg: UIImageView!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var groupLbl: UILabel!
    @IBOutlet var reportBtn: UIButton!
    
    @IBOutlet var binkyImg: UIImageView!
    
    @IBOutlet var detailTblView: UITableView!
    @IBOutlet var favOneLbl: UILabel!
    @IBOutlet var favTwoLbl: UILabel!
    @IBOutlet var favThreeLbl: UILabel!
    
    var userIDMatch : Int?
    weak var fromhome : getFeed?
    var selectedCreationID: Int?
    var commentsDataArray: [getComments]?
    var homeDetail : homeDetailData?
    var violation_Type :String?
    var selectUserID : Int?
    var selectBinkyIdStr : Int?
    var passingArray:Array = [Int]()
    
    let kHeightMaxValue: CGFloat = 400
    let kTopCornerRadiusMaxValue: CGFloat = 25
    let kPresentDurationMaxValue = 0.4
    let kDismissDurationMaxValue = 0.4
    
    let header = MJRefreshNormalHeader()
    
    let footer = MJRefreshAutoNormalFooter()
    
    var cellSelectionValue :Bool?
    
    var currentPageNumber : Int?
    
    var innerImagesArray : [homeDetailMedia]?
    
    var comingFromHome : Bool?
    var comingFromMyRoom : Bool?
    
    var constraintVariable: NSLayoutConstraint!
    
    @IBOutlet var detailCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if passingArray.count == 3
        {
            selectedCreationID = passingArray[0]
            selectBinkyIdStr = passingArray[1]
            userIDMatch = passingArray[2]
        }
        else if (passingArray.count == 2)
        {
            selectedCreationID = passingArray[0]
            userIDMatch = passingArray[1]
        }
        
        
        
        iconsArray = [#imageLiteral(resourceName: "10"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "12"),#imageLiteral(resourceName: "challengeSubmit"),#imageLiteral(resourceName: "download"),#imageLiteral(resourceName: "butterfly_insect_nature_224976")]
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
       // print("binky id", selectBinkyIdStr as Any)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.binkyHandleTap(_:)))
        binkyView.addGestureRecognizer(tap)
        
        let ctap = UITapGestureRecognizer(target: self, action: #selector(self.commentHandleTap(_:)))
        commentView.addGestureRecognizer(ctap)
        
        userProfilePicImg.layer.borderWidth = 0
        userProfilePicImg.layer.masksToBounds = false
        userProfilePicImg.layer.cornerRadius = userProfilePicImg.frame.height/2
        userProfilePicImg.clipsToBounds = true
        
        self.groupLbl.layer.cornerRadius = 8
        
        self.groupLbl.layer.borderColor = UIColor.lightGray.cgColor
        self.groupLbl.layer.masksToBounds = true
        
        self.feedDetailAPICallMethod()
        
        header.setRefreshingTarget(self, refreshingAction: #selector(HomeDetailViewController.headerRefresh))
        self.detailTblView.mj_header = header
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(HomeDetailViewController.footerRefresh))
        self.footer.stateLabel?.isHidden = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    // MARK: - refersh header methods..
    @objc func headerRefresh(){
        
        self.detailTblView.mj_header?.endRefreshing()
        
        self.feedDetailAPICallMethod()
        
    }
    
    @objc func footerRefresh(){
        
        //  self.footer.stateLabel?.isHidden = false
        
        footer.endRefreshingWithNoMoreData()
        
        
    }
    
    // MARK: - Custom Method Events...
    @objc func binkyHandleTap(_ sender: UITapGestureRecognizer? = nil) {
      //  print("binky taping")
        
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        if loginOrNotFlag == "loginYes"
        {
            let cell:DetailTableViewCell = self.detailTblView.cellForRow(at: IndexPath(row: 0 ,  section: 0)) as! DetailTableViewCell
            
            let indexPath1 = NSIndexPath(row: 0, section: 0)
            
            if comingFromHome == true  {
                
                for (index,each) in SharedData.data.feedsData!.enumerated() {
                    if each.creation_id == self.selectedCreationID
                    {
                        
                        
                        if SharedData.data.feedsData![index].binky_id  != nil
                        {
                            self.binkyDeleteAPICall(senderValue:indexPath1.row)
                        }
                        else
                        {
                            self.binkyAPICall(senderValue:indexPath1.row)
                        }
                    }
                }
            }
            
            if comingFromMyRoom == true {
                
                for (index,each) in SharedData.data.creationsDataRoom!.enumerated() {
                    if each.id == self.selectedCreationID
                    {
                        
                        
                        if SharedData.data.creationsDataRoom![index].binky_id  != nil
                        {
                            self.binkyDeleteAPICall(senderValue:indexPath1.row)
                        }
                        else
                        {
                            self.binkyAPICall(senderValue:indexPath1.row)
                        }
                    }
                }
            }
            
            
        }else
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @objc func commentHandleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        if loginOrNotFlag == "loginYes"
        {
            guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "BottomShetViewController") as? BottomShetViewController else { return }
            popupVC.height = kHeightMaxValue
            popupVC.topCornerRadius = kTopCornerRadiusMaxValue
            popupVC.presentDuration = kPresentDurationMaxValue
            popupVC.dismissDuration = kDismissDurationMaxValue
            popupVC.popupDelegate = self
            
            popupVC.comingFromHome = comingFromHome
            popupVC.comingFromMyRoom = comingFromMyRoom
            popupVC.selectCreationID = selectedCreationID
            present(popupVC, animated: true, completion: nil)
            
        }else
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        
    }
    
    @IBAction func reportBtnActn(_ sender: Any) {
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        if loginOrNotFlag == "loginYes"
        {
            self.reportBtnTappingMethod()
        }else
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    func reportBtnTappingMethod()
    {
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            
            guard let Ldata = UserDefaults.standard.value(forKey: "loggedUserData") as? Data,
                
                let loginData = try? JSONDecoder().decode(userProfileDetails.self, from: Ldata) else
                
            {
                
                return
                
            }
            
            var userLogin = loginData.id
            
            if userLogin == userIDMatch {
                
                let alertController = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
                
                let defaultAction = UIAlertAction(title: "Delete", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                    
                    let alertController = UIAlertController(title: "Delete Creation", message: "You are about to delete images, comments and binkies of this creation." , preferredStyle: .actionSheet)
                    
                    let defaultAction = UIAlertAction(title: "Delete", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                        
                        self.deleteReportAPICall()
                        
                    })
                    
                    let deleteAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
                        
                    })
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
                        
                    })
                    
                    
                    alertController.addAction(defaultAction)
                    alertController.addAction(deleteAction)
                    alertController.addAction(cancelAction)
                    
                    if let popoverController = alertController.popoverPresentationController {
                        
                        popoverController.sourceView = self.view
                        
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        
                        popoverController.permittedArrowDirections = []
                        
                    }
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                })
                
                let deleteAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
                    
                })
                
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
                    
                })
                
                alertController.addAction(defaultAction)
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                if let popoverController = alertController.popoverPresentationController {
                    
                    popoverController.sourceView = self.view
                    
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    
                    popoverController.permittedArrowDirections = []
                    
                }
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            else
            {
                
                let alertController = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
                
                let defaultAction = UIAlertAction(title: "Report", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                    
                    
                    let alertController = UIAlertController(title: "Tell us about your concern", message:nil , preferredStyle: .actionSheet)
                    
                    
                    let defaultAction = UIAlertAction(title: "Inappropriate image", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                        
                        
                        self.violation_Type = "inappropriate_image"
                        
                        
                        self.otherReportsAPICall()
                        
                    })
                    
                    
                    let badAction = UIAlertAction(title: "Bad Language", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                        
                        self.violation_Type = "bad_language"
                        
                        self.otherReportsAPICall()
                        
                        
                    })
                    
                    let otherAction = UIAlertAction(title: "Other", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                        
                        
                        self.violation_Type = "other"
                        
                        self.otherReportsAPICall()
                        
                        
                    })
                    
                    let cancelAct = UIAlertAction(title: "Cancel", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                        
                        //  Do something here upon cancellation.
                        
                    })
                    
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
                        
                        //  Do something here upon cancellation.
                        
                    })
                    
                    
                    alertController.addAction(defaultAction)
                    alertController.addAction(badAction)
                    alertController.addAction(otherAction)
                    alertController.addAction(cancelAct)
                    
                    if let popoverController = alertController.popoverPresentationController {
                        
                        popoverController.sourceView = self.view
                        
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        
                        popoverController.permittedArrowDirections = []
                        
                    }
                    
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                })
                
                
                let deleteAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
                    
                    //  Do some destructive action here.
                    
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
                    
                    //  Do something here upon cancellation.
                    
                })
                
                
                alertController.addAction(defaultAction)
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                if let popoverController = alertController.popoverPresentationController {
                    
                    popoverController.sourceView = self.view
                    
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    
                    popoverController.permittedArrowDirections = []
                    
                }
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            
        case .phone:
            
            guard let Ldata = UserDefaults.standard.value(forKey: "loggedUserData") as? Data,
                
                let loginData = try? JSONDecoder().decode(userProfileDetails.self, from: Ldata) else
                
            {
                
                return
                
            }
            
            var userLogin = loginData.id
            
            //  print(userLogin)
            
            if userLogin == userIDMatch {
                
                let deleteAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
                    
                    let alertController = UIAlertController(title: "Delete Creation", message: "You are about to delete images, comments and binkies of this creation.", preferredStyle: .alert)
                    
                    let cancel = UIAlertAction(title: "Cancel" , style: .default) { (_ action) in
                        
                    }
                    
                    let delete = UIAlertAction(title: "Delete" , style: .default) { (_ action) in
                        
                        self.deleteReportAPICall()
                        
                    }
                    
                    delete.setValue(UIColor.red, forKey: "titleTextColor")
                    
                    if #available(iOS 13.0, *) {
                        
                        cancel.setValue(UIColor.link, forKey: "titleTextColor")
                        
                    } else {
                        
                        cancel.setValue(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forKey: "titleTextColor")
                        
                    }
                    
                    alertController.addAction(cancel)
                    
                    alertController.addAction(delete)
                    
                    alertController.view.tintColor = .yellow
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                deleteAlert.addAction(deleteAction)
                
                deleteAlert.addAction(cancelAction)
                
                self.present(deleteAlert, animated: true, completion: nil)
                
            }
            else
            {
                
                let deleteAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                
                let reportAction = UIAlertAction(title: "Report", style: .destructive) { (action: UIAlertAction) in
                    
                    self.presentActionSheet()
                    
                }
                
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                deleteAlert.addAction(reportAction)
                
                deleteAlert.addAction(cancelAction)
                
                self.present(deleteAlert, animated: true, completion: nil)
                
                
            }
            
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        
    }
    func presentActionSheet() {
        
        let actionSheet = UIAlertController(title: "Tell us about your concern", message: nil, preferredStyle: .actionSheet)
        
        let  inappropritaeAction = UIAlertAction(title: "Inappropriate image", style: .default) { (action) in
            
            self.violation_Type = "inappropriate_image"
            
            self.otherReportsAPICall()
        }
        
        let badAction = UIAlertAction(title: "Bad Language", style: .default) { (action) in
            
            self.violation_Type = "bad_language"
            
            self.otherReportsAPICall()
        }
        
        let otherAction = UIAlertAction(title: "Other", style: .default) { (action) in
            self.violation_Type = "other"
            self.otherReportsAPICall()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        actionSheet.addAction(inappropritaeAction)
        
        actionSheet.addAction(badAction)
        
        actionSheet.addAction(otherAction)
        
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func compareTimeStamp(_ str: String?) -> String? {
        
        
        let dateTime = Double(str!)
        
        let myDate = Date(timeIntervalSince1970: dateTime!)
        
        let currentDate = Date()
        
        let timeInterval = currentDate.timeIntervalSince(myDate)
        var result: String? = nil
        
        let dim = Int(round(timeInterval / 60.0))
        
        if dim < 1 {
            result = "Just now"
        } else if dim >= 1 && dim < 2 {
            result = "1 minute"
        } else if dim >= 2 && dim <= 44 {
            result = String(format: "%ld minutes", dim)
        } else if dim >= 45 && dim <= 89 {
            result = "an hour"
        } else if dim >= 90 && dim <= 1439 {
            
            result = String(format: "%d hours", (Int(round(Double(dim) / 60.0))))
            
            
        } else if dim >= 1440 && dim <= 2519 {
            result = "1 day"
        } else if dim >= 2520 && dim <= 43199 {
            result = "\(Int(round(Double(dim) / 1440.0))) days"
        } else if dim >= 43200 && dim <= 86399 {
            result = "a month"
        } else if dim >= 86400 && dim <= 525599 {
            result = "\(Int(round(Double(dim) / 43200.0))) months"
        } else if dim >= 525600 && dim <= 655199 {
            result = "a year"
        } else if dim >= 655200 && dim <= 914399 {
            result = "over a year"
        } else if dim >= 914400 && dim <= 1051199 {
            result = "almost 2 years"
        } else {
            result = "\(Int(round(Double(dim) / 525600.0))) years"
        }
        return "\(String(describing: result!)) ago"
        
    }
    
    
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
            result = "1 day"
        } else if dim >= 2520 && dim <= 43199 {
            result = "\(Int(round(Double(dim) / 1440.0))) days"
        } else if dim >= 43200 && dim <= 86399 {
            result = "a month"
        } else if dim >= 86400 && dim <= 525599 {
            result = "\(Int(round(Double(dim) / 43200.0))) months"
        } else if dim >= 525600 && dim <= 655199 {
            result = "a year"
        } else if dim >= 655200 && dim <= 914399 {
            result = "over a year"
        } else if dim >= 914400 && dim <= 1051199 {
            result = "almost 2 years"
        } else {
            result = "\(Int(round(Double(dim) / 525600.0))) years"
        }
        return "\(String(describing: result!))"
        
    }
    
    // MARK: - Table View Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
        }
        else if section == 1 {
            
            return self.commentsDataArray?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            
            let dcell = tableView.dequeueReusableCell(withIdentifier: "detailTableCell", for: indexPath) as! DetailTableViewCell
            
            //print(homeDetail)
            
            
            if homeDetail!.title! == "" && homeDetail!.description! == "" {
                
                dcell.titleHeightConstant.constant = 0
                dcell.descriptionHeighConstant.constant = 0
                dcell.bottomViewHeight.constant = 20
            }
            
            
            
            for view in dcell.imgScrollView.subviews {
                view.removeFromSuperview()
            }
            
            dcell.layerView.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.05)
            
            
            
            dcell.detailTitleLbl.text = homeDetail!.title!
            dcell.detailDescLbl.text =  homeDetail!.description!
            
            print(dcell.detailDescLbl.text)
            dcell.detailDescLbl.sizeToFit()
            dcell.detailDescLbl.layoutIfNeeded()
            
            
            let creatTime = homeDetail!.created_at_ts
            
            let stringValue = "\(String(describing: creatTime!))"
            
            let resultStr = compareTimeStamp(stringValue)
            
            dcell.timeStampLbl.text = resultStr
            
            
            if comingFromHome == true {
                
                
                for (index,each) in SharedData.data.feedsData!.enumerated() {
                    if each.creation_id == self.selectedCreationID
                    {
                        
                        if let binkyString = SharedData.data.feedsData![index].binky_count{
                            
                            if binkyString > 0
                            {
                                dcell.detailBinkyCountLbl.text = "\(binkyString)"
                            }
                            else
                            {
                                dcell.detailBinkyCountLbl.text = ""
                            }
                        }
                        
                        
                        if let commentString = SharedData.data.feedsData![index].comment_count {
                            
                            if commentString > 0
                            {
                                dcell.detailCommentCntLbl.text = "\(commentString)"
                                
                                
                                SharedData.data.feedsData![index].comment_count = commentString
                                self.fromhome?.getdata()
                                
                                
                            }
                            else
                            {
                                dcell.detailCommentCntLbl.text = ""
                            }
                            
                        }
                        
                    }
                }
            }
            
            if comingFromMyRoom == true {
                
                
                for (index,each) in SharedData.data.creationsDataRoom!.enumerated() {
                    if each.id == self.selectedCreationID
                    {
                        
                        if let binkyString = SharedData.data.creationsDataRoom![index].binky_count{
                            
                            if binkyString > 0
                            {
                                dcell.detailBinkyCountLbl.text = "\(binkyString)"
                            }
                            else
                            {
                                dcell.detailBinkyCountLbl.text = ""
                            }
                        }
                        
                        
                        if let commentString = SharedData.data.creationsDataRoom![index].comment_count {
                            
                            if commentString > 0
                            {
                                dcell.detailCommentCntLbl.text = "\(commentString)"
                                
                                
                                SharedData.data.creationsDataRoom![index].comment_count = commentString
                                self.fromhome?.getdata()
                                
                                
                            }
                            else
                            {
                                dcell.detailCommentCntLbl.text = ""
                            }
                            
                        }
                        
                    }
                }
            }
            
            
            if homeDetail!.binky_id != nil
            {
                dcell.detailBinkyBtn.setImage(UIImage(named: "Icon_Binky_Dark"), for: .normal)
            }
            else{
                dcell.detailBinkyBtn.setImage(UIImage(named: "Icon_Binky_50px"), for: .normal)
            }
            
            if let detailMediaArray : [homeDetailMedia] = homeDetail!.media {
                
                self.innerImagesArray = detailMediaArray
                
                let imageWidth:CGFloat =
                    detailTblView.frame.size.width
                
                var newImageht:CGFloat = 0.0
                
                var ratio: CGFloat =  0
                
                
                var xPosition:CGFloat = 0
                var scrollViewSize:CGFloat=0
                let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: dcell.scrollHeightConstraint.constant))
                
                
                dcell.imgScrollView.insertSubview(scrollView, at: 0)
                scrollView.isPagingEnabled = true
                scrollView.reloadInputViews()
                scrollView.delegate = self
                scrollView.contentMode = .scaleAspectFill
                scrollView.translatesAutoresizingMaskIntoConstraints = false
                scrollView.isUserInteractionEnabled = true
                scrollView.clipsToBounds = true
                scrollView.bounces = false
                scrollView.contentSize = CGSize(width: Int(imageWidth) * detailMediaArray.count, height: 0)
                
                scrollView.showsHorizontalScrollIndicator = false
                
                scrollView.showsVerticalScrollIndicator = false
                
                scrollView.alwaysBounceVertical = false
                scrollView.alwaysBounceHorizontal = false
                scrollView.alwaysBounceVertical = false
                
                
                var maxHeight:CGFloat = 0.0
                for model in detailMediaArray {
                    var ratio: CGFloat = 0.0
                    if let s640_height = model.s640_height, let s640_width = model.s640_width {
                        ratio = CGFloat(s640_height) / CGFloat(s640_width)
                    }else {
                        if let originalWidth = model.original_width, let originalHeight = model.original_height {
                            ratio = CGFloat(originalHeight) / CGFloat(originalWidth)
                        }
                    }
                    var needHeight = imageWidth * ratio
                    if needHeight > 500 {
                        needHeight = 500
                    }else if needHeight < 200 {
                        needHeight = 200
                    }
                    if maxHeight == 0.0 {
                        maxHeight = needHeight
                    }else {
                        if needHeight > maxHeight {
                            maxHeight = needHeight
                        }
                    }
                }
                for i in 0..<detailMediaArray.count {
                    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light))
                    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    blurEffectView.isUserInteractionEnabled = true
                    
                    let backImageView = UIImageView()
                    backImageView.contentMode = .scaleAspectFill
                    backImageView.clipsToBounds = true
                    backImageView.isUserInteractionEnabled = true
                    
                    
                    let imgView = UIImageView()
                    imgView.contentMode = .scaleAspectFill
                    imgView.clipsToBounds = true
                    imgView.isUserInteractionEnabled = true
                    
                    let mediaModel = detailMediaArray[i]
                    var ratio: CGFloat = 0.0
                    if let s640_height = mediaModel.s640_height, let s640_width = mediaModel.s640_width {
                        ratio = CGFloat(s640_height) / CGFloat(s640_width)
                    }else {
                        if let originalWidth = mediaModel.original_width, let originalHeight = mediaModel.original_height {
                            ratio = CGFloat(originalHeight) / CGFloat(originalWidth)
                        }
                    }
                    
                    
                    // let ratio = CGFloat(s640_height) / CGFloat(s640_width)
                    //  print("ration--\(ratio)")
                    var needHeight = imageWidth * ratio
                    var needI = 0
                    if detailMediaArray.count > 1 {
                        needI = 1
                        
                    }
                    if needHeight > 500 {
                        needHeight = 500
                    }else if needHeight < 200 {
                        needHeight = 200
                    }
                    if needI == 0 {
                        newImageht = needHeight
                        imgView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: newImageht)
                        
                        dcell.scrollHeightConstraint.constant = newImageht
                    }else {
                        //Multiple images
                        dcell.scrollHeightConstraint.constant = maxHeight
                        if maxHeight > needHeight {
                            newImageht = needHeight
                            imgView.frame = CGRect(x: CGFloat(i) * imageWidth, y: (maxHeight - needHeight)/2, width: imageWidth, height: newImageht)
                        }else if maxHeight == needHeight {
                            newImageht = needHeight
                            imgView.frame = CGRect(x: CGFloat(i) * imageWidth, y: 0, width: imageWidth, height: newImageht)
                        }
                        backImageView.frame = CGRect(x: CGFloat(i) * imageWidth, y: 0, width: imageWidth, height:dcell.scrollHeightConstraint.constant)
                    }
                    let imageItem = detailMediaArray[i]
                    if imageItem.s640_url != nil
                    {
                        if let url = imageItem.s640_url {
                            imgView.sd_setImage(with: URL(string:url), completed: { (image, error, type, url) in
                                DispatchQueue.main.async {
                                    imgView.image = image
                                    backImageView.image = image
                                    backImageView.frame = CGRect(x: CGFloat(i) * imageWidth, y: 0, width: imageWidth, height:maxHeight)
                                    blurEffectView.frame = CGRect(x: CGFloat(i) * imageWidth, y: 0, width: imageWidth, height: maxHeight)
                                }
                            })
                        }
                    }
                    else
                    {
                        if let url = imageItem.url {
                            
                            imgView.sd_setImage(with: URL(string:url), completed: { (image, error, type, url) in
                                imgView.image = image
                                backImageView.image = image
                                backImageView.frame = CGRect(x: CGFloat(i) * imageWidth, y: 0, width: imageWidth, height:maxHeight)
                                blurEffectView.frame = CGRect(x: CGFloat(i) * imageWidth, y: 0, width: imageWidth, height: maxHeight)
                            })
                        }
                    }
                    scrollView.addSubview(backImageView)
                    scrollView.addSubview(blurEffectView)
                    scrollView.addSubview(imgView)
                    
                }
                // tableView.beginUpdates()
                var scrollViewFrame = scrollView.frame
                scrollViewFrame.size.height = dcell.scrollHeightConstraint.constant
                scrollView.frame = scrollViewFrame
                //   print("scrollHeightConstraint--\(cell.scrollHeightConstraint.constant)--newImageht\(newImageht)")
                var cellFrame = dcell.frame
                cellFrame.size.height = CGFloat(maxHeight) + dcell.bottomViewHeight.constant
                dcell.frame = cellFrame
                dcell.selectionStyle = .none
                self.rowHeights[indexPath.row] = dcell.frame.size.height
                if (detailMediaArray.count) > 1
                {
                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                    //    let pageNum = (cell.imageScrollView.contentOffset.x / cell.imageScrollView.frame.size.width)
                    let pageNum = (scrollView.contentOffset.x / dcell.imgScrollView.frame.size.width)
                    //  print("get pages", pageNum)
                    let pageValue = Int(pageNum)
                    // print(pageValue)
                    dcell.detailPageNumLbl.text =  "\(pageValue + 1)" + "/" + "\(detailMediaArray.count)"
                    
                    dcell.detailPageNumLbl.isHidden = false
                }
                else
                {
                    dcell.detailPageNumLbl.isHidden = true
                }
                
            }
            
            
            dcell.detailImgScrollView.tag = indexPath.row
            
            dcell.detailBinkyBtn.tag = indexPath.row
            dcell.detailCommentBtn.tag = indexPath.row
            dcell.detailCommentCntLbl.tag = indexPath.row
            
            dcell.detailBinkyBtn.addTarget(self, action: #selector(binkyButtonAction), for: .touchUpInside)
            
            dcell.detailCommentBtn.addTarget(self, action: #selector(commentButtonAction), for: .touchUpInside)
            
            
            return dcell
        }
            
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            
            cell.selectionStyle = .none
            
            let commentText = self.commentsDataArray![indexPath.row].text
            
            if commentText == "Very beautiful ❤️" {
                cell.userCommentLbl.text = "  " + commentText! + " "
                cell.userCommentLbl.backgroundColor = UIColor(red: 251/255, green: 212/255, blue: 166/255, alpha: 1.0)
            }
            else if commentText == "Kind thoughts 🌹"
            {
                cell.userCommentLbl.text = "  " + commentText! + " "
                
                cell.userCommentLbl.backgroundColor = UIColor(red: 205/255, green: 252/255, blue: 210/255, alpha: 1.0)
                
            }
                
            else if commentText == "So cool 🤩"
            {
                cell.userCommentLbl.text = "  " + commentText! + " "
                
                cell.userCommentLbl.backgroundColor = UIColor(red: 243/255, green: 246/255, blue: 180/255, alpha: 1.0)
            }
                
            else if commentText == "Quite interesting 😃"
            {
                cell.userCommentLbl.text = "  " + commentText! + " "
                
                cell.userCommentLbl.backgroundColor = UIColor(red: 213/255, green: 213/255, blue: 250/255, alpha: 1.0)
            }
            else if commentText == "Super creative 👏"
            {
                cell.userCommentLbl.text = "  " + commentText! + " "
                
                cell.userCommentLbl.backgroundColor = UIColor(red: 254/255, green: 199/255, blue: 228/255, alpha: 1.0)
            }
            else if commentText == "Great colors 🌈"
            {
                cell.userCommentLbl.text = "  " + commentText! + " "
                
                cell.userCommentLbl.backgroundColor = UIColor(red: 190/255, green: 228/255, blue: 255/255, alpha: 1.0)
            }
            else if commentText == "Really funny 😆"
            {
                cell.userCommentLbl.text = "  " + commentText! + " "
                
                cell.userCommentLbl.backgroundColor = UIColor(red: 175/255, green: 241/255, blue: 239/255, alpha: 1.0)
            }
            else if commentText == "Amazing details 👀"
            {
                cell.userCommentLbl.text = "  " + commentText! + " "
                
                cell.userCommentLbl.backgroundColor = UIColor(red: 250/255, green: 234/255, blue: 148/255, alpha: 1.0)
            }
            
            
            cell.userProfileName.text = self.commentsDataArray![indexPath.row].dependent?.username
            
            
            if self.commentsDataArray![indexPath.row].dependent?.profile?.picture_url != nil
            {
                
                cell.userProfileImg.sd_setImage(with: URL(string: (self.commentsDataArray![indexPath.row].dependent?.profile?.picture_url)!), placeholderImage: UIImage(named: "HolderImage"))
            }
            else
            {
                cell.userProfileImg.image = UIImage(named: "HolderImage")
            }
            
            let creatTime = self.commentsDataArray![indexPath.row].created_at_ts
            
            let stringValue = "\(String(describing: creatTime!))"
            
            let resultStr = compareCurrentTime(stringValue)
            
            cell.dateLbl.text = resultStr
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    var rowHeights:[Int:CGFloat] = [:]
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            if let height = self.rowHeights[indexPath.row]{
                print("new row height", height)
                return height
            }
            return UITableView.automaticDimension
            
        }
        else if indexPath.section == 1
        {
            return 80
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    // MARK: - Collection view methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            
            return homeDetail?.media?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! HomeCollectionViewCell
            
            if (homeDetail?.binky_count)! >= 1 {
                
                cell.binkyCountLbl.text =  "\((String(describing: homeDetail!.binky_count!)))"
                
                //  cell.binkyButton.setImage(UIImage(named: "Icon_Binky_Dark"), for: .normal)
            }
            else
            {
                cell.binkyCountLbl.text = ""
                //   cell.binkyButton.setImage(UIImage(named: "binky_Gray_icon"), for: .normal)
            }
            
            if homeDetail?.binky_id != nil
            {
                cell.binkyButton.setImage(UIImage(named: "Icon_Binky_Dark"), for: .normal)
            }
            else{
                cell.binkyButton.setImage(UIImage(named: "Icon_Binky_50px"), for: .normal)
            }
            
            if (homeDetail?.comment_count)! >= 1 {
                cell.commentsCountLbl.text = "\(String(describing: homeDetail!.comment_count!))"
                
                SharedData.data.feedsData![indexPath.row].comment_count = homeDetail!.comment_count!
            }
            else
            {
                cell.commentsCountLbl.text = ""
            }
            
            cell.imagesCountLbl.layer.cornerRadius = 10
            cell.imagesCountLbl.clipsToBounds = true
            
            //  cell.displayImg.sd_setImage(with: URL(string: (homeDetail?.media![indexPath.item].url)!), placeholderImage: UIImage(named: "HolderImage"))
            
            cell.displayImg.sd_setImage(with: URL(string: (homeDetail?.media![indexPath.item].url)!), placeholderImage: nil )
            
            if (homeDetail?.media_count)! > 1
            {
                cell.imagesCountLbl.isHidden = false
                cell.imagesCountLbl.text = "\(indexPath.item + 1)" + "/" + "\(homeDetail!.media_count!)"
            }
            else
            {
                cell.imagesCountLbl.isHidden = true
            }
            
            cell.binkyButton.tag = indexPath.item
            
            cell.binkyButton.addTarget(self, action: #selector(binkyButtonAction), for: .touchUpInside)
            
            cell.commentButton.tag = indexPath.item
            cell.commentButton.addTarget(self, action: #selector(commentButtonAction), for: .touchUpInside)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        //  print("user click from colelction view")
        
    }
    
    // MARK: - Custom Button Evnts...
    @objc func binkyButtonAction(sender:UIButton!)
    {
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        if loginOrNotFlag == "loginYes"
        {
            
            if comingFromHome == true {
                
                for (index,each) in SharedData.data.feedsData!.enumerated() {
                    if each.creation_id == self.selectedCreationID
                    {
                        if  SharedData.data.feedsData![index].binky_id != nil
                        {
                            self.binkyDeleteAPICall(senderValue: sender.tag)
                        }else
                        {
                            self.binkyAPICall(senderValue: sender.tag)
                        }
                    }
                    
                    
                }
            }
            
            if comingFromMyRoom == true {
                
                for (index,each) in SharedData.data.creationsDataRoom!.enumerated() {
                    if each.id == self.selectedCreationID
                    {
                        if  SharedData.data.creationsDataRoom![index].binky_id != nil
                        {
                            self.binkyDeleteAPICall(senderValue: sender.tag)
                        }else
                        {
                            self.binkyAPICall(senderValue: sender.tag)
                        }
                    }
                    
                    
                }
            }
            
        }else
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    @objc func commentButtonAction(sender:UIButton!)
    {
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        if loginOrNotFlag == "loginYes"
        {
            
            guard let popupVC = storyboard?.instantiateViewController(withIdentifier: "BottomShetViewController") as? BottomShetViewController else { return }
            popupVC.height = kHeightMaxValue
            popupVC.topCornerRadius = kTopCornerRadiusMaxValue
            popupVC.presentDuration = kPresentDurationMaxValue
            popupVC.dismissDuration = kDismissDurationMaxValue
            popupVC.popupDelegate = self
            popupVC.comingFromHome = comingFromHome
            popupVC.comingFromMyRoom = comingFromMyRoom
            popupVC.selectCreationID = selectedCreationID
            present(popupVC, animated: true, completion: nil)
            
        }else
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    // MARK: -  API CAll Methods..
    func feedDetailAPICallMethod()
    {
        
        //   SVProgressHUD.show()
        
        
        let selectIDStr = String("\(selectedCreationID!)")
        
        var url = URL(string: API.getFeedDetailAPI)!
        
        url.appendPathComponent(selectIDStr)
       // print(url)
        
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
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                  //  print(json)
                    
                    
                    if json["data"] != nil
                    {
                        if let challengedict: NSDictionary = json["data"] as? NSDictionary{
                            
                            //  print(challengedict)
                            
                            let theJSONData = try? JSONSerialization.data(withJSONObject: json["data"] as! [String: Any] , options:[])
                            
                            let homeDetailFeeds = try JSONDecoder().decode(homeDetailData.self, from: theJSONData!)
                            
                            let hDetailData = try JSONDecoder().decode(homeDetailData.self, from: theJSONData!)
                            
                            //   print(hDetailData)
                            
                            self.homeDetail = hDetailData
                            
                            SharedData.data.getHomeDetailFeed  = homeDetailFeeds
                            
                            self.GetCommentsAPICallMethod()
                            
                            DispatchQueue.main.async {
                                
                                self.userNameLbl.text = hDetailData.user?.username
                                
                                if hDetailData.user?.profile?.group?.name != nil
                                {
                                    self.groupLbl.text = "  Camp " + (hDetailData.user?.profile?.group?.name)! + "  "
                                    
                                    self.groupLbl.isHidden = false
                                }
                                else
                                {
                                    self.groupLbl.isHidden = true
                                }
                                
                                
                                if hDetailData.user?.profile?.favorites != nil
                                {
                                    self.favOneLbl.text = (hDetailData.user?.profile?.favorites![0])!
                                    self.favTwoLbl.text = (hDetailData.user?.profile?.favorites![1])!
                                    self.favThreeLbl.text = hDetailData.user?.profile?.favorites![2]
                                }
                                
                                
                                if hDetailData.user?.profile?.picture_url != nil
                                {
                                    self.userProfilePicImg.sd_setImage(with: URL(string: (hDetailData.user?.profile?.picture_url!)!), placeholderImage: UIImage(named: "HolderImage"))
                                }
                                else
                                {
                                    self.userProfilePicImg.image = UIImage(named: "HolderImage")
                                    
                                }
                                
                                
                                if hDetailData.binky_id != nil
                                {
                                    self.binkyImg.image = #imageLiteral(resourceName: "Icon_Binky_Dark")
                                    
                                    self.selectBinkyIdStr = self.homeDetail?.binky_id
                                }
                                else
                                {
                                    self.binkyImg.image = #imageLiteral(resourceName: "binky_Gray_icon")
                                }
                                
                                
                                self.detailTblView.delegate = self
                                self.detailTblView.dataSource = self
                                self.detailTblView.reloadData()
                                self.detailTblView.tableFooterView = UIView()
                                self.detailTblView.separatorStyle = .none
                                
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
            }
                
            catch let error {
                print(error.localizedDescription)
                
            }
            
        }
        task.resume()
        
    }
    
    func GetCommentsAPICallMethod()
    {
        //   SVProgressHUD.show()
        
        let url = URL(string: API.getCommentsAPI)
        
        let creationIDStr = String("\(selectedCreationID!)")
        
        let queryItems = [URLQueryItem(name: "creation_id", value: creationIDStr),
                          
                          URLQueryItem(name: "limit", value: "20")
            
        ]
        
        let newUrl = url!.appending(queryItems)!
        
        //  print(newUrl)
        
        var request = URLRequest(url: newUrl)
        
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
                
                let commentsRespone = try JSONDecoder().decode(getCommentsAPIStatus.self, from: data)
                
                if let ssdata = try? JSONEncoder().encode(commentsRespone.data) {
                    
                    UserDefaults.standard.set(ssdata, forKey: "commentsData")
                }
                
                guard let sData = UserDefaults.standard.value(forKey: "commentsData") as? Data,
                    
                    let commentsData = try? JSONDecoder().decode([getComments].self, from: sData) else
                    
                {
                    return
                }
                
                self.commentsDataArray = commentsData
                
                if self.commentsDataArray!.count > 0
                {
                    DispatchQueue.main.async {
                        self.detailTblView.delegate = self
                        self.detailTblView.dataSource = self
                        self.detailTblView.reloadData()
                        self.detailTblView.tableFooterView = UIView()
                        self.detailTblView.separatorStyle = .none
                        
                        self.detailTblView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
                        
                    }
                }
                else
                {
                    print("No comments")
                }
                
            }
                
            catch let error {
                print(error.localizedDescription)
                
            }
            
        }
        task.resume()
        
    }
    
    func deleteReportAPICall()
    {
        
        SVProgressHUD.show()
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
        }
        
        let urlString = API.deleteCeation
        
        let finalString = urlString + "\(String(describing: selectedCreationID!))"
        
        
        let url = URL(string: finalString)!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    // check for fundamental networking error
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
                    
                 //   print(json)
                    
                    SVProgressHUD.dismiss()
                    
                    DispatchQueue.main.async {
                        
                        UserDefaults.standard.set("Delete", forKey: "deletecreation")
                        UserDefaults.standard.synchronize()
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
    }
    
    func otherReportsAPICall()
    {
        
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
        }
        
        SVProgressHUD.show()
        
        let urlString = API.reportOnCreation
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let violation_type = self.violation_Type!
        let object_id = "\(String(describing: selectedCreationID!))"
        
        let finalString = "{\"violation_type\":\"\(violation_type)\",\"object_type\":\"creation\",\"object_id\":\(object_id)}"
        
       // print(finalString)
        request.httpBody = finalString.data(using: .utf8)
        
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
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                   // print(json)
                    
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        self.showAlertView(title: "You've reported a feed", msg: "We will remove the content if it violates our Terms of Service.")
                        
                    }
                }
                else
                {
                    print("json error")
                    
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
    }
    
    func binkyAPICall(senderValue: Int)
    {
        
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
            
        {
            return
        }
        
        //    SVProgressHUD.show()
        
        let urlString = API.binkyAPI
        
        let url = URL(string: urlString)!
        
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
        
        let object_id = "\(String(describing: selectedCreationID!))"
        
        let finalString = "{\"creation_id\":\"\(object_id)\"}"
        
        
       // print(finalString)
        
        request.httpBody = finalString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data,
                
                let response = response as? HTTPURLResponse,
                
                error == nil else {                                              // check for fundamental networking error
                    
                    print("error", error ?? "Unknown error")
                    
                    if Reachability.isConnectedToNetwork(){
                        
                        
                    }else{
                        
                        DispatchQueue.main.async {
                            
                            //      SVProgressHUD.dismiss()
                            
                            self.showAlertView(title: "", msg: "No Network Connection")
                            
                        }
                        
                    }
                    
                    return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    // print(json)
                    
                    let getBinkyId = json["data"] as? [String: Any]
                    
                    let binkyId = getBinkyId!["id"] as? Int
                    
                    //   print(binkyId)
                    
                    SVProgressHUD.dismiss()
                    
                    
                    DispatchQueue.main.async {
                        
                        self.binkyImg.image = #imageLiteral(resourceName: "Icon_Binky_Dark")
                        
                        let sender = senderValue
                        
                        let indexPath2 = NSIndexPath(row:0 , section: 0)
                        
                        let newCell = self.detailTblView.cellForRow(at: indexPath2 as IndexPath) as! DetailTableViewCell?
                        
                        newCell?.detailBinkyBtn.setImage(UIImage(named: "Icon_Binky_Dark"), for: .normal)
                        
                        
                        if self.comingFromHome == true {
                            
                            
                            for (index,each) in SharedData.data.feedsData!.enumerated() {
                                
                                //  print(self.userIDMatch)
                                //    print(each.user?.user_id )
                                if each.creation_id == self.selectedCreationID
                                {
                                    if let binkyString = SharedData.data.feedsData![index].binky_count  {
                                        
                                        let binkyVal = binkyString + 1
                                        
                                        newCell?.detailBinkyCountLbl.text = "\(binkyVal)"
                                        
                                        self.fromhome?.getdata()
                                        SharedData.data.feedsData![index].binky_id = binkyId
                                        //   SharedData.data.getHomeDetailFeed!.binky_id = binkyId
                                        self.selectBinkyIdStr = binkyId
                                    }
                                }
                            }
                        }
                        
                        if self.comingFromMyRoom == true {
                            
                            
                            for (index,each) in SharedData.data.creationsDataRoom!.enumerated() {
                                
                                if each.id == self.selectedCreationID
                                {
                                    if let binkyString = SharedData.data.creationsDataRoom![index].binky_count  {
                                        
                                        let binkyVal = binkyString + 1
                                        
                                        
                                        //    SharedData.data.getHomeDetailFeed?.binky_count = binkyVal
                                        
                                        SharedData.data.creationsDataRoom![index].binky_count = binkyVal
                                        
                                        newCell?.detailBinkyCountLbl.text = "\(binkyVal)"
                                        
                                        self.fromhome?.getdata()
                                        SharedData.data.creationsDataRoom![index].binky_id = binkyId
                                        //   SharedData.data.getHomeDetailFeed!.binky_id = binkyId
                                        self.selectBinkyIdStr = binkyId
                                    }
                                }
                            }
                        }
                        
                    }
                    
                }
                else
                {
                    print("json error")
                    
                }
            }
            catch let error {
                
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
    }
    
    func binkyDeleteAPICall(senderValue: Int)
    {
        //   SVProgressHUD.show()
        
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
            
        {
            return
        }
        
        let urlString = API.binkyDeleteAPI
        
      //  print(selectBinkyIdStr as Any)
        
        let finalString = urlString + "\(String(describing: selectBinkyIdStr!))"
        
        let url = URL(string: finalString)!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "DELETE"
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data,
                
                let response = response as? HTTPURLResponse,
                
                error == nil else {
                    
                    print("error", error ?? "Unknown error")
                    
                    if Reachability.isConnectedToNetwork(){
                        
                        
                    }else{
                        
                        DispatchQueue.main.async {
                            
                            SVProgressHUD.dismiss()
                            //
                            self.showAlertView(title: "", msg: "No Network Connection")
                            
                        }
                        
                    }
                    
                    return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    DispatchQueue.main.async {
                        
                        let sender = senderValue
                        
                        let indexPath2 = NSIndexPath(row: 0, section: 0)
                        
                        let newCell = self.detailTblView.cellForRow(at: indexPath2 as IndexPath) as! DetailTableViewCell?
                        
                        newCell?.detailBinkyBtn.setImage(UIImage(named: "Icon_Binky_50px"), for: .normal)
                        
                        self.binkyImg.image =  #imageLiteral(resourceName: "binky_Gray_icon")
                        
                        
                        if self.comingFromHome == true {
                            
                            
                            for (index,each) in SharedData.data.feedsData!.enumerated() {
                                if each.creation_id == self.selectedCreationID
                                {
                                    
                                    if let binkyString = SharedData.data.feedsData![index].binky_count {
                                        
                                        if binkyString >= 1
                                        {
                                            
                                            let binkyVal = binkyString - 1
                                            
                                            newCell?.detailBinkyCountLbl.text = "\(binkyVal)"
                                            
                                            SharedData.data.feedsData![index].binky_count = binkyVal
                                            
                                            self.fromhome?.getdata()
                                            
                                            SharedData.data.feedsData![index].binky_id = nil
                                            if SharedData.data.feedsData![index].binky_count == 0
                                            {
                                                newCell?.detailBinkyCountLbl.text = ""
                                            }
                                            
                                        }
                                        else
                                        {
                                            newCell?.detailBinkyCountLbl.text = ""
                                            
                                        }
                                        
                                    }
                                }
                            }
                        }
                        
                        if self.comingFromMyRoom == true {
                            
                            for (index,each) in SharedData.data.creationsDataRoom!.enumerated() {
                                if each.id == self.selectedCreationID
                                {
                                    
                                    if let binkyString = SharedData.data.creationsDataRoom![index].binky_count {
                                        
                                        if binkyString >= 1
                                        {
                                            
                                            let binkyVal = binkyString - 1
                                            
                                            newCell?.detailBinkyCountLbl.text = "\(binkyVal)"
                                            
                                            SharedData.data.creationsDataRoom![index].binky_count = binkyVal
                                            
                                            
                                            self.fromhome?.getdata()
                                            
                                            SharedData.data.creationsDataRoom![index].binky_id = nil
                                            if SharedData.data.creationsDataRoom![index].binky_count == 0
                                            {
                                                newCell?.detailBinkyCountLbl.text = ""
                                            }
                                            
                                        }
                                        else
                                        {
                                            newCell?.detailBinkyCountLbl.text = ""
                                            
                                        }
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                }
                else
                {
                }
            }
            catch let error {
                
                print(error.localizedDescription)
                
            }
        }
        
        task.resume()
        
    }
    
    // MARK: -  Button Events...
    @IBAction func backBtnActn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK:- Extension methods...
extension HomeDetailViewController: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
      //  print("bottomPopupViewLoaded")
        

        
    }
    
    func bottomPopupWillAppear() {
     //   print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
      //  print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
     //   print("bottomPopupWillDismiss")
        
        
        
        let bottomBack = UserDefaults.standard.string(forKey: "BottomBack")
        if bottomBack == "bottomBack"
        {
            
            UserDefaults.standard.set("vbbbbbv", forKey: "BottomBack")
            UserDefaults.standard.removeObject(forKey: "BottomBack")
            
            DispatchQueue.main.async {
                
                //   self.feedDetailAPICallMethod()
                
                self.GetCommentsAPICallMethod()
                
            }
            
        }
        else
        {
            
        }
        
    }
    
    func bottomPopupDidDismiss() {
      //  print("bottomPopupDidDismiss")
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        
       // print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}


extension HomeDetailViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView.tag == 1{
            let size = collectionView.frame.size
            
            //          //  var str = heightsArray[indexPath.item]
            //            heightDis = CGFloat((str as NSString).floatValue)
            //            print(heightDis)
            //            print(size.height)
            // return CGSize(width: (size.width), height:heightDis!)
            return CGSize(width: (size.width), height:250)
        }
        return CGSize()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
        
    }
}

extension HomeDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPageNumber = Int(round(scrollView.contentOffset.x/width))
     //   print("CurrentPage:\(String(describing: currentPageNumber))")
        
      //  print("get tag value", scrollView.tag)
        
        let sender = scrollView.tag
        let indexPath1 = NSIndexPath(row: sender, section: 0)
        
        let custCell = self.detailTblView.cellForRow(at: indexPath1 as IndexPath) as! DetailTableViewCell?
        
        let countArray = self.homeDetail?.media
        
        if countArray!.count > 1
        {
            custCell?.detailPageNumLbl.text =  "\(currentPageNumber! + 1)" + "/" + "\(countArray!.count)"
            
            custCell?.detailPageNumLbl.isHidden = false
        }
        else
        {
            custCell?.detailPageNumLbl.isHidden = true
        }
        
    }
}

