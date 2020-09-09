//
//  BlogDetailViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 25/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class BlogDetailViewController: UIViewController {
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var blogPostedByLabel: UILabel!
    @IBOutlet weak var blogPostedDateLabel: UILabel!
    @IBOutlet weak var blogTitleLabel: UILabel!
    @IBOutlet weak var blogDescriptionText: UITextView!
    
    var blogObject: blogsList?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Blog Detail"
        blogImageView.layer.cornerRadius = blogImageView.frame.height/20
        self.blogImageView.layer.masksToBounds = true

//        if (Constants.blogimage != nil){
//        blogImageView.downloadImage(from: Constants.blogimage!)
//        }
        if let image = blogObject?.ImagePath{
            
            var image1 = String(image.dropFirst(3))
            image1 = "\(Constants.ImagePath)"+image1
            let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let image = URL(string: urlString!)
            blogImageView.kf.setImage(with: image)
        }
        blogPostedByLabel.text = blogObject?.UserName
        blogTitleLabel.text = blogObject?.Title
        blogDescriptionText.text = blogObject?.Description?.html2AttributedString
    }
}
