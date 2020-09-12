//
//  MyVehiclesTableViewCell.swift
//  PimptUp
//
//  Created by JanAhmad on 31/03/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
protocol deletecarDelegate {
   func deleteMyCar(id:Int, name: String)
    
    func editMyCar(carObj: Vehicles)
}
class MyVehiclesTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBgView: UIView!
    @IBOutlet weak var deleteCarBtn: UIButton!
    @IBOutlet weak var carIV: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var editCarBtn: UIButton!
    var delegate:deletecarDelegate?
    var cellData: Vehicles?
    override func awakeFromNib() {
        super.awakeFromNib()
       cellBgView.dropShadow()
       
        cellBgView.layer.cornerRadius = cellBgView.frame.width/18
  
        
        deleteCarBtn.layer.cornerRadius = deleteCarBtn.frame.height/5
        deleteCarBtn.clipsToBounds = true
        
        editCarBtn.layer.cornerRadius = editCarBtn.frame.height/5
        deleteCarBtn.clipsToBounds = true
        
    }
    override func prepareForReuse() {
        carIV.image = nil
    }

    @IBAction func editMyCar(_ sender: Any) {
        delegate?.editMyCar(carObj: cellData!)
    }
    
    @IBAction func deleteMyCar(_ sender: Any) {
     delegate?.deleteMyCar(id: cellData!.UserVehicleId, name: (cellData?.VechileName!)!)
    }
}
