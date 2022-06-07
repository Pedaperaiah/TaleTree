//
//  NoticationTableViewCell.swift
//  TaleTree
//
//  Created by UFL on 15/01/21.
//  Copyright © 2021 UnfoldLabs. All rights reserved.
//

import UIKit

class NoticationTableViewCell: UITableViewCell {

    @IBOutlet var userProfilePic: UIImageView!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var binkyPicImg: UIImageView!
    @IBOutlet var commentLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var disImg: UIImageView!
    @IBOutlet var binkyImgwidthCnst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
           self.disImg.layer.cornerRadius = 6
           self.disImg.layer.borderWidth = 0
           //self.beautyBtn.layer.borderColor = UIColor.lightGray.cgColor
           self.disImg.layer.masksToBounds = true
        
        userProfilePic.layer.borderWidth = 0
        userProfilePic.layer.masksToBounds = false
        userProfilePic.layer.cornerRadius = userProfilePic.frame.height/2
        userProfilePic.clipsToBounds = true
      
    }

}
