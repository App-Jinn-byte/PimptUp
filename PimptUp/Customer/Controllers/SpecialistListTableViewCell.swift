//
//  SpecialistListTableViewCell.swift
//  PimptUp
//
//  Created by JanAhmad on 15/06/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class SpecialistListTableViewCell: UITableViewCell {

    @IBOutlet weak var specialistIV: UIImageView!
    @IBOutlet weak var specialistName: UILabel!
    @IBOutlet weak var specialistCategories: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    
    var cellObj: list?
    override func awakeFromNib() {
        super.awakeFromNib()
      
        contactButton.layer.cornerRadius = contactButton.frame.height/5
        contactButton.clipsToBounds = true
    }
    override func prepareForReuse() {
         self.specialistIV.image = nil
    }
    
    func setData(){
        specialistName.text = cellObj?.UserName
        specialistCategories.text = cellObj?.SpecialistCategoryNames
        
        if let image = cellObj?.ImagePath{
            if image.first != "."{
           // var image1 = String(image.dropFirst(3))
            //image1 = "http://pimptup.jinndevportal.com/"+image1
            let urlString = image.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let image = URL(string: urlString!)
            
           specialistIV.kf.setImage(with: image)
            }
            else{
                 var image1 = String(image.dropFirst(3))
                image1 = "\(Constants.ImagePath)"+image1
                let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                let image = URL(string: urlString!)
                
                specialistIV.kf.setImage(with: image)
            }
        }
        else {
            self.specialistIV.image = nil
        }
    }
}
