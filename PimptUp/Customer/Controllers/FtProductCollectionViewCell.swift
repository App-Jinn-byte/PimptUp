//
//  FtProductCollectionViewCell.swift
//  PimptUp
//
//  Created by JanAhmad on 09/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class FtProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bgCellView: UIView!
    @IBOutlet weak var ftProductsIV: UIImageView!
    @IBOutlet weak var ftProductNameLabel: UILabel!
    @IBOutlet weak var ftProductDescription: UILabel!
    @IBOutlet weak var ftProductPrice: UILabel!
    var productObj: FtProducts?
    override func awakeFromNib() {
        bgCellView.dropShadow()
        bgCellView.layer.cornerRadius = bgCellView.frame.height/18
    }
    override func prepareForReuse() {
        self.ftProductsIV.image = nil
    }
    
    func setCellData(){
        if let value = productObj?.Price {
            self.ftProductPrice.text = String(value)
        }
        else{
            self.ftProductPrice.text = "$$";
        }
        self.ftProductDescription.text = productObj?.Description
        self.ftProductNameLabel.text = productObj?.Name
        
        if let image = productObj?.ProductImages[0].ImagePath{
            var image1 = String(image.dropFirst(3))
            image1 = "\(Constants.ImagePath)"+image1
            let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let image = URL(string: urlString!)
            
            self.ftProductsIV.kf.setImage(with: image)
        }
        else {
            self.ftProductsIV.image = nil
        }
    }
    
}
