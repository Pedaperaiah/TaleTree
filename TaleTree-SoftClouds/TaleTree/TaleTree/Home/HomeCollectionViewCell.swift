//
//  HomeCollectionViewCell.swift
//  TaleTree
//
//  Created by apple on 06/01/21.
//  Copyright © 2021 UnfoldLabs. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var displayImg: UIImageView!
    
    @IBOutlet weak var binkyButton: UIButton!
    @IBOutlet weak var binkyCountLbl: UILabel!
    @IBOutlet weak var imagesCountLbl: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentsCountLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    
}


