//
//  PostAPartViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 09/07/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import Photos
import Alamofire

class PostAPartViewController: UIViewController {
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var partNoTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var selectCategoryTF: UITextField!
    @IBOutlet weak var selectYearTF: UITextField!
    @IBOutlet weak var selectBrandTF: UITextField!
    @IBOutlet weak var selectModelTF: UITextField!
    @IBOutlet weak var selectAspectRatioTF: UITextField!
    @IBOutlet weak var selectTyreWidthTF: UITextField!
    
    
    @IBOutlet weak var aspectRatioContainer: UIView!
    @IBOutlet weak var imgViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputFieldsContainer: UIView!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var partIV: UIImageView!
    @IBOutlet weak var attachBtn: UIButton!
    
    var isTyre = false
    
    var categoriesArray: [CatList]?
    var catArray: [String] = []
    var catIdArray:[Int] = []
    var catId : Int?
    
    let categories = UIPickerView()
    
    // for picker views all categories other than tyre
    var brand: [Models] = []
    var model: [Model] = []
    var carModelId: Int?
    var carBrandId: Int?
    
    let brandPicker = UIPickerView()
    let modelPicker = UIPickerView()
    let datePicker = UIPickerView()
    var yearsArray: [String] = []
    
    //for apis objects (picker views) for tyres objects
    var tyreManufacturers: [Manu] = []
    var widths: [Width] = []
    var aspectRatio: [AspectRatio] = []
    var sizes: [Sizes] = []
    var ranges: [Ranges] = []
    var manufacturerId: Int?
    var widthId: Int?
    var aspectRatioId: Int?
    var rimSizeId: Int?
    var rangeId: Int?
    
    let manufacturerPV = UIPickerView()
    let aspectRatioPV = UIPickerView()
    let rimSizePV = UIPickerView()
    let tyreRangePV = UIPickerView()
    let widthPV = UIPickerView()
    
    // for images
    var imageData: Data?
    var isImageAttached  = false
    var imageUploadCode: Int?
    var partTypeId: Int?
    var defaults = UserDefaults.standard
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        partTypeId = defaults.integer(forKey: "UserTypeId")
        self.inputFieldsContainer.isHidden = true
        self.aspectRatioContainer.isHidden = true
        self.imgViewTopConstraint.constant = 20
        submitBtn.layer.cornerRadius = submitBtn.frame.height/5
        submitBtn.clipsToBounds = true
        
        getCategories()
        setPickerView()
        clearFields()
    }
    
    
    @IBAction func addImageFunction(_ sender: Any) {
        checkPermission()
        
    }
    
    @IBAction func postApart(_ sender: Any) {
        addPart()
    }
    
    func addPart(){
        
        let partName = nameTF.text
        let description = descriptionTF.text
        let partNo = partNoTF.text
        let price = priceTF.text
        let partType = isTyre
        
        if isTyre == false {
            let year = selectYearTF.text
            let brand = selectBrandTF.text
            let model = selectModelTF.text
            
            if ( partName == "" || partNo == ""  || price == "" || description == "" || partNo == "" || year == "" || brand == "" || model == ""){
                Constants.Alert(title: "Input error ", message: "All fields are required for adding Part", controller: self)
                return
            }
            
            if isImageAttached == false {
                Constants.Alert(title: "Input error ", message: "Please Attach part image ", controller: self)
                return
            }
            
            let parameters: [String:Any] = [
                "Name":  partName!,
                "Description": description!,
                "PartNumber": partNo! ,
                "Price": price!,
                "ProductTypeId": partTypeId!,
                "Year": year!,
                "BrandId": carBrandId!,
                "CategoryId": catId! ,
                "ModelId": carModelId!,
                "CreatedBy": Constants.userId
                
            ]
            
            if Reachability.isConnectedToInternet(){
                activityIndicator.startAnimating()
                print(parameters)
                APIRequests.postApart(parameters: parameters, completion: APIRequestCompletedForPostaPart)
            }
            else {
                print("Internet connection not available")
                
                Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
            }
        }
            
        else{
            
            let manufacturer = selectYearTF.text
            let ranges = selectBrandTF.text
            let rimSize = selectModelTF.text
            let width = selectTyreWidthTF.text
            let aspectRatio = selectAspectRatioTF.text
            
            if ( partName == "" || partNo == "" || price == "" || description == "" || partNo == "" || manufacturer == "" || ranges == "" || rimSize == "" || width == "" || aspectRatio == ""){
                Constants.Alert(title: "Input error ", message: "All fields are required for adding Tyre", controller: self)
                return
            }
            
            if isImageAttached == false {
                Constants.Alert(title: "Input error ", message: "Please Attach part image ", controller: self)
                return
            }
            
            let parameters: [String:Any] = [
                "ManufacturerId":  manufacturerId!,
                "TyreSizeId": rimSizeId!,
                "TyreRange": rangeId! ,
                "TyreWidthId": widthId!,
                "TyreAspectRatioId": aspectRatioId!,
                "CategoryId": catId!,
                "Name": partName!,
                "Description": description! ,
                "CreatedBy": Constants.userId,
                "Price": price!
                
            ]
            
            if Reachability.isConnectedToInternet(){
                activityIndicator.startAnimating()
                print(parameters)
                APIRequests.addNewTyre(parameters: parameters, completion: APIRequestCompletedForPostaPart)
            }
            else {
                print("Internet connection not available")
                
                Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
            }
        }
        
        
    }
    
    func getCategories(){
        if Reachability.isConnectedToInternet(){
            // activityIndicator.startAnimating()
            
            APIRequests.getCategories( completion: APIRequestCompletedForCategories)
            APIRequests.getCarMakeModel(completion: APIRequestCompletedForCars)
            APIRequests.getTyresManufacturers(completion: APIRequestCompletedForGetTyresManufacturers)
            APIRequests.getTyreAttributes(completion: APIRequestCompletedForGetTyreAttributes)
            for i in 1950...2020{
                yearsArray.append("\(i)")
            }
            print(yearsArray)
        }
            
            
            
            
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
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
    
    fileprivate func APIRequestCompletedForCategories(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let categories = try decoder.decode(GetAllCategoriesResponse.self, from: data)
                categoriesArray = categories.categories
                for cat in categoriesArray!{
                    let name = cat.Name
                    catArray.append(name!)
                    
                }
                
                
                for id in categoriesArray!{
                    let catId = id.CategoryId
                    catIdArray.append(catId!)
                    
                }
                
                
                //    activityIndicator.stopAnimating()
            } catch {
                //    activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage , controller: self)
            }
            
        }
        else{
            Constants.Alert(title: "API Error", message: Constants.loginErrorMessage, controller: self)
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
                
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Login Error", message: Constants.statusMessage ?? "", controller: self)
            }
        }
        else{
            
            Constants.Alert(title: "CarsApi Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    fileprivate func APIRequestCompletedForGetTyresManufacturers(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let manufacturers = try decoder.decode(TyreManufacturersModelResponse.self, from: data)
                self.tyreManufacturers = manufacturers.manufacturers
                print(tyreManufacturers)
                //                manufacturer = tyresAttribution!.manufacturers
                //                sizes = tyresAttribution!.sizes
                //                ranges = tyresAttribution!.ranges
                //                aspectRatio = tyresAttribution!.aspectratio
                //                widths = tyresAttribution!.widths
                
                setPickerView()
            } catch {
                
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage , controller: self)
            }
            
        }
        else{
            
            Constants.Alert(title: "API Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    fileprivate func APIRequestCompletedForGetTyreAttributes(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let attributes = try decoder.decode(GetTyreAttributesResponse.self, from: data)
                ranges = attributes.tyreAttributes
                print(ranges)
                //                manufacturer = tyresAttribution!.manufacturers
                
                //                for size in ranges {
                //                    sizes = sizes + size.tyreSizes
                //                }
                //                for width in sizes{
                //                    widths = widths +  width.tyreWidths
                //                }
                //                for aspect in widths{
                //                 aspectRatio = aspectRatio + aspect.tyreAspectRatios
                //                }
                
                setPickerView()
            } catch {
                
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage , controller: self)
            }
            
        }
        else{
            
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
    }
    
    fileprivate func APIRequestCompletedForPostaPart(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            
            
            //    let data = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response!, options: .prettyPrinted)
                
                print(data,"PRinting the data here.")
                
                let response = try decoder.decode(PostAPartModel.self, from: data)
                print(response)
                imageUploadCode = response.Code
                
                addImage()
                //     Constants.Alert(title: "Request Generated", message: "You request has been sent to all dealers ", controller: self, action: handler())
                
                
                
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

extension PostAPartViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func setPickerView(){
        selectYearTF.text = ""
        selectBrandTF.text = ""
        selectModelTF.text = ""
        
        if (isTyre == false){
            categories.delegate = self
            brandPicker.delegate = self
            modelPicker.delegate = self
            datePicker.delegate = self
            
            selectCategoryTF.inputView = categories
            selectBrandTF.inputView = brandPicker
            selectModelTF.inputView = modelPicker
            selectYearTF.inputView = datePicker
        }
        else{
            manufacturerPV.delegate = self
            rimSizePV.delegate = self
            aspectRatioPV.delegate = self
            widthPV.delegate = self
            tyreRangePV.delegate = self
            
            selectYearTF.inputView = manufacturerPV
            selectModelTF.inputView = rimSizePV
            selectBrandTF.inputView = tyreRangePV
            selectAspectRatioTF.inputView = aspectRatioPV
            selectTyreWidthTF.inputView = widthPV
        }
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(named: "bgDark")
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelButton))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //selectCategoryTextField.inputView = catPicker
        selectCategoryTF.inputAccessoryView = toolBar
        selectBrandTF.inputAccessoryView = toolBar
        selectModelTF.inputAccessoryView = toolBar
        selectTyreWidthTF.inputAccessoryView = toolBar
        selectAspectRatioTF.inputAccessoryView = toolBar
        
    }
    @objc func cancelButton(){
          view.endEditing(true)
      }
    @objc func donePicker() {
        
        if ( selectCategoryTF.resignFirstResponder()){
            if (selectCategoryTF.text!.isEmpty) {
                selectCategoryTF.text = self.catArray.first
                catId = self.catIdArray.first
                isTyres()
            }
            isTyres()
        }
        if (isTyre == false ){
            if ( selectBrandTF.resignFirstResponder()){
                if (selectBrandTF.text!.isEmpty) {
                    selectBrandTF.text = self.brand[0].Name
                    self.model = self.brand[0].models
                    carBrandId = self.brand[0].BrandId
                    
                }
            }
            else if ( selectModelTF.resignFirstResponder()){
                if (selectModelTF.text!.isEmpty) {
                    selectModelTF.text = self.model[0].Name
                    carModelId = self.model[0].ModelId
                }
            }
        }
        else {
            if (selectYearTF.resignFirstResponder()){
                if (selectYearTF.text?.isEmpty)! {
                    selectYearTF.text = self.tyreManufacturers[0].Description
                    manufacturerId = self.tyreManufacturers[0].ManufacturerId
                }
            }
            else if (selectBrandTF.resignFirstResponder()){
                if (selectBrandTF.text?.isEmpty)! {
                    selectBrandTF.text = self.ranges[0].Description
                    rangeId = self.ranges[0].TyreRange
                }
            }
            if (selectModelTF.resignFirstResponder()){
                if (selectModelTF.text?.isEmpty)! {
                    selectModelTF.text = self.sizes[0].Descriptions
                    rimSizeId = self.sizes[0].TyreSizeId
                }
            }
            if (selectTyreWidthTF.resignFirstResponder()){
                if (selectTyreWidthTF.text?.isEmpty)! {
                    selectTyreWidthTF.text = self.widths[0].Description
                    widthId = self.widths[0].TyreWidthId
                }
            }
            if (selectAspectRatioTF.resignFirstResponder()){
                if (selectAspectRatioTF.text?.isEmpty)! {
                    selectAspectRatioTF.text = self.aspectRatio[0].Description
                    aspectRatioId = self.aspectRatio[0].TyreAspectRatioId
                }
            }
        }
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == categories){
            return catArray.count
        }
        else if (pickerView == brandPicker){
            return brand.count
        }
        else if (pickerView == modelPicker){
            return model.count
        }
        else if (pickerView == datePicker){
            return yearsArray.count
        }
        else if(pickerView == manufacturerPV){
            return tyreManufacturers.count
        }
        else if (pickerView == rimSizePV){
            return sizes.count
        }
        else if (pickerView == aspectRatioPV){
            return aspectRatio.count
        }
        else if (pickerView == tyreRangePV){
            return ranges.count
        }
        else if (pickerView == widthPV){
            return widths.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == categories){
            return catArray[row].description
        }
        else if (pickerView == brandPicker){
            return brand[row].Name
        }
        else if (pickerView == modelPicker){
            return model[row].Name
        }
        else if (pickerView == datePicker){
            return yearsArray[row]
        }
        else if(pickerView == manufacturerPV){
            return tyreManufacturers[row].Description
        }
        else if (pickerView == rimSizePV){
           
            return sizes[row].Descriptions
        }
        else if (pickerView == aspectRatioPV){
            return aspectRatio[row].Description
        }
        else if (pickerView == tyreRangePV){
            
            return ranges[row].Description
            
        }
        else if (pickerView == widthPV){
            //            for _ in ranges{
            //                aspectRatio = widths[row].tyreAspectRatios
            //            }
            return widths[row].Description
        }
        return "hello"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == categories){
            selectCategoryTF.text = catArray[row].description
            catId = catIdArray[row]
            if selectCategoryTF.text == "Tyres"{
                isTyre = true
            }
            else{
                isTyre = false
            }
        }
        else if (pickerView == brandPicker){
            self.selectBrandTF.text = brand[row].Name
            carBrandId = self.brand[row].BrandId
            self.selectModelTF.text =  ""
            self.model = brand[row].models
            // print(model)
            
        }
        else if (pickerView == modelPicker){
            self.selectModelTF.text = model[row].Name
            carModelId = self.model[row].ModelId
        }
        else if (pickerView == datePicker){
            self.selectYearTF.text = yearsArray[row]
        }
        else if (pickerView == manufacturerPV){
            self.selectYearTF.text = tyreManufacturers[row].Description
            manufacturerId = tyreManufacturers[row].ManufacturerId
        }
        else if (pickerView == rimSizePV){
            self.selectModelTF.text = sizes[row].Descriptions
            rimSizeId = sizes[row].TyreSizeId
            for _ in ranges{
                widths = sizes[row].tyreWidths
            }
        }
        else if (pickerView == aspectRatioPV){
            self.selectAspectRatioTF.text = aspectRatio[row].Description
            aspectRatioId = aspectRatio[row].TyreAspectRatioId
        }
        else if (pickerView == tyreRangePV){
            self.selectBrandTF.text = ranges[row].Description
            rangeId = ranges[row].TyreRange
            for _ in ranges{
                sizes = ranges[row].tyreSizes
            }
        }
            
        else if (pickerView == widthPV){
            self.selectTyreWidthTF.text = widths[row].Description
            widthId = widths[row].TyreWidthId
            for _ in ranges{
                aspectRatio = widths[row].tyreAspectRatios
            }
        }
    }
    
    func isTyres(){
        if (isTyre == false){
            self.inputFieldsContainer.isHidden = false
            self.aspectRatioContainer.isHidden = true
            self.imgViewTopConstraint.constant = 240
            self.selectYearTF.attributedPlaceholder = NSAttributedString(string: "Select Year")
            self.selectBrandTF.attributedPlaceholder = NSAttributedString(string: "Select Brand")
            self.selectModelTF.attributedPlaceholder = NSAttributedString(string: "Select Model")
            
            setPickerView()
        }
        else{
            self.aspectRatioContainer.isHidden = false
            self.inputFieldsContainer.isHidden = false
            self.imgViewTopConstraint.constant = 336
            self.selectYearTF.attributedPlaceholder = NSAttributedString(string: "Select Manufacturer")
            self.selectBrandTF.attributedPlaceholder = NSAttributedString(string: "Select Tyre Ranges")
            self.selectModelTF.attributedPlaceholder = NSAttributedString(string: "Select Rim Size")
            
            setPickerView()
        }
    }
}

extension PostAPartViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Mark:- Did  Finish Func for image picker
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        
    {
        partIV.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        
        let image = partIV.image
        
        let data = image?.jpegData(compressionQuality: 0.9)
        imageData = data
        //let uiImage = UIImage(data: data! as Data)
        
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            
            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            print(photoURL)
        }
        
        isImageAttached = true
        attachBtn.alpha = 0.1
        self.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addImage(){
        let imgData = self.partIV.image?.jpegData(compressionQuality: 0.2)
        let url = "http://pimptup.jinnbytedev.com/api/Mobile/UploadPartImage"
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "image",fileName: "image.jpg", mimeType: "image/jpg")
            let parameters: [String:Any] = ["PartId": self.imageUploadCode! ]
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            } //Optional for extra parameters
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
                                self.activityIndicator.stopAnimating()
                                Constants.Alert(title: "Success", message: "Your Part has been added", controller: self, action: self.handler())
                                
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
    func handler() -> (UIAlertAction) -> () {
        return { action in
            self.clearFields()
        }
    }
    func clearFields(){
        self.nameTF.text = ""
        self.selectBrandTF.text = ""
        self.selectModelTF.text = ""
        self.priceTF.text = ""
        self.selectCategoryTF.text = ""
        self.descriptionTF.text = ""
        self.partNoTF.text = ""
        self.selectYearTF.text = ""
        self.selectAspectRatioTF.text  = ""
        self.selectTyreWidthTF.text = ""
        self.partIV.image = nil
        setPickerView()
    }
}
