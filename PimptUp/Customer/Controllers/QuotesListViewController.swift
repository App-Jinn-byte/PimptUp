//
//  QuotesListViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 05/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class QuotesListViewController: UIViewController {
   
    @IBOutlet weak var quotesTV: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var requestId: Int?
    var quotesList1: [quotesList] = []
    var quoteDetail: quotedList?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print("In quotes List VC \(quoteDetail)")
        APIRequests.getQuotes(completion: APIRequestCompletedForGetQuotesByPartId, id: (quoteDetail?.PartRequestId)!)
        quotesTV.delegate = self
    }
    

    fileprivate func APIRequestCompletedForGetQuotesByPartId(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let quotes = try decoder.decode(GetQuotesByPartIdResponse.self, from: data)
                quotesList1 = quotes.Quotes
                quotesTV.reloadData()
                activityIndicator.stopAnimating()
            } catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage , controller: self)
            }
            
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
}

extension QuotesListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotesList1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuotesList") as! QuotesListTableViewCell
         cell.cellObj2 = quotesList1[indexPath.row]
        cell.setData()
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    
}
extension QuotesListViewController: ContactDealerProtocol{
    func onclickViewContracter(id: Int , name: String) {
        print(id)
         ChattingHelper.contractorId = id
         ChattingHelper.senderName = name
               print(ChattingHelper.contractorId)
               print(ChattingHelper.senderName)
               let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
               let controller = storyboard.instantiateViewController(withIdentifier: "ChatBox") as! ChattingViewController
               self.present(controller, animated: true, completion: nil)
    }
    
    
}
