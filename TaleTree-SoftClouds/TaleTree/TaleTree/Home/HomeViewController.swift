//
//  HomeViewController.swift
//  TaleTree
//
//  Created by UFL on 17/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseCrashlytics
import FirebaseAnalytics
import MJRefresh

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,getFeed {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var iconsArray:Array = [UIImage]()
    var heightsArray:Array = [String]()
    
    var feedsListArray : [feedsList]?
    
    var innerItemsCount : [getMediaDetails]?
    
    var userIdenfi : Int?
    
    var getCreationId : Int?
    
    var getBinkyId : Int?
    
    var heightDis: CGFloat?
    
    
    var violation_Type :String?
    
    var refreshControl = UIRefreshControl()
    
    
    let header = MJRefreshNormalHeader()
    
    let footer = MJRefreshAutoNormalFooter()
    
    
    var currentPageNumber : Int?
    
    var getPageNumber : Int?
    
    var innerItemsImagesArray : [getMediaDetails]?
    
    
    var disImg = UIImageView()
    
    var timer = Timer()
    
    var cellHeight : CGFloat?
    
    var constraintVariable: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        feedsAPICallMethod(startAfter: "0")
        
        header.setRefreshingTarget(self, refreshingAction: #selector(HomeViewController.headerRefresh))
        self.homeTableView.mj_header = header
        // self.header.stateLabel?.isHidden = true
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(HomeViewController.footerRefresh))
        self.homeTableView.mj_footer?.isHidden = true
        self.footer.stateLabel?.isHidden = true
        self.homeTableView.mj_footer = footer
        
        self.disImg.isHidden = false
        
    }
    
    func getdata() {
        
        //  print(SharedData.data.feedsData)
        homeTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let deleteCreate = UserDefaults.standard.string(forKey: "deletecreation")
        if deleteCreate == "Delete"
        {
            self.showToast(message: "You deleted a creation.")
            
            UserDefaults.standard.set("deleteeee", forKey: "deletecreation")
            UserDefaults.standard.removeObject(forKey: "deletecreation")
            
            feedsAPICallMethod(startAfter: "0")
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    // MARK:- custom header refresh method
    @objc func refresh(_ sender: AnyObject) {
        
        feedsAPICallMethod(startAfter: "0")
        
        refreshControl.endRefreshing()
    }
    
    @objc func headerRefresh(){
        
        self.homeTableView.mj_header?.endRefreshing()
        
        feedsAPICallMethod(startAfter: "0")
        
    }
    
    @objc func footerRefresh(){
        
        self.homeTableView.mj_footer?.endRefreshing()
        
        footer.endRefreshingWithNoMoreData()
        //   self.footer.stateLabel?.isHidden = false
        
        let lastObject = feedsListArray?.last
        
      //  print(lastObject as Any)
        
        let lastCreationId = lastObject?.creation_id
        
        if lastCreationId != nil
        {
            self.feedsAPICallMethod(startAfter: "\(String(describing: lastCreationId!))")
        }
        
    }
    
    // MARK: - Table view Delegate Methods...
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feedsListArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! HomeTableViewCell
        for view in cell.scrollPlacHolderView.subviews {
            view.removeFromSuperview()
        }
        // Getting device information wheather ipad or iphone.
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
            
        case .pad:
            cell.profileImgView.layer.cornerRadius = 5
            cell.profileImgView.clipsToBounds = true
            
        case .phone:
            
            print("")
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        cell.gradientView.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.05)
        
        cell.dottedBtn.tag = indexPath.row
        cell.profileImgBtn.tag = indexPath.row
        
        
        cell.binkyButton.tag = indexPath.row
        cell.commentButton.tag = indexPath.row
        
        cell.binkyButton.addTarget(self, action: #selector(binkyLikeTapped), for: .touchUpInside)
        
        cell.commentButton.addTarget(self, action: #selector(commentNavButtonAction), for: .touchUpInside)
        
        cell.dottedBtn.addTarget(self, action: #selector(dottedButtonAction), for: .touchUpInside)
        cell.profileImgBtn.addTarget(self, action: #selector(profileImgTapped), for: .touchUpInside)
        
        cell.profileFirstNameLbl.text = feedsListArray![indexPath.row].user?.username
        cell.favColorLbl.text = (feedsListArray![indexPath.row].user?.profile?.favorites![0])!
        cell.favAnimalLbl.text = (feedsListArray![indexPath.row].user?.profile?.favorites![1])!
        cell.favSportLbl.text = feedsListArray![indexPath.row].user?.profile?.favorites![2]
        cell.profileImgView.layer.cornerRadius = cell.profileImgView.frame.size.width / 2
        
        if feedsListArray![indexPath.row].user?.profile?.group?.name != nil {
            cell.groupNameLbl.text = "  Camp " + (feedsListArray![indexPath.row].user?.profile?.group?.name)!  + "  "
            cell.groupNameLbl.isHidden = false
        }
        else
        {
            cell.groupNameLbl.isHidden = true
        }
        
        
        if let binkyString = SharedData.data.feedsData![indexPath.row].binky_count {
            
            if binkyString > 0
            {
                cell.binkyCountLbl.text = "\(binkyString)"
            }
            else
            {
                cell.binkyCountLbl.text = ""
            }
        }
        
        if let commentString = SharedData.data.feedsData![indexPath.row].comment_count {
            
            if commentString > 0
            {
                cell.commentCountLbl.text = "\(commentString)"
            }
            else
            {
                cell.commentCountLbl.text = ""
            }
            
        }
        
        if SharedData.data.feedsData![indexPath.row].binky_id != nil
        {
            cell.binkyButton.setImage(UIImage(named: "Icon_Binky_Dark"), for: .normal)
        }
        else{
            cell.binkyButton.setImage(UIImage(named: "Icon_Binky_50px"), for: .normal)
            
        }
        
        
        let titleStr = feedsListArray![indexPath.row].title!
        
        cell.profileImgView.sd_setImage(with: URL(string: (feedsListArray![indexPath.row].user?.profile?.picture_url)!), placeholderImage: UIImage(named: "HolderImage"))
        
        if titleStr == ""
        {
            cell.titleLblHeightCnst.constant = 2
            cell.dottedButtonTop.constant = 12
        }
        else{
            cell.titleLblHeightCnst.constant = 21
            cell.dottedButtonTop.constant = 25
        }
        cell.tittleLable.text = titleStr
        
        cell.groupNameLbl.layer.cornerRadius = 8
        cell.groupNameLbl.clipsToBounds = true
        
        cell.commentButton.isUserInteractionEnabled = false
        
        if let scrollMediaArray : [getMediaDetails] = feedsListArray?[indexPath.row].media {
            
            self.innerItemsImagesArray = scrollMediaArray
            
            let imageWidth:CGFloat =
                homeTableView.frame.size.width
            
            var newImageht:CGFloat = 0.0
            
            var ratio: CGFloat =  0
            
            
            var xPosition:CGFloat = 0
            var scrollViewSize:CGFloat=0
            let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: cell.scrollHeightConstraint.constant))
            
            
            cell.scrollPlacHolderView.insertSubview(scrollView, at: 0)
            scrollView.isPagingEnabled = true
            scrollView.reloadInputViews()
            scrollView.delegate = self
            scrollView.contentMode = .scaleAspectFill
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.isUserInteractionEnabled = true
            scrollView.clipsToBounds = true
            scrollView.bounces = false
            scrollView.contentSize = CGSize(width: Int(imageWidth) * scrollMediaArray.count, height: 0)
            
            scrollView.showsHorizontalScrollIndicator = false
            
            scrollView.showsVerticalScrollIndicator = false
            
            scrollView.alwaysBounceVertical = false
            scrollView.alwaysBounceHorizontal = false
            scrollView.alwaysBounceVertical = false
            
            
            var maxHeight:CGFloat = 0.0
            for model in scrollMediaArray {
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
            for i in 0..<scrollMediaArray.count {
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
                
                let mediaModel = scrollMediaArray[i]
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
                if scrollMediaArray.count > 1 {
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
                    
                    cell.scrollHeightConstraint.constant = newImageht
                }else {
                    //Multiple images
                    cell.scrollHeightConstraint.constant = maxHeight
                    if maxHeight > needHeight {
                        newImageht = needHeight
                        imgView.frame = CGRect(x: CGFloat(i) * imageWidth, y: (maxHeight - needHeight)/2, width: imageWidth, height: newImageht)
                    }else if maxHeight == needHeight {
                        newImageht = needHeight
                        imgView.frame = CGRect(x: CGFloat(i) * imageWidth, y: 0, width: imageWidth, height: newImageht)
                    }
                    backImageView.frame = CGRect(x: CGFloat(i) * imageWidth, y: 0, width: imageWidth, height:cell.scrollHeightConstraint.constant)
                }
                let imageItem = scrollMediaArray[i]
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
            scrollViewFrame.size.height = cell.scrollHeightConstraint.constant
            scrollView.frame = scrollViewFrame
            //   print("scrollHeightConstraint--\(cell.scrollHeightConstraint.constant)--newImageht\(newImageht)")
            var cellFrame = cell.frame
            cellFrame.size.height = CGFloat(maxHeight) + cell.bottomViewHeight.constant
            cell.frame = cellFrame
            cell.selectionStyle = .none
            self.rowHeights[indexPath.row] = cell.frame.size.height
            if (scrollMediaArray.count) > 1
            {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                //    let pageNum = (cell.imageScrollView.contentOffset.x / cell.imageScrollView.frame.size.width)
                let pageNum = (scrollView.contentOffset.x / cell.scrollPlacHolderView.frame.size.width)
                //   print("get pages", pageNum)
                let pageValue = Int(pageNum)
                // print(pageValue)
                cell.pageControlLbl.text =  "\(pageValue + 1)" + "/" + "\(scrollMediaArray.count)"
                
                cell.pageControlLbl.isHidden = false
            }
            else
            {
                cell.pageControlLbl.isHidden = true
            }
            
            
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTaps(_:)))
            tap.numberOfTapsRequired = 1
            tap.cancelsTouchesInView = false
            
            tap.numberOfTapsRequired = 1
            
            scrollView.addGestureRecognizer(tap)
            scrollView.tag = indexPath.row
            
            
        }
        return cell
        
    }
    
    var rowHeights:[Int:CGFloat] = [:]
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = self.rowHeights[indexPath.row]{
            return height
        }
        return UITableView.automaticDimension//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! HomeTableViewCell
        //    print("user click on table view")
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeDetailViewController") as! HomeDetailViewController
        vc.selectBinkyIdStr = SharedData.data.feedsData![indexPath.row].binky_id
        vc.userIDMatch = feedsListArray![indexPath.row].user?.user_id
        vc.selectedCreationID = feedsListArray![indexPath.row].creation_id
        vc.fromhome = self
        vc.comingFromHome = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Custom Methods...
    @objc func handleTaps(_ sender: UITapGestureRecognizer) {
        // Perform operation
        
        //   print("touch the scroll")
        
        let touchPoint = sender.location(in: self.homeTableView)
        
        let indexPath = homeTableView.indexPathForRow(at: touchPoint)
        
        //   print(indexPath?.row as Any)
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeDetailViewController") as! HomeDetailViewController
        
        vc.selectedCreationID =  SharedData.data.feedsData![indexPath!.row].creation_id
        vc.userIDMatch = feedsListArray![indexPath!.row].user?.user_id
        vc.selectBinkyIdStr = SharedData.data.feedsData![indexPath!.row].binky_id
        vc.comingFromHome = true
        vc.fromhome = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func commentNavButtonAction(sender:UIButton!)
    {
        
    }
    @objc func binkyLikeTapped(sender:UIButton!)
    {
        let cell:HomeTableViewCell = self.homeTableView.cellForRow(at: IndexPath(row: sender.tag ,  section: 0)) as! HomeTableViewCell
        
        
        getCreationId = feedsListArray?[sender.tag].creation_id
        
        getBinkyId = feedsListArray?[sender.tag].binky_id
        
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        
        if loginOrNotFlag == "loginYes"
            
        {
            
            //     print(SharedData.data.feedsData![sender.tag].binky_id)
            
            if SharedData.data.feedsData![sender.tag].binky_id != nil
            {
                
                binkyDeleteAPICall(senderValue: sender.tag)
                
            }else
            {
                
                /*
                 var heightofImg : Int?
                 
                 if self.feedsListArray![sender.tag].media![0].s640_height != nil
                 {
                 
                 heightofImg = self.feedsListArray![sender.tag].media![0].s640_height
                 }
                 else
                 {
                 heightofImg = 200
                 }
                 
                 var valHeigh = Float(heightofImg!)
                 
                 let jeremyGif = UIImage.gifImageWithName("Binky_3X")
                 
                 self.disImg = UIImageView(image: jeremyGif)
                 
                 self.disImg.isHidden = false
                 
                 if heightofImg! > 800
                 {
                 self.disImg.frame = CGRect(x: cell.frame.size.width/4 , y: 200, width: 200, height: 200)
                 
                 }
                 else
                 {
                 self.disImg.frame = CGRect(x: cell.frame.size.width/4 , y: 100, width: 200, height: 200)
                 
                 }
                 
                 cell.addSubview(self.disImg)
                 
                 self.disImg.startAnimating()
                 
                 Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeView), userInfo: nil, repeats: false)
                 */
                
                
                binkyAPICall(senderValue: sender.tag)
                
            }
            
        }else
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
            
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        
    }
    
    
    @objc func changeView() {
        self.disImg.stopAnimating()
        self.disImg.isHidden = true
    }
    // MARK:-  API calls...
    func binkyAPICall(senderValue: Int)
    {
        
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
            
        {
            return
        }
        //  SVProgressHUD.show()
        
        let urlString = API.binkyAPI
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let barerToken = "Bearer \(loginTokenData.access_token!)"
        
        request.setValue(barerToken, forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
        
        
        let object_id =  getCreationId
        
        let finalString = "{\"creation_id\":\"\(String(describing: object_id!))\"}"
        
      //  print(finalString)
        
        request.httpBody = finalString.data(using: .utf8)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data,
                
                let response = response as? HTTPURLResponse,
                
                error == nil else {                                              // check for fundamental networking error
                    
                    print("error", error ?? "Unknown error")
                    
                    if Reachability.isConnectedToNetwork(){
                        
                    }else{
                        DispatchQueue.main.async {
                            
                            //   SVProgressHUD.dismiss()
                            
                        }
                        
                    }
                    
                    return
                    
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    let getBinkyId1 = json["data"] as? [String: Any]
                    let binkyId = getBinkyId1!["id"] as? Int
                    
                    SVProgressHUD.dismiss()
                    
                    DispatchQueue.main.async {
                        
                        let sender = senderValue
                        
                        let indexPath2 = NSIndexPath(row: senderValue, section: 0)
                        
                        let newCell = self.homeTableView.cellForRow(at: indexPath2 as IndexPath) as! HomeTableViewCell?
                        
                        newCell?.binkyButton.setImage(UIImage(named: "Icon_Binky_Dark"), for: .normal)
                        
                        
                    //    print(SharedData.data.feedsData![indexPath2.row].binky_count)
                        if let binkyString =  SharedData.data.feedsData![indexPath2.row].binky_count {
                            
                            let binkyVal = binkyString + 1
                            
                            SharedData.data.feedsData![indexPath2.row].binky_count = binkyVal
                            newCell?.binkyCountLbl.text = "\(binkyVal)"
                            
                        }
                        
                        SharedData.data.feedsData![indexPath2.row].binky_id = binkyId
                        self.getBinkyId = binkyId
                        
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
        
        let binkyID = SharedData.data.feedsData![senderValue].binky_id
        
        let finalString = urlString + "\(String(describing: binkyID!))"
        
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
                            
                            //   SVProgressHUD.dismiss()
                            
                            
                        }
                        
                    }
                    
                    return
            }
            
            do {
                //create json object from data
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    SVProgressHUD.dismiss()
                    
                    DispatchQueue.main.async {
                        
                        let sender = senderValue
                        
                        let indexPath2 = NSIndexPath(row: senderValue, section: 0)
                        
                        let newCell = self.homeTableView.cellForRow(at: indexPath2 as IndexPath) as! HomeTableViewCell?
                        
                        newCell?.binkyButton.setImage(UIImage(named: "Icon_Binky_50px"), for: .normal)
                        
                        
                        if let binkyString = SharedData.data.feedsData![indexPath2.row].binky_count {
                            
                            if binkyString >= 1
                            {
                                
                                let binkyVal = binkyString - 1
                                
                                newCell?.binkyCountLbl.text = "\(binkyVal)"
                                
                                SharedData.data.feedsData![indexPath2.row].binky_count = binkyVal
                                
                                if SharedData.data.feedsData![indexPath2.row].binky_count == 0
                                {
                                    newCell?.binkyCountLbl.text = ""
                                }
                                
                            }
                            else
                            {
                                newCell?.binkyCountLbl.text = ""
                                
                            }
                            
                        }
                        
                        SharedData.data.feedsData![indexPath2.row].binky_id = nil
                        
                        //     print(SharedData.data.feedsData![indexPath2.row].binky_id)
                        
                        
                    }
                    
                }
                
            }
                
            catch let error {
                
                print(error.localizedDescription)
                
            }
            
        }
        
        
        task.resume()
        
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
        //    label.font = UIFont(name: "SF Pro Text Semibold", size: 20.0)
        
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
    // MARK: - Custom Methods....
    @objc func dottedButtonAction(sender:UIButton!)
    {
        
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        if loginOrNotFlag == "loginYes"
        {
            
            getCreationId = feedsListArray?[sender.tag].creation_id
            //  print(getCreationId)
            
            
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
                
            case .pad:
                
                userIdenfi = feedsListArray?[sender.tag].user?.user_id
                
                
                
                guard let Ldata = UserDefaults.standard.value(forKey: "loggedUserData") as? Data,
                    
                    let loginData = try? JSONDecoder().decode(userProfileDetails.self, from: Ldata) else
                    
                {
                    return
                }
                
                
                var userLogin = loginData.id
                
                //     print(userLogin)
                
                if userLogin == userIdenfi {
                    
                    let alertController = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
                    
                    let defaultAction = UIAlertAction(title: "Delete", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                        
                        
                        let alertController = UIAlertController(title: "Delete Creation", message: "You are about to delete images, comments and binkies of this creation." , preferredStyle: .actionSheet)
                        
                        
                        let defaultAction = UIAlertAction(title: "Delete", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                            
                            
                            self.deletePost()
                            
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
                else
                {
                    
                    
                    
                    let alertController = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
                    
                    let defaultAction = UIAlertAction(title: "Report", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                        
                        
                        let alertController = UIAlertController(title: "Tell us about your concern", message:nil , preferredStyle: .actionSheet)
                        
                        
                        let defaultAction = UIAlertAction(title: "Inappropriate image", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                            
                            
                            self.violation_Type = "inappropriate_image"
                            
                            
                            self.reportOnCreation()
                            
                        })
                        
                        
                        let badAction = UIAlertAction(title: "Bad Language", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                            
                            
                            self.violation_Type = "bad_language"
                            
                            
                            self.reportOnCreation()
                            
                            
                        })
                        
                        let otherAction = UIAlertAction(title: "Other", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                            
                            
                            self.violation_Type = "other"
                            
                            self.reportOnCreation()
                            
                            
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
                userIdenfi = feedsListArray?[sender.tag].user?.user_id
                
                
                guard let Ldata = UserDefaults.standard.value(forKey: "loggedUserData") as? Data,
                    
                    let loginData = try? JSONDecoder().decode(userProfileDetails.self, from: Ldata) else
                {
                    return
                }
                
                print()
                
                var userLogin = loginData.id
                
                //   print(userLogin)
                
                if userLogin == userIdenfi {
                    
                    let deleteAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                    
                    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
                        
                        let alertController = UIAlertController(title: "Delete Creation", message: "You are about to delete images,comments, and binkies of this creation.", preferredStyle: .alert)
                        let cancel = UIAlertAction(title: "Cancel" , style: .default) { (_ action) in
                            //code here…
                        }
                        
                        let delete = UIAlertAction(title: "Delete" , style: .default) { (_ action) in
                            self.deletePost()
                        }
                        
                        delete.setValue(UIColor.red, forKey: "titleTextColor")
                        
                        if #available(iOS 13.0, *) {
                            
                            cancel.setValue(UIColor.link, forKey: "titleTextColor")
                            
                        } else {
                            
                            cancel.setValue(UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), forKey: "titleTextColor")
                            
                            // UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
                            
                            // Fallback on earlier versions
                            
                        }
                        
                        alertController.addAction(cancel)
                        
                        alertController.addAction(delete)
                        
                        alertController.view.tintColor = .yellow
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        
                        // Code to unfollow
                        
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
            
            
        }else
        {
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        
    }
    func presentActionSheet() {
        
        
        let actionSheet = UIAlertController(title: "Tell us about your concern", message: nil, preferredStyle: .actionSheet)
        
        let  inappropritaeAction = UIAlertAction(title: "Inappropriate image", style: .default) { (action) in
            
            self.violation_Type = "inappropriate_image"
            
            self.reportOnCreation()
        }
        
        let badAction = UIAlertAction(title: "Bad Language", style: .default) { (action) in
            self.violation_Type = "bad_language"
            
            self.reportOnCreation()
        }
        
        let otherAction = UIAlertAction(title: "Other", style: .default) { (action) in
            self.violation_Type = "other"
            self.reportOnCreation()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        actionSheet.addAction(inappropritaeAction)
        
        actionSheet.addAction(badAction)
        
        actionSheet.addAction(otherAction)
        
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    @objc func profileImgTapped(sender:UIButton!)
    {
        
        let loginOrNotFlag = UserDefaults.standard.string(forKey: "UserLogin")
        if loginOrNotFlag == "loginYes"
        {
            
            
            guard let Ldata = UserDefaults.standard.value(forKey: "loggedUserData") as? Data,
                
                let loginData = try? JSONDecoder().decode(userProfileDetails.self, from: Ldata) else
                
            {
                return
            }
            
            
            var userLogin = loginData.id
            
            //  print(userLogin)
            
            
            userIdenfi = feedsListArray?[sender.tag].user?.user_id
            
            let userCreationID = feedsListArray?[sender.tag].creation_id
            
            
            //  print(userIdenfi)
            
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "MyRoomViewController") as! MyRoomViewController
            
            vc.userPassVal = userIdenfi
            
            vc.usercreationID = userCreationID
            
            vc.fromHomeUser = true
            vc.fromMyCamp = true
            
            SVProgressHUD.show()
            
            
            if userLogin == userIdenfi {
                vc.getLoginUserorNot = true
                vc.fromMyCamp = false
            }
            else
            {
                vc.getLoginUserorNot = false
            }
            vc.hidesBottomBarWhenPushed = false
            tabBarController?.hidesBottomBarWhenPushed = false
            vc.navigationController?.isNavigationBarHidden = false
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else
        {
            
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignUpLoginRedirectVC") as! SignUpLoginRedirectVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    // MARK: - API Call Method...
    // Main Feeds API
    func feedsAPICallMethod(startAfter: String)
    {
        SVProgressHUD.show()
        let url = URL(string: API.homeFeedsListAPI)
        
        let queryItems = [
            
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
                
                
                let feedsRespone = try JSONDecoder().decode(feedsAPIStatus.self, from: data)
                
                
                if let fdata = try? JSONEncoder().encode(feedsRespone.data) {
                    
                    UserDefaults.standard.set(fdata, forKey: "feedData")
                }
                
                guard let ffData = UserDefaults.standard.value(forKey: "feedData") as? Data,
                    
                    let feedsData = try? JSONDecoder().decode([feedsList].self, from: ffData) else
                    
                {
                    return
                }
                
                //   print(feedsData)
                
                self.homeTableView.mj_footer?.endRefreshing()
                self.homeTableView.mj_header?.endRefreshing()
                
                
                if feedsData.count > 0
                {
                    
                    if startAfter == "0"
                    {
                        self.feedsListArray?.removeAll()
                        self.feedsListArray = feedsData
                        SharedData.data.feedsData  = feedsRespone.data
                        // print("start innnnn")
                        DispatchQueue.main.async {
                            
                            self.homeTableView.setContentOffset(CGPoint(x: 0, y: -1), animated: true)
                            self.homeTableView.delegate = self
                            self.homeTableView.dataSource = self
                            self.homeTableView.reloadData()
                            
                        }
                        
                    }
                    else
                    {
                        for item in feedsData
                        {
                            self.feedsListArray?.append(item)
                            SharedData.data.feedsData?.append(item)
                        }
                        
                        
                        
                        DispatchQueue.main.async {
                            
                            self.homeTableView.reloadData()
                            
                            
                        }
                        
                    }
                    
                    
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
    
    // Delete Creation in Home
    func deletePost()
    {
        
        SVProgressHUD.show()
        guard let data = UserDefaults.standard.value(forKey: "loginTokens") as? Data,
            let loginTokenData = try? JSONDecoder().decode(loginToken.self, from: data) else
        {
            return
        }
        
        let urlString = API.deleteCeation
        
        let finalString = urlString + "\(String(describing: getCreationId!))"
        
        
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
                    
                    SVProgressHUD.dismiss()
                    
                    
                    DispatchQueue.main.async {
                        
                        self.showToast(message: "You deleted a creation.")
                        
                        let duration: Double = 1
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                            
                            self.feedsAPICallMethod(startAfter: "0")
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
    
    // MARK: -  API Call Method...
    func reportOnCreation()
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
        let object_id = getCreationId!
        
        let finalString = "{\"violation_type\":\"\(violation_type)\",\"object_type\":\"creation\",\"object_id\":\(object_id)}"
        
      //  print(finalString)
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
                    //  print(json)
                    
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
    
}
// MARK:- Extension methods...
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPageNumber = Int(round(scrollView.contentOffset.x/width))
        //   print("CurrentPage:\(String(describing: currentPageNumber))")
        
        //  print("get tag value", scrollView.tag)
        
        let sender = scrollView.tag
        
        let indexPath1 = NSIndexPath(row: sender, section: 0)
        let newCell = homeTableView.cellForRow(at: indexPath1 as IndexPath) as! HomeTableViewCell?
        
        let ArrayValues  = self.feedsListArray![scrollView.tag].media
        
        //  print(" total meadia values", ArrayValues?.count as Any)
        
        
        if ArrayValues!.count > 1
        {
            newCell?.pageControlLbl.isHidden = false
            
            newCell?.pageControlLbl.text = "\(currentPageNumber! + 1)" + "/" + "\(ArrayValues!.count)"
        }
        else
        {
            newCell?.pageControlLbl.isHidden = true
        }
    }
}

extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)+1
    }
    
}

extension UIView {
    
    var heightConstraint: NSLayoutConstraint? {
        
        get {
            
            return constraints.first(where: {
                
                $0.firstAttribute == .height && $0.relation == .equal
                
            })
            
        }
        
        set { setNeedsLayout() }
        
    }
    
    var widthConstraint: NSLayoutConstraint? {
        
        get {
            
            return constraints.first(where: {
                
                $0.firstAttribute == .width && $0.relation == .equal
                
            })
            
        }
        
        set { setNeedsLayout() }
        
    }
    
}
extension UIImageView{
    func blurImage()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
