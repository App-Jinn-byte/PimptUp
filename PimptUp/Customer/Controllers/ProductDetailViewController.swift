//
//  ProductDetailViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 08/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var productIV: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var delaerLabel: UILabel!
    @IBOutlet weak var dealerName: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var dealerPhone: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dealerAddress: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    @IBOutlet weak var descriptionBgView: UIView!
    @IBOutlet weak var informationBgView: UIView!
    @IBOutlet weak var productModel: UILabel!
    
    var productDetailObjWithCatId: ProductsList?
    var productDetailObjWithDealerCatId: ProductsListDealer?
    var productDetailObj: GetProductsModelResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        informationBgView.dropShadow()
        informationBgView.layer.cornerRadius = informationBgView.frame.width/20
        //cellBgView.clipsToBounds = true
        
        descriptionBgView.dropShadow()
        descriptionBgView.layer.cornerRadius = descriptionBgView.frame.width/20
        
        if (productDetailObjWithCatId != nil){
            print(productDetailObjWithCatId)
            setFields()
        }
        else if (productDetailObjWithDealerCatId != nil)  {
            setFields2()
        }
        else{
            print(productDetailObj!)
            setFields1()
        }
        
    }
    
    func setFields1(){
        
        if let description = productDetailObj?.Description{
            self.productDescription.text = description
        }
        else{
            self.productDescription.text = "not-available"
        }
        
        self.productName.text  = productDetailObj?.Name
        
        if let price = productDetailObj?.Price{
            self.productPrice.text = String(price)
        }
        else{
            self.productPrice.text = "not available"
        }
        
        if let image = productDetailObj?.ImagePath{
            var image1 = String(image.dropFirst(3))
            image1 = "https://pimptup.com/"+image1
            let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let image = URL(string: urlString!)
            
            productIV.kf.setImage(with: image)
        }
        else {
            self.productIV.image = nil
        }
        
        if let brand = productDetailObj?.Brand{
            self.productBrand.text = brand
        }
        else{
            self.productBrand.text = "not available"
        }
        if let model = productDetailObj?.ModelDescription{
            self.productModel.text = model
        }
        else{
            self.productModel.text = "not available"
        }
        if let name = productDetailObj?.UserName{
            self.dealerName.text = name
        }
        else{
            self.dealerName.text = "not available"
        }
        if let mobile = productDetailObj?.Mobile{
            self.dealerPhone.text = mobile
        }
        else{
            self.dealerPhone.text = "not available"
        }
        if let address = productDetailObj?.LocationName{
            self.dealerAddress.text = address
        }
        else{
            self.dealerAddress.text = "not available"
        }
        
        self.productType.text = "not available"
    }
    
    func setFields(){
        
        if (productDetailObjWithCatId?.CategoryId != 11){
            if let description = productDetailObjWithCatId?.Description{
                self.productDescription.text = description
            }
            else{
                self.productDescription.text = "not-available"
            }
            
            self.productName.text  = productDetailObjWithCatId?.Name
            
            if let price = productDetailObjWithCatId?.Price{
                self.productPrice.text = String(price)
            }
            else{
                self.productPrice.text = "not available"
            }
            
            if let image = productDetailObjWithCatId?.ImagePath{
                var image1 = String(image.dropFirst(3))
                image1 = "https://pimptup.com/"+image1
                let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                let image = URL(string: urlString!)
                
                productIV.kf.setImage(with: image)
            }
            else {
                self.productIV.image = nil
            }
            
            if let brand = productDetailObjWithCatId?.Brand{
                self.productBrand.text = brand
            }
            else{
                self.productBrand.text = "not available"
            }
            if let model = productDetailObjWithCatId?.ModelDescription{
                self.productModel.text = model
            }
            else{
                self.productModel.text = "not available"
            }
            if let name = productDetailObjWithCatId?.UserName{
                self.dealerName.text = name
            }
            else{
                self.dealerName.text = "not available"
            }
            if let mobile = productDetailObjWithCatId?.Mobile{
                self.dealerPhone.text = mobile
            }
            else{
                self.dealerPhone.text = "not available"
            }
            if let address = productDetailObjWithCatId?.LocationName{
                self.dealerAddress.text = address
            }
            else{
                self.dealerAddress.text = "not available"
            }
            
            if let address = productDetailObjWithCatId?.ProductType{
                self.productType.text = address
            }
            else{
                self.productType.text = "not available"
            }
        }
            
        else {
            if let description = productDetailObjWithCatId?.Description{
                self.productDescription.text = description
            }
            else{
                self.productDescription.text = "not-available"
            }
            
            self.productName.text  = productDetailObjWithCatId?.Name
            
            if let price = productDetailObjWithCatId?.Price{
                self.productPrice.text = String(price)
            }
            else{
                self.productPrice.text = "not available"
            }
            
            if let image = productDetailObjWithCatId?.ImagePath{
                var image1 = String(image.dropFirst(3))
                image1 = "https://pimptup.com/"+image1
                let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                let image = URL(string: urlString!)
                
                productIV.kf.setImage(with: image)
            }
            else {
                self.productIV.image = nil
            }
            self.brandLabel.text = "Manufacturer"
            if let manufacturer = productDetailObjWithCatId?.ManuFactureDescription{
                self.productBrand.text = manufacturer
            }
            else{
                self.productBrand.text = "not available"
            }
            
            self.typeLabel.text = "Tyre Size"
            if let size = productDetailObjWithCatId?.TyreSizeDescription{
                self.productType.text = size
            }
            else{
                self.productType.text = "not available"
            }
            
            self.modelLabel.text = "Aspect Ratio"
            if let ratio = productDetailObjWithCatId?.TyreAspectRationDescription{
                self.productModel.text = ratio
            }
            else{
                self.productModel.text = "not available"
            }
            
            self.dealerName.text = productDetailObjWithCatId?.UserName
            
            if let mobile = productDetailObjWithCatId?.Mobile{
                self.dealerPhone.text = mobile
            }
            else{
                self.dealerPhone.text = "not available"
            }
            if let address = productDetailObjWithCatId?.LocationName{
                self.dealerAddress.text = address
            }
            else{
                self.dealerAddress.text = "not available"
            }
            
            // self.productType.text = "not available"
            
        }
    }
    
    func setFields2(){
        
        if (productDetailObjWithDealerCatId?.CategoryId != 11){
            if let description = productDetailObjWithDealerCatId?.Description{
                self.productDescription.text = description
            }
            else{
                self.productDescription.text = "not-available"
            }
            
            self.productName.text  = productDetailObjWithDealerCatId?.Name
            
            if let price = productDetailObjWithDealerCatId?.Price{
                self.productPrice.text = String(price)
            }
            else{
                self.productPrice.text = "not available"
            }
            
            if let image = productDetailObjWithDealerCatId?.ImagePath{
                var image1 = String(image.dropFirst(3))
                image1 = "http://pimptup.jinndevportal.com/"+image1
                let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                let image = URL(string: urlString!)
                
                productIV.kf.setImage(with: image)
            }
            else {
                self.productIV.image = nil
            }
            
            if let brand = productDetailObjWithDealerCatId?.Brand{
                self.productBrand.text = brand
            }
            else{
                self.productBrand.text = "not available"
            }
//            if let model = productDetailObjWithDealerCatId?.m{
//                self.productModel.text = model
//            }
//            else{
//                self.productModel.text = "not available"
//            }
            if let name = productDetailObjWithDealerCatId?.UserName{
                self.dealerName.text = name
            }
            else{
                self.dealerName.text = "not available"
            }
//            if let mobile = productDetailObjWithDealerCatId?.Mobile{
//                self.dealerPhone.text = mobile
//            }
//            else{
//                self.dealerPhone.text = "not available"
//            }
            if let address = productDetailObjWithDealerCatId?.LocationName{
                self.dealerAddress.text = address
            }
            else{
                self.dealerAddress.text = "not available"
            }
            
            if let address = productDetailObjWithDealerCatId?.ProductType{
                self.productType.text = address
            }
            else{
                self.productType.text = "not available"
            }
        }
            
        else {
            if let description = productDetailObjWithDealerCatId?.Description{
                self.productDescription.text = description
            }
            else{
                self.productDescription.text = "not-available"
            }
            
            self.productName.text  = productDetailObjWithDealerCatId?.Name
            
            if let price = productDetailObjWithDealerCatId?.Price{
                self.productPrice.text = String(price)
            }
            else{
                self.productPrice.text = "not available"
            }
            
            if let image = productDetailObjWithDealerCatId?.ImagePath{
                var image1 = String(image.dropFirst(3))
                image1 = "http://pimptup.jinndevportal.com/"+image1
                let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
                let image = URL(string: urlString!)
                
                productIV.kf.setImage(with: image)
            }
            else {
                self.productIV.image = nil
            }
            self.brandLabel.text = "Manufacturer"
//            if let manufacturer = productDetailObjWithDealerCatId?.ManuFactureDescription{
//                self.productBrand.text = manufacturer
//            }
//            else{
//                self.productBrand.text = "not available"
//            }
            
            self.typeLabel.text = "Tyre Size"
//            if let size = productDetailObjWithDealerCatId?.TyreSizeDescription{
//                self.productType.text = size
//            }
//            else{
//                self.productType.text = "not available"
//            }
            
            self.modelLabel.text = "Aspect Ratio"
//            if let ratio = productDetailObjWithDealerCatId?.TyreAspectRationDescription{
//                self.productModel.text = ratio
//            }
//            else{
//                self.productModel.text = "not available"
//            }
            
            self.dealerName.text = productDetailObjWithDealerCatId?.UserName
            
//            if let mobile = productDetailObjWithDealerCatId?.Mobile{
//                self.dealerPhone.text = mobile
//            }
//            else{
//                self.dealerPhone.text = "not available"
//            }
            if let address = productDetailObjWithDealerCatId?.LocationName{
                self.dealerAddress.text = address
            }
            else{
                self.dealerAddress.text = "not available"
            }
            
            // self.productType.text = "not available"
            
        }
    }
    
}
