//
//  ResetPasswordViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 21/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var email: String?
    var userId: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    @IBAction func backBtn(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        let email1 = email
        let userId1 = userId
        let password1 = passwordTF.text
        let password2 = confirmPasswordTF.text
        let userType_Id = Constants.userTypeId
        
        if(password1 == "" || password2 == ""){
            Constants.Alert(title: "ERROR", message: "Both fields are required...", controller: self)
            return
        }
        else if(password1 != password2){
            Constants.Alert(title: "ERROR", message: "Password is not matching...", controller: self)
            return
        }
        else if(password1!.count < 3  ){
            Constants.Alert(title: "ERROR", message: "Password is too short...", controller: self)
            return
        }
        
        
        let param:[String:Any] = ["Email":email1!,"Password": password1! , "UserTypeId": userType_Id , "UserId": userId1!]
        if Reachability.isConnectedToInternet(){
            activityIndicator.startAnimating()
            APIRequests.ResetPassword(parameters: param, completion: APIRequestCompleted)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }
    
    func setUI(){
        // Setting buttons and borders
        submitBtn.cornerRadius = 8
        
        // Setting fields spacings and paddings
        // forgotPasswordBtn.addTextSpacing(2.0)
        passwordTF.setLeftPaddingPoints(25)
        confirmPasswordTF.setLeftPaddingPoints(25)
        self.hideKeyboardWhenTappedAround()
    }
    
    
    fileprivate func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let resetPassword = try decoder.decode(ResetPasswordModelResponse.self, from: data)
                
                Constants.Alert(title: "Success", message: "Password Changed Successfully", controller: self, action: handler())
                activityIndicator.stopAnimating()
                
            } catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage ?? "", controller: self)
            }
            
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    func handler() -> (UIAlertAction) -> () {
        return { action in
            //self.performSegue(withIdentifier: "User", sender: nil)
            self.navigationController?.popToRootViewController(animated: true)
           // self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
           // self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
