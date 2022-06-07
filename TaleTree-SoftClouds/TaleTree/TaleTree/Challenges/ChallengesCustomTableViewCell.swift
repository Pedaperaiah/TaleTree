//
//  ChallengesCustomTableViewCell.swift
//  TaleTree
//
//  Created by UFL on 29/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import UIKit

class ChallengesCustomTableViewCell: UITableViewCell {

    @IBOutlet var cellBgView: UIView!
    
    @IBOutlet var frameImg: UIImageView!
    @IBOutlet var displayPicImg: UIImageView!
    @IBOutlet var challengetittleLbl: UILabel!
    @IBOutlet var challengeDescLbl: UILabel!
    @IBOutlet var submitedView: UIView!
    @IBOutlet var submitedImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
