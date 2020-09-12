//
//  RequestAPartViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 24/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import Photos
import Alamofire
class RequestAPartViewController: UIViewController {
    
    
    @IBOutlet weak var carNameTF: UITextField!
    @IBOutlet weak var brandTF: UITextField!
    @IBOutlet weak var modelTF: UITextField!
    @IBOutlet weak var winnoTF: UITextField!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var descriptionTF:UITextField!
    @IBOutlet weak var newRadioBtn: UIButton!
    @IBOutlet weak var oldRadioBtn: UIButton!
    @IBOutlet weak var bothRadioBtn: UIButton!
    @IBOutlet weak var partImageView: UIImageView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addCarBtn: UIButton!
    
    @IBOutlet weak var addCarView: UIView!
    var myVehicles: [Vehicles]?
    var partTypeId = 3
    var imageData: Data?
    var vehicleId: Int?
    var isImageAttached = false
    var imageUploadCode: Int?
    var userTypeId:  Int?
    var defaults = UserDefaults.standard
    
    var brand: [Models] = []
    var model: [Model] = []
    var carModelId: Int?
    var carBrandId: Int?
    var yearsArray: [String] = []
    
    let brandPicker = UIPickerView()
    let modelPicker = UIPickerView()
    let datePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Constants.userTypeId == 3){
            addCarBtn.layer.cornerRadius = addCarBtn.frame.height/5
            addCarBtn.clipsToBounds = true
        }
        userTypeId = defaults.integer(forKey: "UserTypeId")
        
        for i in 1950...2020{
            yearsArray.append("\(i)")
        }
        
        setUI()
        checkPhotoPermission()
        if userTypeId == 3 {
            Constants.getUserVehicles()
            if(Constants.cars.count != 0){
                self.addCarView.isHidden = true
                myVehicles = Constants.cars
            }
            else{
                self.addCarView.isHidden = false
            }
        }
        else {
            APIRequests.getCarMakeModel(completion: APIRequestCompletedForCars)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setPickerView()
        DispatchQueue.main.async {
            Constants.getUserVehicles()
        }
        if(userTypeId == 3){
            if(Constants.cars.count != 0){
                
                self.addCarView.isHidden = true
                myVehicles = Constants.cars
            }
            else{
                self.addCarView.isHidden = false
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if(userTypeId == 3){
            if(Constants.cars.count != 0){
                self.addCarView.isHidden = true
                myVehicles = Constants.cars
            }
            else{
                self.addCarView.isHidden = false
            }
        }
    }
    @IBAction func newRadioBtn(_ sender: Any) {
        if newRadioBtn.backgroundImage(for: .normal) == UIImage.init(named: "btn_radio_empty"){
            newRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_filled"), for: .normal)
            oldRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
            bothRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
            partTypeId = 1
            
        }
    }
    
    @IBAction func oldRadioBtn(_ sender: Any) {
        if oldRadioBtn.backgroundImage(for: .normal) == UIImage.init(named: "btn_radio_empty"){
            oldRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_filled"), for: .normal)
            newRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
            bothRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
            partTypeId = 2
            
        }
    }
    
    @IBAction func BothRadioBtn(_ sender: Any) {
        if bothRadioBtn.backgroundImage(for: .normal) == UIImage.init(named: "btn_radio_empty"){
            bothRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_filled"), for: .normal)
            oldRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
            newRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
            partTypeId = 3
            
        }
    }
    
    
    @IBAction func attachImageBtn(_ sender: Any) {
        checkPermission()
        
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            // present(myPickerController, animated: true, completion: nil)
            print("Access is granted by user")
            let myPickerController = UIImagePickerController()
            myPickerController.allowsEditing = true
            myPickerController.delegate = self;
            myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    //self.present(self.myPickerController, animated: true, completion: nil)
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
            Constants.Alert(title: "Permission Denied", message: "Please grant permission from settings to access photo library", controller: self)
        }
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        addPart()
        // :-> understanding request completion
        //        apirequest(completion: response)
        //        print("inside submitBtn")
        //        print(Constants.cars)
        //    }
        //    func apirequest (completion: @escaping completeIt){
        //        networkcall(completion: completion)
        //        print("inside api request")
        //    }
        //    func networkcall (completion: @escaping completeIt){
        //        print("inside network call")
        //    }
        //    func response (completion: String? ){
        //        print("inside response")
    }
    
    func setUI(){
        // Setting buttons and borders
        submitBtn.cornerRadius = 8
        
        // Setting fields spacings and paddings
        
        self.hideKeyboardWhenTappedAround()
        
    }
    func addPart(){
        let carName = carNameTF.text
        if(carName == "" || isImageAttached == false || self.yearTF.text == ""){
            Constants.Alert(title: "Input error ", message: "All fields are required", controller: self)
            return
        }
        
        let description = descriptionTF.text
        //let winNo = winnoTF.text
        //let carYear = yearTF.text
        //let carModel = modelTF.text
        //let imgData = self.partImageView.image?.jpegData(compressionQuality: 0.2)
        
        // Upload data Start
        var parameters: [String:Any] = [:]
        if (userTypeId == 3){
            parameters = [
                "Name":  carName!,
                "Description": description!,
                "ProductTypeId": 1 ,
                "CreatedBy": Constants.userId,
                "PartNumber": partTypeId,
                "UserVehcileId": vehicleId!,
                "UserVehicleYear": self.yearTF.text!
            ]
        }
        else {
            
            parameters = [
                "Name": carNameTF.text!,
                "Description": descriptionTF.text!,
                "ProductTypeId": partTypeId,
                "CreatedBy": Constants.userId,
                "VinNumber": winnoTF.text!,
                "VehicleName": brandTF.text!,
                "ModelId": carModelId!,
                "BrandId": carBrandId!,
                "Year": yearTF.text!,
                "UserId": Constants.userId,
                "UserVehicleYear": self.yearTF.text!
            ]
            
        }
        print(parameters)
        if Reachability.isConnectedToInternet(){
            activityIndicator.startAnimating()
            APIRequests.addPart(parameters: parameters, completion: APIRequestCompletedForAddPartsRequest)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
        
    }
    
    fileprivate func APIRequestCompletedForCars(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                var cars = try decoder.decode(CarMakeandModelResponse.self, from: data)
                print(cars)
                self.brand = cars.response
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
    
    fileprivate func APIRequestCompletedForAddPartsRequest(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let response = try decoder.decode(AddPartModelResponse.self, from: data)
                print(response)
                imageUploadCode = response.Code
                
                addImage()
                //     Constants.Alert(title: "Request Generated", message: "You request has been sent to all dealers ", controller: self, action: handler())
                
                
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
            if(self.userTypeId == 3){
            self.addCarView.isHidden = true
            }
        }
    }
}

extension RequestAPartViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func setPickerView(){
        
        if userTypeId == 3 && self.myVehicles?.count != 0{
            let car = UIPickerView()
            car.delegate = self
            car.showsSelectionIndicator = true
            carNameTF.inputView = car
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            //toolBar.tintColor = UIColor.init(named: "bgDark")
            toolBar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))
            
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            
            //selectCategoryTextField.inputView = catPicker
            carNameTF.inputAccessoryView = toolBar
        }
            
        else{
            
            datePicker.delegate = self
            brandPicker.delegate = self
            modelPicker.delegate = self
            brandPicker.showsSelectionIndicator = true
            brandTF.inputView = brandPicker
            modelTF.inputView = modelPicker
            yearTF.inputView = datePicker
            
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            //toolBar.tintColor = UIColor.init(named: "bgDark")
            toolBar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))
            
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            
            //selectCategoryTextField.inputView = catPicker
            brandTF.inputAccessoryView = toolBar
            brandTF.inputAccessoryView = toolBar
        }
        
    }
    @objc func cancelButton(){
        
        
        view.endEditing(true)
    }
    @objc func donePicker() {
        if userTypeId == 3 {
            carNameTF.resignFirstResponder()
            if carNameTF.text == ""{
                carNameTF.text = myVehicles?[0].VechileName
                brandTF.text = myVehicles?[0].BrandName
                modelTF.text = myVehicles?[0].ModelName
                winnoTF.text = myVehicles?[0].VinNumber
                yearTF.text = myVehicles?[0].Year
                vehicleId = myVehicles?[0].UserVehicleId
            }
            view.endEditing(true)
        }
        else {
            if (brandTF.resignFirstResponder()){
                if (brandTF.text?.isEmpty)! {
                    brandTF.text = self.brand[0].Name
                    carBrandId = self.brand[0].BrandId
                    self.model = brand[0].models
                }
            }
            else if (modelTF.resignFirstResponder()){
                if (modelTF.text?.isEmpty)! {
                    modelTF.text = self.model[0].Name
                    carModelId = self.model[0].ModelId
                }
            }
            else if (yearTF.resignFirstResponder()){
                if (yearTF.text?.isEmpty)! {
                    yearTF.text = self.yearsArray[0]
                }
            }
            view.endEditing(true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if userTypeId == 3 {
            return myVehicles!.count
        }
        if(pickerView == brandPicker){
            return brand.count
        }
        else if (pickerView == modelPicker){
            return model.count
        }
        else if (pickerView == datePicker){
            return yearsArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if userTypeId == 3{
            return myVehicles![row].VechileName
        }
        if (pickerView == brandPicker){
            return brand[row].Name
        }
        else if (pickerView == modelPicker){
            return model[row].Name
        }
        else if (pickerView == datePicker){
            return yearsArray[row]
        }
        return "hello"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (userTypeId == 3){
            self.carNameTF.text = myVehicles![row].VechileName
            self.brandTF.text = myVehicles![row].BrandName
            self.modelTF.text = myVehicles![row].ModelName
            self.yearTF.text = myVehicles![row].Year
            self.winnoTF.text = myVehicles![row].VinNumber
            vehicleId = myVehicles![row].UserVehicleId
        }
        if (pickerView == brandPicker){
            self.brandTF.text = brand[row].Name
            carBrandId = brand[row].BrandId
            self.modelTF.text =  ""
            self.model = brand[row].models
            // print(model)
            
        }
        else if (pickerView == modelPicker){
            self.modelTF.text = model[row].Name
            self.carModelId = model[row].ModelId
        }
        else if (pickerView == datePicker){
            self.yearTF.text = yearsArray[row]
            
        }
    }
}
extension RequestAPartViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        
    {
        partImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let image = partImageView.image
        let data = image?.jpegData(compressionQuality: 0.9)
        imageData = data
        
        isImageAttached = true
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addImage(){
        let imgData = self.partImageView.image?.jpegData(compressionQuality: 0.2)
        let url = "http://pimptup.jinnbytedev.com/api/Mobile/UploadPartRequestImage?RequestId=\(self.imageUploadCode!)"
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "image",fileName: "image.jpg", mimeType: "image/jpg")
            //            for (key, value) in parameters {
            //                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            //            } //Optional for extra parameters
        },
                         to:url)
        { (result) in
            switch result {
            case .success(let upload,_ ,_ ):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    DispatchQueue.main.async {
                        do{
                            if response.result.error == nil {
                                //                                            print(response.result.value!)
                                
                                guard let data = response.data else{return}
                                let obj = try JSONDecoder().decode(AddPartModelResponse.self, from: data)
                                print(obj)
                                Constants.Alert(title: "Request Generated", message: "Your Request has been sent to all Dealers", controller: self, action: self.handler())
                                
                            }
                            else {
                                
                                debugPrint(response.result.error as Any)
                                //  self.showMessageToUser(title: "Alert", msg: "wrong Detail")
                                print("errorr else section")
                            }
                        }catch let err{
                            debugPrint(err)
                            Constants.Alert(title: "Upload error", message: "\(err)", controller: self)
                            print("errorr catch seciton")
                        }
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                print("errorr case fail seciton")
                
            }
        }
    }
}
