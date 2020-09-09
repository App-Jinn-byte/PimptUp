//
//  ProductsCollectionViewCell.swift
//  PimptUp
//
//  Created by JanAhmad on 07/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import Kingfisher

class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productIV: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    
    var productObj: GetProductsModelResponse?
    var productObj1: ProductsList?
    var productObj2: ProductsListDealer?
    override func awakeFromNib() {
        
    }
    
    func setData(){
        self.productNameLabel.text = productObj?.Name
        if let value = productObj?.Price {
            self.productPrice.text = String(value)
        }
        else{
            self.productPrice.text = "$$";
        }
        
        if let image = productObj?.ImagePath{
            var image1 = String(image.dropFirst(3))
            image1 = "\(Constants.ImagePath)"+image1
            let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let image = URL(string: urlString!)
            
            productIV.kf.setImage(with: image)
        }
        else {
            self.productIV.image = nil
        }
    }
    func setData1(){
        self.productNameLabel.text = productObj1?.Name
        if let value = productObj1?.Price {
            self.productPrice.text = String(value)
        }
        else{
            self.productPrice.text = "$$";
        }
        
        if let image = productObj1?.ImagePath{
            var image1 = String(image.dropFirst(3))
            image1 = "\(Constants.ImagePath)"+image1
            let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let image = URL(string: urlString!)
            
            productIV.kf.setImage(with: image)
        }
        else {
            self.productIV.image = nil
        }
    }
    func setData2(){
        self.productNameLabel.text = productObj2?.Name
        if let value = productObj2?.Price {
            self.productPrice.text = String(value)
        }
        else{
            self.productPrice.text = "$$";
        }
        
        if let image = productObj2?.ImagePath{
            var image1 = String(image.dropFirst(3))
            image1 = "\(Constants.ImagePath)"+image1
            let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let image = URL(string: urlString!)
            
            productIV.kf.setImage(with: image)
        }
        else {
            self.productIV.image = nil
        }
    }
}
