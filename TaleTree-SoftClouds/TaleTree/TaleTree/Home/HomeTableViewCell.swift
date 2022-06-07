//
//  HomeTableViewCell.swift
//  TaleTree
//
//  Created by apple on 06/01/21.
//  Copyright © 2021 UnfoldLabs. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeTableViewCell: UITableViewCell  {
    
    @IBOutlet var imageScrollView: UIScrollView!
    @IBOutlet weak var dottedButtonTop: NSLayoutConstraint!
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var tittleLable: UILabel!
    @IBOutlet weak var fffff: UIPageControl!
    @IBOutlet weak var favSportLbl: UILabel!
    @IBOutlet var titleLblHeightCnst: NSLayoutConstraint!
    
    @IBOutlet var viewHeightCnst: NSLayoutConstraint!
    @IBOutlet var dotBtnTopCnst: NSLayoutConstraint!
    @IBOutlet weak var favAnimalLbl: UILabel!
    @IBOutlet weak var favColorLbl: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var profileFirstNameLbl: UILabel!
    @IBOutlet weak var profileImgBtn: UIButton!
    
    @IBOutlet weak var dottedBtn: UIButton!
  
    
    @IBOutlet weak var binkyButton: UIButton!
    
    
    @IBOutlet weak var binkyCountLbl: UILabel!
    
    
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var pageControlLbl: UILabel!
    var passingArray:Array = [Int]()
    
    
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var scrollPlacHolderView: UIView!
    
    
    @IBOutlet weak var scrollHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    var heightDis: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//
        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        bounds = bounds.inset(by: padding)
        
        // Initialization code        
                     profileImgView.layer.borderWidth = 0
                     profileImgView.layer.masksToBounds = false
                     profileImgView.layer.cornerRadius = profileImgView.frame.height/2
                     profileImgView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
            pageControlLbl.layer.cornerRadius = 10
            pageControlLbl.clipsToBounds = true
    }
    
}
    
    
    
 
