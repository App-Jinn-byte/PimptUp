//
//  RequestsListViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 04/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class RequestsListViewController: UIViewController {

    @IBOutlet weak var requestsListTV: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var partRequests: [PartsRequests] = []
    var requestId:Int?
    override func viewDidLoad() {
        super.viewDidLoad()

      requestsListTV.delegate = self
        activityIndicator.startAnimating()
        APIRequests.getPartRequests(completion: APIRequestCompletedForAddPartsRequest)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = " "
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "RequestsLists"
    }
    fileprivate func APIRequestCompletedForAddPartsRequest(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let parts = try decoder.decode(GetPartsRequestModelresponse.self, from: data)
                partRequests = parts.partRequests
                requestsListTV.reloadData()
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
    func handler() -> (UIAlertAction) -> () {
        return { action in
            self.loadView()
        }
    }

}
extension RequestsListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partRequests.count
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "RequestsList" , ind) as! RequestsTableViewCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestsList", for: indexPath) as! RequestsTableViewCell
        cell.cellObj = partRequests[indexPath.row]
        cell.setData()
        cell.delegate1 = self
        return cell
    }
    
}

extension RequestsListViewController: RequestsPartCellProtocol{
    func onClickViewQuotes(id: Int) {
       self.requestId = id
        print("delegate request \(id)")
        let vc = UIStoryboard.init(name: "TabBar", bundle: Bundle.main).instantiateViewController(withIdentifier: "QUotesList") as? QuotesListViewController
        vc!.requestId = self.requestId
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
