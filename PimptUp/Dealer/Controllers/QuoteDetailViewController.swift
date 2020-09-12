//
//  QuoteDetailViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 26/07/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class QuoteDetailViewController: UIViewController {

    
    
    @IBOutlet weak var productIV: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var delaerLabel: UILabel!
    @IBOutlet weak var dealerName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var descriptionBgView: UIView!
    @IBOutlet weak var informationBgView: UIView!
    @IBOutlet weak var productModel: UILabel!
    
    var quoteDetail: quotedList?
    override func viewDidLoad() {
        super.viewDidLoad()

        informationBgView.dropShadow()
        informationBgView.layer.cornerRadius = informationBgView.frame.width/20
        //cellBgView.clipsToBounds = true
        
        descriptionBgView.dropShadow()
        descriptionBgView.layer.cornerRadius = descriptionBgView.frame.width/20
        self.navigationItem.title = "Quotes Detail"
        print (quoteDetail!)
        setFields()
    }
    func setFields(){
        if let image = quoteDetail?.ImagePath{
            
           
            let urlString = image.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlString!)
            productIV.kf.setImage(with: url)
        }
        else {
            self.productIV.image = nil
        }
        self.productName.text = quoteDetail?.Name
        if let brand = quoteDetail?.BrandName{
            self.productBrand.text = brand
        }
        else{
            self.productBrand.text = "not available"
        }
        if let model = quoteDetail?.ModelName{
            self.productModel.text = model
        }
        else{
            self.productModel.text = "not available"
        }
     
        if let descr = quoteDetail?.Description{
            self.productDescription.text = descr
        }
        else{
            self.productDescription.text = "not available"
        }
        
        if let type = quoteDetail?.ProductTypeName{
            self.productType.text = type
        }
        else{
            self.productType.text = "not available"
        }
        
        if let year  = quoteDetail?.UserVehicleYear{
            self.dealerName.text = year
        }
        else{
            self.dealerName.text = "not available"
        }
    }

}
