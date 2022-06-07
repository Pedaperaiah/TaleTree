//
//  DetailTableViewCell.swift
//  TaleTree
//
//  Created by UFL on 11/01/21.
//  Copyright © 2021 UnfoldLabs. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet var detailCollectionCell: UICollectionView!
    
    @IBOutlet weak var desVsTimeStampConstant: NSLayoutConstraint!
    @IBOutlet weak var titleVSdesConstant: NSLayoutConstraint!
    @IBOutlet weak var descriptionHeighConstant: NSLayoutConstraint!
    @IBOutlet weak var titleHeightConstant: NSLayoutConstraint!
    @IBOutlet var detailTitleLbl: UILabel!
    
    @IBOutlet var detailDescLbl: UILabel!
    
    @IBOutlet var detailImgScrollView: UIScrollView!
    @IBOutlet var timeStampLbl: UILabel!
    
    @IBOutlet var layerView: UIView!
    
    @IBOutlet var detailBinkyBtn: UIButton!
    
    @IBOutlet var detailBinkyCountLbl: UILabel!
    
    @IBOutlet var detailCommentBtn: UIButton!
    
    @IBOutlet var detailCommentCntLbl: UILabel!
    @IBOutlet var detailPageNumLbl: UILabel!
    
    @IBOutlet var imgScrollView: UIView!
    
    
    @IBOutlet weak var scrollHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
               detailPageNumLbl.layer.cornerRadius = 10
               detailPageNumLbl.clipsToBounds = true
    }

}
