//
//  AddCarViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 01/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import Kingfisher


class AddCarViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var carNameTF: UITextField!
    @IBOutlet weak var carBrandTF: UITextField!
    @IBOutlet weak var carModelTF: UITextField!
    @IBOutlet weak var carYearTF: UITextField!
    @IBOutlet weak var winNoTF: UITextField!
    @IBOutlet weak var carIV: UIImageView!
    
    @IBOutlet weak var submitBtn: UIButton!
    let brandPicker = UIPickerView()
    let modelPicker = UIPickerView()
    var isImageAttached = false
    var imageData: Data?
    var brand: [Models] = []
    var model: [Model] = []
    var carModelId: Int?
    var carBrandId: Int?
     let datePicker = UIPickerView()
    var editableCar: Vehicles?
    var yearsArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1950...2020{
            yearsArray.append("\(i)")
        }
        setPickerView()
        getCarMakeModel()
        print(editableCar)
        if (editableCar != nil) {
            setFields()
           // self.navigationController?.navigationBar.topItem?.title = "Edit Car"
            self.title = "Edit Car"
        }
    }
    
    func setFields(){
        carNameTF.text = editableCar?.VechileName
        carBrandTF.text  = editableCar?.BrandName
        carModelTF.text = editableCar?.ModelName
        carYearTF.text = editableCar?.Year
        winNoTF.text = editableCar?.VinNumber
        carModelId = editableCar?.ModelId
        carBrandId = editableCar?.BrandId
        if let image = editableCar?.ImagePath{
            
            var image1 = String(image.dropFirst(3))
            image1 = "\(Constants.ImagePath)"+image1
            let urlString = image1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let image = URL(string: urlString!)
            
            carIV.kf.setImage(with: image)
        }
        submitBtn.setTitle("Update", for: .normal)
    }
    func getCarMakeModel(){
        APIRequests.getCarMakeModel(completion: APIRequestCompletedForCars)
    }
    
    @IBAction func attachImage(_ sender: Any) {
        checkPermission()
    }
    @IBAction func submitAction(_ sender: Any) {
        
        if (editableCar == nil){
            addCar()
        }
        else{
               addCar()
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
}

extension AddCarViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func setPickerView(){
        
        
        brandPicker.delegate = self
        modelPicker.delegate = self
        datePicker.delegate = self
        //catPicker.backgroundColor = UIColor.init(n)
        
        //brandPicker.setValue(UIColor.black, forKeyPath: "textColor")
        brandPicker.showsSelectionIndicator = true
        carBrandTF.inputView = brandPicker
        carModelTF.inputView = modelPicker
        carYearTF.inputView = datePicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor.init(named: "bgDark")
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelButton))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //selectCategoryTextField.inputView = catPicker
        carBrandTF.inputAccessoryView = toolBar
        carModelTF.inputAccessoryView = toolBar
        carYearTF.inputAccessoryView = toolBar
    }
    @objc func cancelButton(){
        
        
        view.endEditing(true)
    }
    @objc func donePicker() {
        if (carBrandTF.resignFirstResponder()){
            if (carBrandTF.text?.isEmpty)! {
                carBrandTF.text = self.brand[0].Name
                carBrandId = self.brand[0].BrandId
                self.model = brand[0].models
            }
        }
        else if (carModelTF.resignFirstResponder()){
            if (carModelTF.text?.isEmpty)! {
                carModelTF.text = self.model[0].Name
                carModelId = self.model[0].ModelId
            }
        }
        else if (carYearTF.resignFirstResponder()){
            if (carYearTF.text?.isEmpty)! {
                carYearTF.text = yearsArray[0]
            }
        }

        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
        if (pickerView == brandPicker){
            self.carBrandTF.text = brand[row].Name
            carBrandId = brand[row].BrandId
            self.carModelTF.text =  ""
            self.model = brand[row].models
            // print(model)
            
        }
        else if (pickerView == modelPicker){
            self.carModelTF.text = model[row].Name
            self.carModelId = model[row].ModelId
        }
        else if (pickerView == datePicker){
            self.carYearTF.text = yearsArray[row]
        }
    }
}

extension AddCarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        
    {
        carIV.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let image = carIV.image
        let data = image?.jpegData(compressionQuality: 0.9)
        imageData = data
        let uiImage = UIImage(data: data! as Data)
        //print(data!)
        //print(data1!)
        //print(uiImage!)
        //var typeArray = getImageString(imageData: data1! as NSData)
        //print(typeArray)
        
        isImageAttached = true
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //    func uploadImage(userId: Int) {
    //
    //        let url = "http://pimptup.jinndevportal.com/api/Mobile/UploadUserImage?UserId=\(userId)"
    //        Alamofire.upload(multipartFormData: { multipartFormData in
    //            multipartFormData.append(self.imageData!, withName: "Data",fileName: "Data.jpg", mimeType: "Data/jpg")
    //            //            for (key, value) in parameters {
    //            //                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
    //            //            } //Optional for extra parameters
    //        },
    //                         to:url)
    //        { (result) in
    //            switch result {
    //            case .success(let upload, _,_ ):
    //
    //                upload.uploadProgress(closure: { (progress) in
    //                    print("Upload Progress: \(progress.fractionCompleted)")
    //                })
    //
    //                upload.responseJSON { response in
    //                    DispatchQueue.main.async {
    //                        do{
    //                            if response.result.error == nil {
    //                                //                                            print(response.result.value!)
    //                                guard let data = response.data else{return}
    //
    //                            }
    //                            else {
    //
    //                                debugPrint(response.result.error as Any)
    //                                // self.showMessageToUser(title: "Alert", msg: "wrong Detail")
    //                                print("errorr else section")
    //                            }
    //                        }catch let err{
    //                            debugPrint(err)
    //                            print("errorr catch seciton")
    //                        }
    //                    }
    //                }
    //
    //            case .failure(let encodingError):
    //                print(encodingError)
    //                print("errorr case fail seciton")
    //
    //            }
    //        }
    // Upload Data End
    
    func addCar() {
        
        let carYear = carYearTF.text
        let winNo = winNoTF.text
        let carName = carNameTF.text
        
        if(carBrandId == nil || carModelId == nil || carName  == "" || carYear == "" || winNo == "" ){
            Constants.Alert(title: "Input error ", message: "All fields are required", controller: self)
            return
        }
        if (isImageAttached == false){
            Constants.Alert(title: "Input error ", message: "Please attach image", controller: self)
            return
        }
        let imgData = self.carIV.image?.jpegData(compressionQuality: 0.2)
        let parameters : Parameters?
        let url : String?
        if (editableCar == nil){
             parameters = [
                "UserId":  Constants.userId,
                "BrandId": carBrandId! ,
                "ModelId":  carModelId!,
                "VinNo": winNo!,
                "VehicleName":carName! ,
                "UserVehicleYear": carYear!
            ]
             url = "http://pimptup.tasvir.pk/api/Mobile/AddUserVehicleWithImage"
        }
        else {
             parameters = [
                "UserId": Constants.userId,
                "UserVehicleId":editableCar!.UserVehicleId ,
                "BrandId": carBrandId!,
                "ModelId": carModelId!,
                "VinNo":  winNo!,
                "UpdatedBy": Constants.userId ,
                "UserVehicleYear":  carYear!,
                "VechileName": carName!
                
            ]
             url = "http://pimptup.tasvir.pk/api/Mobile/UpdateUserVehicleWithImage"
            
            activityIndicator.startAnimating()
        }
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "image",fileName: "image.jpg", mimeType: "image/jpg")
            for (key, value) in parameters! {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            } //Optional for extra parameters
        },
                         to:url!)
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
                                let obj = try JSONDecoder().decode(AddCarModelResponse.self, from: data)
                                print(obj)
                                self.activityIndicator.stopAnimating()
                                Constants.Alert(title: "Upload Complete", message: "Your Car has been added to your account", controller: self, action: self.handlerSuccess())
                                
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
        // Upload Data End
    }
    func handlerSuccess() -> (UIAlertAction) -> () {
        return { action in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
