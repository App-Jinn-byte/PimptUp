//
//  TyreDetailViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 20/07/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class TyreDetailViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var manufacturerTF: UITextField!
    @IBOutlet weak var tyreRangeTF: UITextField!
    @IBOutlet weak var rimSizeTF: UITextField!
    @IBOutlet weak var tyreWidthTF: UITextField!
    @IBOutlet weak var tyreAspectRatioTF: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var tyreIV: UIImageView!
    
    var tyreObjDealer: DealerTyresList?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateBtn.layer.cornerRadius = updateBtn.frame.height/5
        updateBtn.clipsToBounds = true
        
        deleteBtn.layer.cornerRadius = deleteBtn.frame.height/5
        deleteBtn.clipsToBounds = true
        setFields()
    }
    

    func setFields(){
        nameTF.text = tyreObjDealer?.Name
        descriptionTF.text = tyreObjDealer?.Description
        if let price = tyreObjDealer?.Price {
            self.priceTF.text = String(price)
        }
        else{
            self.priceTF.text = "";
        }
        
        categoryTF.text = "Tyre"
        manufacturerTF.text = tyreObjDealer?.manufacturer
        tyreRangeTF.text = tyreObjDealer?.TyreRange
        rimSizeTF.text = tyreObjDealer?.RimSize
        tyreWidthTF.text = tyreObjDealer?.TyreWidth
        tyreAspectRatioTF.text = tyreObjDealer?.AspectRatio
        if let image = tyreObjDealer?.ImagePath{
            
            var image1 = String(image.dropFirst(3))
            image1 = "\(Constants.ImagePath)"+image1
            let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let image = URL(string: urlString!)
             tyreIV.kf.setImage(with: image)
        }
        
    }
}
