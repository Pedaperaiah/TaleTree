//
//  CommentTableViewCell.swift
//  TaleTree
//
//  Created by UFL on 07/01/21.
//  Copyright © 2021 UnfoldLabs. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet var userProfileImg: UIImageView!
    @IBOutlet var userProfileName: UILabel!
    @IBOutlet var userCommentLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        self.userCommentLbl.layer.cornerRadius = 8
        self.userCommentLbl.layer.borderWidth = 0
        //self.beautyBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.userCommentLbl.layer.masksToBounds = true
        
               userProfileImg.layer.borderWidth = 0
               userProfileImg.layer.masksToBounds = false
               userProfileImg.layer.cornerRadius = userProfileImg.frame.height/2
               userProfileImg.clipsToBounds = true
        
    }
    
}
