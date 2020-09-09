//
//  PopUpViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 09/08/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var requestIdLabel: UILabel!
    @IBOutlet weak var requestnameLabel: UILabel!
    @IBOutlet weak var quoteValueTF: UITextField!
    
    var unquotedObject: quotedList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        submitButton.layer.cornerRadius = submitButton.frame.height/5
        submitButton.clipsToBounds = true
        print (unquotedObject)
       
        if let id = unquotedObject?.PartRequestId {
            self.requestIdLabel.text = String(id)
        }
        else{
            self.requestIdLabel.text = "";
        }
        self.requestnameLabel.text = unquotedObject?.Name
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    @IBAction func placeQuote(_ sender: Any) {
        let id = unquotedObject?.PartRequestId
        let value = quoteValueTF.text
        
        if(value == ""){
            Constants.Alert(title: "Input Required", message: "Please add quote value", controller: self)
            return
        }
        
        
                let param:[String:Any] = ["RequestId":id,"Quote":value,"QoutedBy": Constants.userId]
        
        
        
                if Reachability.isConnectedToInternet(){
                    activityIndicator.startAnimating()
        
                    APIRequests.AddQoutes(parameters: param, completion: APIRequestCompleted)
                }
                else {
                    print("Internet connection not available")
        
                    Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
                }
    }
    
    
    
    fileprivate func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                    let quote = try decoder.decode(QuoteRequestResponse.self, from: data)
                    print(quote)
                    activityIndicator.stopAnimating()
                
                    Constants.Alert(title: "Success", message: "Quoted for this Part Successfully", controller: self, action: handlerSuccessAlert())
                
            }
            catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage, controller: self)
            }
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    func handlerSuccessAlert() -> (UIAlertAction) -> () {
        return { action in
            // self.performSegue(withIdentifier: "Reset", sender: nil)
            //self.navigationController?.popViewController(animated: true)
             self.view.removeFromSuperview()
        }
    }
}
