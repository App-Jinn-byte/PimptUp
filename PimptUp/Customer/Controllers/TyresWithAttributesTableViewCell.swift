//
//  TyresWithAttributesTableViewCell.swift
//  PimptUp
//
//  Created by JanAhmad on 06/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import Kingfisher

protocol TyreDetailProtocol {
    func onClickViewDetail(tyreObj: DealerTyresList)
}

class TyresWithAttributesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactDealerBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var rimSizeLabel: UILabel!
    @IBOutlet weak var tyreRangeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var tyreIV: UIImageView!
    @IBOutlet weak var cellBg: UIView!
    
    var cellObj: TyresList?
    var cellObjDealer: DealerTyresList?
    
    var delegate: TyreDetailProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellBg.dropShadow()
        self.cellBg.layer.cornerRadius = cellBg.frame.height/20
        
        contactDealerBtn.layer.cornerRadius = contactDealerBtn.frame.height/5
        contactDealerBtn.clipsToBounds = true
    }
    override func prepareForReuse() {
        self.tyreIV.image = nil
    }
    
    func setData(){
        self.nameLabel.text = cellObj?.Name
        self.tyreRangeLabel.text = cellObj?.TyreRange
        self.rimSizeLabel.text = cellObj?.RimSize
        
        if let price = cellObj?.Price {
            self.priceLabel.text = String(price)
        }
        else{
            self.priceLabel.text = "";
        }
        
        self.manufacturerLabel.text = cellObj?.manufacturer
        
        if let image = cellObj?.ImagePath{
            var image1 = String(image.dropFirst(3))
            image1 = "\(Constants.ImagePath)"+image1
            let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let image = URL(string: urlString!)
            
            tyreIV.kf.setImage(with: image)
        }
        else {
            self.tyreIV.image = nil
        }
    }
    
    func setDataDealer(){
        self.nameLabel.text = cellObjDealer?.Name
        self.tyreRangeLabel.text = cellObjDealer?.TyreRange
        self.rimSizeLabel.text = cellObjDealer?.RimSize
        
        if let price = cellObjDealer?.Price {
            self.priceLabel.text = String(price)
        }
        else{
            self.priceLabel.text = "";
        }
        
        self.manufacturerLabel.text = cellObjDealer?.manufacturer
        
        if let image = cellObjDealer?.ImagePath{
            var image1 = String(image.dropFirst(3))
            image1 = "\(Constants.ImagePath)"+image1
            let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let image = URL(string: urlString!)
            
            tyreIV.kf.setImage(with: image)
        }
        else {
            self.tyreIV.image = nil
        }
    }
    
    @IBAction func viewTyreBtn(_ sender: Any) {
        delegate?.onClickViewDetail(tyreObj: cellObjDealer!)
    }
}
