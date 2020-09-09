//
//  LoginViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 19/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var selectSpecialistTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var usertypeLabel: UILabel!
    @IBOutlet weak var specialistInputView: UIView!
    @IBOutlet weak var inputStackView: UIStackView!
    @IBOutlet weak var stackVieTopConstraint: NSLayoutConstraint!
    
    var types:[String] = ["Specialist", "Mechanic"]
    var typesId:[Int] = [4,5]
    var categoryTypeId: Int?
    let defaults = UserDefaults.standard
    var userTypeId: Int?
    var deviceId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        print("Usertypeid\(userTypeId)")
        if userTypeId == 4{
            specialistInputView.isHidden = false
            setPickerView()
        }
        else{
            specialistInputView.isHidden = true
            stackVieTopConstraint.constant = 0
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController
        secondViewController.userTypeId = self.userTypeId
        self.navigationController?.pushViewController(secondViewController, animated: false)
        
    }
    @IBAction func forgotPasswordBtn(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Reset") as! VerifyEmailViewController
        secondViewController.userTypeId = self.userTypeId
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        let email = emailTF.text
        let password = passwordTF.text
        
        if (userTypeId == 4){
            if(email == "" || password == "" || selectSpecialistTF.text == ""){
                Constants.Alert(title: "LogIn Error", message: "All fields are required", controller: self)
                return
            }
        }
        if(email == "" || password == ""){
            Constants.Alert(title: "LogIn Error", message: "Both fields are required", controller: self)
            return
        }
            
        else if password!.count < 4 {
            
            Constants.Alert(title: "Login Error!", message: "Incorrect email or password", controller: self)
            
            return
        }
        else if email!.isEmpty || !(email!.isValidEmail) {
            Constants.Alert(title: "Invalid Email", message: "Please Enter Valid Email", controller:  self)
            return
        }
        
        deviceId = UIDevice.current.identifierForVendor!.uuidString
        print(deviceId!)
        
        var param:[String:Any] = [:]
            
        if (userTypeId == 4){
            param = ["Email":email!,"Password":password!,"UserTypeId": self.categoryTypeId!,"DeviceId":deviceId!]
        }
        else {
            param = ["Email":email!,"Password":password!,"UserTypeId": self.userTypeId!,"DeviceId":deviceId!]
        }
        print(param)
        activityIndicator.startAnimating()
        if Reachability.isConnectedToInternet(){
            //Constants.Alert(title: "Connected", message: "congrats", controller: self)
            APIRequests.Login(parameters: param, completion: APIRequestCompleted)
        }
        else {
            activityIndicator.stopAnimating()
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
                
                let loginResponse = try decoder.decode(LoginModelResponse.self, from: data)
                
                print(loginResponse.Email)
                
                self.defaults.set(loginResponse.Email, forKey: "email")
                self.defaults.set(loginResponse.Password, forKey: "password")
                activityIndicator.stopAnimating()
                Constants.userId = loginResponse.UserId
                Constants.userName = loginResponse.UserName ?? "Anonymous Name"
                Constants.userTypeId = loginResponse.UserTypeId
                
                UserDefaults.standard.set(true, forKey: "LoggedIn")
                UserDefaults.standard.set(loginResponse.UserName, forKey: "UserName")
                UserDefaults.standard.set(loginResponse.UserId, forKey: "UserId")
                UserDefaults.standard.set(loginResponse.UserTypeId, forKey: "UserTypeId")
                //Constants.Alert(title: "Success", message: "\(loginResponse.UserName)Successfully LoggedIn", controller: self)
                
                if (loginResponse.UserTypeId == 3 ){
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBar")
                    self.present(controller, animated: true, completion: nil)
                }
                else if (loginResponse.UserTypeId == 2){
                    let storyboard = UIStoryboard(name: "Dealer", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBar2")
                    self.present(controller, animated: true, completion: nil)
                    UserDefaults.standard.set(loginResponse.PartsTypeId, forKey: "PartTypeId")
                    Constants.partTypeId = loginResponse.PartsTypeId ?? 0
                }
                else if (loginResponse.UserTypeId == 4 || loginResponse.UserTypeId == 5){
                    let storyboard = UIStoryboard(name: "Specialist", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBar3")
                    self.present(controller, animated: true, completion: nil)
                }
            }
            catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Login Error", message: Constants.statusMessage ?? "", controller: self)
            }
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    
    func setUI(){
        // Setting buttons and borders
        loginBtn.layer.cornerRadius = 5
        signupBtn.borderWidth = 1
        signupBtn.layer.cornerRadius = 5
        signupBtn.borderColor = UIColor.init(named: "app_blue")
        signupBtn.clipsToBounds = true
        submitBtn.cornerRadius = 8
        
        // Setting fields spacings and paddings
        forgotPasswordBtn.addTextSpacing(2.0)
        emailTF.setLeftPaddingPoints(25)
        passwordTF.setLeftPaddingPoints(25)
        selectSpecialistTF.setLeftPaddingPoints(25)
        
        self.hideKeyboardWhenTappedAround()
        
        if (userTypeId == 3){
            usertypeLabel.text = "Customer"
        }
        else if (userTypeId == 2){
            usertypeLabel.text = "Dealer"
        }
        else {
            usertypeLabel.text = "Specialist"
        }
    }
}


extension LoginViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func setPickerView(){
        let specialist = UIPickerView()
        specialist.delegate = self
        //catPicker.backgroundColor = UIColor.init(n)
        specialist.setValue(UIColor.black, forKeyPath: "textColor")
        //catPicker.showsSelectionIndicator = true
        selectSpecialistTF.inputView = specialist
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(named: "bgDark")
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //selectCategoryTextField.inputView = catPicker
        selectSpecialistTF.inputAccessoryView = toolBar
        
    }
    @objc func donePicker() {
        selectSpecialistTF.resignFirstResponder()
        if (selectSpecialistTF.text?.isEmpty)! {
            selectSpecialistTF.text = self.types.first
            categoryTypeId = 4
        }
        
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectSpecialistTF.text = types[row]
       self.categoryTypeId = typesId[row]
    }
}
