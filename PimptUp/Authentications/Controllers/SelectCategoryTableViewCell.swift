//
//  SelectCategoryTableViewCell.swift
//  PimptUp
//
//  Created by JanAhmad on 04/08/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
protocol indexPathdelegate: class{
    func onClick(indexPath: Int)
}
class SelectCategoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    var categoriesdata :  specialist?
    var categoriesdata1 :  companies?
    var count: Int?
    var indexPath: Int?
    var idArray  = [Int]()
    weak var delegate: indexPathdelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func checkBoxBtn(_ sender: Any) {
        guard let value = indexPath else {return}
        self.delegate?.onClick(indexPath: value)
    }
    
    func setData(){
        guard let data = self.categoriesdata else{return}
        if let num = count {
            self.numberLabel.text = String(num)
        }
        self.categoryNameLabel.text = data.Description
        print(data.isCheck)
        if data.isCheck {
            checkBox.setBackgroundImage(UIImage.init(named: "check"), for: .normal)
        }
        else{
            checkBox.setBackgroundImage(UIImage.init(named: "uncheck"), for: .normal)
        }
    }
    func setData1(){
        guard let data = self.categoriesdata1 else{return}
        if let num = count {
            self.numberLabel.text = String(num)
        }
        self.categoryNameLabel.text = data.Description
        print(data.isCheck)
        if data.isCheck {
            checkBox.setBackgroundImage(UIImage.init(named: "check"), for: .normal)
        }
        else{
            checkBox.setBackgroundImage(UIImage.init(named: "uncheck"), for: .normal)
        }
    }
}
