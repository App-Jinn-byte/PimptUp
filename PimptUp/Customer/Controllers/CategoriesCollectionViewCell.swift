//
//  CategoriesCollectionViewCell.swift
//  PimptUp
//
//  Created by JanAhmad on 06/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

protocol SetBgViewController {
    func onClickBtn(indexPath: Int, item: String)
}
class CategoriesCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var categoriesBtn: UIButton!
    var isSelect:Bool?
    var item: String?
    var id: Int?
    var delegate:SetBgViewController?
    override func awakeFromNib() {
        self.categoriesBtn.setTitle("\(String(describing: item))", for: .normal)
        //self.categoriesBtn.setTitleColor(.black, for: .normal)
 
    }
    
    override func prepareForReuse() {
       // self.categoriesBtn.setTitleColor(.black, for: .normal)
    }
    
    @IBAction func onclickBtn(_ sender: Any) {
        delegate?.onClickBtn(indexPath: self.id!, item: self.item!)
         
    }
    
}
