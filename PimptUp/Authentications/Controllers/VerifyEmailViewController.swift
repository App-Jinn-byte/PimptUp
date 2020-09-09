//
//  VerifyEmailViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 20/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit


class VerifyEmailViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var userTypeId: Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    @IBAction func submitBtn(_ sender: Any) {
        let email = emailTF.text
        let userType_Id = self.userTypeId
        
        if(email == "" ){
            Constants.Alert(title: "ERROR", message: "Email required...", controller: self)
            return
        }
        if !(email!.isValidEmail ){
            Constants.Alert(title: "ERROR", message: "Please Enter Valid Email...", controller: self)
            return
        }
        let param:[String:Any] = ["Email":email!,"UserTypeId": userType_Id!]
        
        if Reachability.isConnectedToInternet(){
            activityIndicator.startAnimating()
            APIRequests.ForgotPassword(parameters: param, completion: APIRequestCompleted)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func APIRequestCompleted(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let forgotPassword = try decoder.decode(ForgotPasswordModelResponse.self, from: data)
                
                // print(forgotPassword.CNIC)
                Constants.userEmail = forgotPassword.Email
                Constants.userId = forgotPassword.UserId
                Constants.Alert1(title: "Reset Password", message: "Email exist please Update your password", controller: self, action: handlerSuccessAlert())
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

    func setUI(){
        // Setting buttons and borders
        submitBtn.cornerRadius = 8
        
        // Setting fields spacings and paddings
       // forgotPasswordBtn.addTextSpacing(2.0)
        emailTF.setLeftPaddingPoints(25)
        self.hideKeyboardWhenTappedAround()
    }
    
    func handlerSuccessAlert() -> (UIAlertAction) -> () {
        return { action in
            self.performSegue(withIdentifier: "Reset", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as? ResetPasswordViewController
        vc?.email = Constants.userEmail
        vc?.userId = Constants.userId
    }
}
