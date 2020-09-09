//
//  RequestsTableViewCell.swift
//  PimptUp
//
//  Created by JanAhmad on 04/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import Kingfisher


protocol RequestsPartCellProtocol {
    func onClickViewQuotes(id : Int)
}

class RequestsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBG: UIView!
    @IBOutlet weak var requestIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var viewQuotes: UIButton!
    
    var delegate1:RequestsPartCellProtocol?
    var cellObj: PartsRequests?
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBG.dropShadow()
        cellBG.layer.cornerRadius = cellBG.frame.width/20
        //  cellBgView.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        // cellBgView.addShadowAndRoundCorner(cornerRadius: 10/2)
        cellBG.clipsToBounds = true
        cellBG.layer.masksToBounds = false
        viewQuotes.layer.cornerRadius = viewQuotes.frame.height/5
        viewQuotes.clipsToBounds = true
    }
    override func prepareForReuse() {
        self.requestIV.image = nil
    }
    
    func setData(){
        self.nameLabel.text = cellObj?.Name
        self.brandLabel.text = cellObj?.Description
       
        if let id = cellObj?.PartRequestId {
            self.idLabel.text = String(id)
        }
        else{
            self.idLabel.text = "";
        }
        
        self.modelLabel.text = "SLM_87_A"
        if let image = cellObj?.ImagePath{
            
            let image1 = URL(string: image)
            requestIV.kf.setImage(with: image1)
        }
    
    }
    
    @IBAction func viewQuotesBtn(_ sender: Any) {
        delegate1?.onClickViewQuotes(id: cellObj!.PartRequestId)
    }
    
}
