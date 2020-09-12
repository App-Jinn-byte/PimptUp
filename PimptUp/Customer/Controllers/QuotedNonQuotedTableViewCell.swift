//
//  QuotedNonQuotedTableViewCell.swift
//  PimptUp
//
//  Created by JanAhmad on 24/06/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
protocol QuoteDetail {
    func onclickViewDetail(obj: quotedList)
    func onClickPostQuote(obj:quotedList)
    func onClickViewQuotes(obj:quotedList)
}
class QuotedNonQuotedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var quoteItBtn: UIButton!
    @IBOutlet weak var trailingViewDeatilBtn: NSLayoutConstraint!
    @IBOutlet weak var viewQuotesBtn: UIButton!
    var cellObj: quotedList?
    var delegate: QuoteDetail?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.dropShadow()
        self.bgView.layer.cornerRadius = bgView.frame.height/20
        self.backgroundView?.clipsToBounds = true
        detailsBtn.layer.cornerRadius = detailsBtn.frame.height/5
        detailsBtn.clipsToBounds = true
        if(Constants.userTypeId == 2){
            quoteItBtn.layer.cornerRadius = quoteItBtn.frame.height/5
            quoteItBtn.clipsToBounds = true
        }
        if(Constants.userTypeId == 3){
            viewQuotesBtn.layer.cornerRadius = viewQuotesBtn.frame.height/5
            viewQuotesBtn.clipsToBounds = true
        }
        
    }
    
    func setData(){
        if let id = cellObj?.PartRequestId {
            self.idLabel.text = String(id)
        }
        else{
            self.idLabel.text = "";
        }
        
        self.nameLabel.text = cellObj?.Name
        self.descriptionLabel.text = cellObj?.Description
        self.productTypeLabel.text = cellObj?.ProductTypeName
        self.brandLabel.text = cellObj?.BrandName
        self.modelLabel.text = cellObj?.ModelName
        
        if((cellObj?.Quote)! != 0){
            quoteItBtn.isHidden = true
            
            if(Constants.userTypeId != 4 || Constants.userTypeId != 5){
                           trailingViewDeatilBtn.constant  = 140
                       }
        }
        else{
            if(Constants.userTypeId == 3){
                viewQuotesBtn.isHidden = true
            }
            if(Constants.userTypeId != 4 && Constants.userTypeId != 5){
                trailingViewDeatilBtn.constant  = 140
            }
            if (Constants.userTypeId == 2){
                quoteItBtn.isHidden = false
                trailingViewDeatilBtn.constant = 50
            }
        }
    }
    
    @IBAction func viewDetailBtn(_ sender: Any) {
        delegate?.onclickViewDetail(obj: cellObj!)
    }
    
    @IBAction func postQuote(_ sender: Any) {
        delegate?.onClickPostQuote(obj: cellObj!)
    }
    
    @IBAction func viewQuotesBtn(_ sender: Any) {
        delegate?.onClickViewQuotes(obj: cellObj!)
    }
    
}
