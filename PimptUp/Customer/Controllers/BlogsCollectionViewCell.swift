//
//  BlogsCollectionViewCell.swift
//  PimptUp
//
//  Created by JanAhmad on 25/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class BlogsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var blogUserImageView: UIImageView!
    
    @IBOutlet weak var blogTitleLabel: UILabel!
    @IBOutlet weak var blogDescriptionLabel: UILabel!
    @IBOutlet weak var blogPostedByLabel: UILabel!
    @IBOutlet weak var blogDateLabel: UILabel!
    
    override func awakeFromNib() {
        blogImageView.layer.cornerRadius = 5
        blogUserImageView.layer.cornerRadius = blogUserImageView.frame.size.width/2
        blogUserImageView.clipsToBounds = true
    }
}
