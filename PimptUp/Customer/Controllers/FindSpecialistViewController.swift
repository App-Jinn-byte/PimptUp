//
//  FindSpecialistViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 17/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit

class FindSpecialistViewController: UIViewController {
    
    @IBOutlet weak var sliderValue: UISlider!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var specialistTypeTF: UITextField!
    @IBOutlet weak var findSpecialistTF: UITextField!
    @IBOutlet weak var rangeValueLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var specialistRadioBtn: UIButton!
    @IBOutlet weak var mechanicRadioBtn: UIButton!
    
    var lat: Double?
    var lng: Double?
    var isMechanic = true
    var userTypeId = 5
    var range = 50
    var companiesList:[companies] = []
    var companySelectedId = 0
    var specialistCategories:[specialist] = []
    var specialistSelectedId = 0
    var specialists:[list] = []
    
    
    let company = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCompanies()
        getCategories()
        setPickerView()
        submitBtn.isEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        submitBtn.isEnabled = true
    }
    
    @IBAction func mechanicRadioBtn(_ sender: Any) {
        if mechanicRadioBtn.backgroundImage(for: .normal) == UIImage.init(named: "btn_radio_empty"){
            mechanicRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_filled"), for: .normal)
            specialistRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
          self.findSpecialistTF.text = ""
          self.findSpecialistTF.attributedPlaceholder = NSAttributedString(string: "Select Company")
            isMechanic = true
            userTypeId = 5
            
        }
    }
    
    @IBAction func specialistRadfioBtn(_ sender: Any) {
        if specialistRadioBtn.backgroundImage(for: .normal) == UIImage.init(named: "btn_radio_empty"){
            specialistRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_filled"), for: .normal)
            mechanicRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
            isMechanic = false
            userTypeId = 4
            self.findSpecialistTF.text = ""
            self.findSpecialistTF.attributedPlaceholder = NSAttributedString(string: "Select Category")
        }
    }
    
    
    @IBAction func sliderAction(_ sender: UISlider) {
        self.rangeValueLabel.text = String(Int(sender.value))
    }
    @IBAction func addLocation(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Maps") as? MapsViewController
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func submitBtn(_ sender: Any) {
        

        if(findSpecialistTF.text == "" || locationTF.text == ""){
            Constants.Alert(title: "Input Error", message: "All Fields are Required", controller: self)
            return
        }
        print(specialistSelectedId)
        print(companySelectedId)
        print(self.rangeValueLabel.text)
        print(self.locationTF.text)
        print(lat)
        print(lng)
        print(self.userTypeId)
        let radius = self.rangeValueLabel.text
        let param:[String:Any] = ["userTypeId":userTypeId,"radius":radius!,"Latitude":lat!,"Longitude":lng! ,"CompanyId":companySelectedId ,"SpecialistCategoryId":specialistSelectedId]
        
        if Reachability.isConnectedToInternet(){
            
            APIRequests.FindSpecialists(parameters: param, completion: APIRequestCompletedForSpecialist)
            submitBtn.isEnabled = false
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
    }

}



extension FindSpecialistViewController: getLocaition{
    func onsetLocation(location: String, lat: Double, lng: Double) {
        
        self.locationTF.text = location
        self.lat = lat
        self.lng = lng
    }
}

extension FindSpecialistViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func getCompanies(){
        APIRequests.GetComapnies(completion: APIRequestCompletedForCompanies)
    }
    
    fileprivate func APIRequestCompletedForCompanies(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let companies = try decoder.decode(CompaniesModelResponse.self, from: data)
                print(companies)
               self.companiesList = companies.companyList
                print(companies)
                
            }
            catch {
                // activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Login Error", message: Constants.statusMessage ?? "", controller: self)
            }
        }
        else{
            
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    func getCategories(){
        APIRequests.GetSpecialists(completion: APIRequestCompletedForSpecialists)
    }
    fileprivate func APIRequestCompletedForSpecialists(response:Any?,error:Error?){

        if APIResponse.isValidResponse(viewController: self, response: response, error: error){

            let decoder = JSONDecoder()
            do {

                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")

                let specialist = try decoder.decode(SpecialistsCategoriesModel.self, from: data)
                print(specialist)
                self.specialistCategories = specialist.categorires
                print(specialistCategories)
            }
            catch {
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Login Error", message: Constants.statusMessage ?? "", controller: self)
            }
        }
        else{
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    func setPickerView(){
        
      
        company.delegate = self
       // specialistTypePicker.delegate = self
        //catPicker.backgroundColor = UIColor.init(n)
        //company.setValue(UIColor.black, forKeyPath: "textColor")
        //catPicker.showsSelectionIndicator = true
        findSpecialistTF.inputView = company
        
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
        findSpecialistTF.inputAccessoryView = toolBar
        
        
    }
    @objc func cancelButton(){
          view.endEditing(true)
      }
    @objc func donePicker() {
        if ( findSpecialistTF.resignFirstResponder()){
            if (findSpecialistTF.text!.isEmpty) {
                findSpecialistTF.text = self.companiesList[0].Description
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.isMechanic == true{
        return companiesList.count
        }
        else{
            return specialistCategories.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.isMechanic == true{
        return companiesList[row].Description
        }
        else{
            return specialistCategories[row].Description
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.isMechanic == true{
       companySelectedId = companiesList[row].CompanyId
        findSpecialistTF.text = companiesList[row].Description
        }
          else{
      specialistSelectedId = specialistCategories[row].SpecialistCategoryId
            findSpecialistTF.text = specialistCategories[row].Description
        }
    }
    fileprivate func APIRequestCompletedForSpecialist(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let companies = try decoder.decode(FindSpecialistsModelResponse.self, from: data)
                print(companies)
                
                let vc = UIStoryboard.init(name: "TabBar", bundle: Bundle.main).instantiateViewController(withIdentifier: "SpecialistList") as? SpecialistsListViewController
                vc?.obj = companies.specialists
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            catch {
                // activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage ?? "", controller: self)
            }
        }
        else{
            
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
}

