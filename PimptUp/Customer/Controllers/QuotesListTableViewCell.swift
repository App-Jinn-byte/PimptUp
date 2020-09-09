//
//  QuotesListTableViewCell.swift
//  PimptUp
//
//  Created by JanAhmad on 05/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
protocol ContactDealerProtocol {
    func onclickViewContracter(id : Int, name: String)
}
class QuotesListTableViewCell: UITableViewCell {
    @IBOutlet weak var cellbgView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dealerName: UILabel!
    @IBOutlet weak var quotePriceLabel: UILabel!
    @IBOutlet weak var contactDealerBtn: UIButton!
    var cellObj2: quotesList?
    var delegate: ContactDealerProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellbgView.dropShadow()
        self.cellbgView.layer.cornerRadius = cellbgView.frame.height/20
        self.backgroundView?.clipsToBounds = true
        contactDealerBtn.layer.cornerRadius = contactDealerBtn.frame.height/5
        contactDealerBtn.clipsToBounds = true
        
    }
    func setData(){
        self.dealerName.text = cellObj2?.DealerName
        if let id = cellObj2?.RequetQuoteId {
            self.idLabel.text = String(id)
        }
        else{
            self.idLabel.text = "";
        }
         if let id = cellObj2?.QuotePrice {
                   self.quotePriceLabel.text = String(id)
               }
               else{
                   self.quotePriceLabel.text = "";
               }
    
    }
    @IBAction func contactDealer(_ sender: Any) {
        delegate?.onclickViewContracter(id: (cellObj2?.DealerID)!, name: (cellObj2?.DealerName)!)
    }
    
}
