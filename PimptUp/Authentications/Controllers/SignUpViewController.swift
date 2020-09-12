//
//  SignUpViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 20/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import Photos
import CoreLocation
import MapKit
import Alamofire
import FirebaseDatabase
import FirebaseAuth


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var radioBtnView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var attachPhotoConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitBtnTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var commonViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var categoryTF: UITextField!
    
    @IBOutlet weak var catTypeTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var newRadioBtn: UIButton!
    @IBOutlet weak var oldRadioBtn: UIButton!
    @IBOutlet weak var bothRadioBtn: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userTypeLabel: UILabel!
    
    @IBOutlet weak var categorySelectField: UIButton!
    var categoriesName = [String]()
    var categoriesId = [Int]()
    var catarray: [[String:Int]] = []
    
    var imageData: Data?
    var userTypeId: Int?
    var partTypeId = 2
    var companyId:Int?
    var lat:Double?
    var lng:Double?
    var mapAddress:String?
    
    var specialistType: [String] = ["Specialist", "Mechanic"]
    var newUserTypeId: [Int] = [4,5]
    
    let specialist = UIPickerView()
    let company = UIPickerView()
    let specialistTypePicker = UIPickerView()
    var companiesId:[companies] = []
    var catId: Int?
    var specialistTypeId: Int?
    
    var specialistTypes:[specialist] = []
    var locationManager = CLLocationManager()
    
    var ref:DatabaseReference!
    var id: Int?
    var name: String?
    var imagePaths: String?
    
    //var catPicker: UIPickerView?
    var isImageAttached: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.setFirebaseParam(notification:)), name: Notification.Name("callfirebaseFun"), object: nil)
        
        if(userTypeId == 4 ){
            commonViewTopConstraint.constant = 130
            attachPhotoConstraint.constant = 45
        }
        self.navigationController?.isNavigationBarHidden = true
        
        setUI()
        ref = Database.database().reference()
        setPickerView()
        print(userTypeId!)
        
        if userTypeId == 4{
            getCompanies()
            getSpecialists()
        }
    }
    
    @IBAction func selctCategoryBtn(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Category") as? SelectCategoriesViewController
        vc?.delegate = self
        vc!.usertype = self.userTypeId!
        
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        secondViewController.userTypeId = self.userTypeId
        self.navigationController?.pushViewController(secondViewController, animated: false)
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    @IBAction func newRadioBtn(_ sender: Any) {
        if newRadioBtn.backgroundImage(for: .normal) == UIImage.init(named: "btn_radio_empty"){
            newRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_filled"), for: .normal)
            oldRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
            bothRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
            partTypeId = 2
            
        }
    }
    
    @IBAction func oldRadioBtn(_ sender: Any) {
        if oldRadioBtn.backgroundImage(for: .normal) == UIImage.init(named: "btn_radio_empty"){
            oldRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_filled"), for: .normal)
            newRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
            bothRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
            partTypeId = 1
            
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
    
    
    @IBAction func attachPhotoBtn(_ sender: Any) {
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
    
    @IBAction func getLocation(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Maps") as? MapsViewController
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        
        let name = usernameTF.text
        let phone = phoneTF.text
        let location = locationTF.text!
        let email = emailTF.text
        let password1 = passwordTF.text
        let password2 = confirmPasswordTF.text
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        //    let companyID = companyId
        //    let speciaistTypeId = specialistTypeId
        let category = categoryTF.text
        if (category == "Mechanic"){
            userTypeId = 5
        }
        let latitude = self.lat
        let longitude = self.lng
        print(deviceId)
        let userType_Id = self.userTypeId
        
        if(userType_Id == 4){
            if(password1 == "" || password2 == "" || name == "" || location == "" || email == "" ||  catTypeTF.text == "" || categoryTF.text == ""){
                Constants.Alert(title: "ERROR", message: "All fields are required...", controller: self)
                return
            }
        }
        if(password1 == "" || password2 == "" || name == "" || location == "" || email == "" ){
            Constants.Alert(title: "ERROR", message: "All fields are required...", controller: self)
            return
        }
            
        else if !(email!.isValidEmail){
            Constants.Alert(title: "ERROR", message: "Invalid Email address...", controller: self)
            return
        }
        else if !(phone!.isValidPhone){
            Constants.Alert(title: "ERROR", message: "Phone format not correct. Plz enter 10 digit phone number...", controller: self)
            return
        }
            
        else if(password1 != password2){
            Constants.Alert(title: "ERROR", message: "Password is not matching...", controller: self)
            return
        }
        else if (self.catarray.count == 0 && userTypeId == 4){
            
            Constants.Alert(title: "Select Categories", message: "Please! Select Categories", controller: self)
            return
        }
        else if (isImageAttached == false){
            
            Constants.Alert(title: "Attach File", message: "Please! attach image..", controller: self)
            return
        }
        
        if Reachability.isConnectedToInternet(){
            var param:[String:Any] = [:]
            
            if(userTypeId == 3){
                param = ["UserName":name!,
                         "Email":email!,
                         "Password":password1!,
                         "Mobile":phone!,
                         "UserTypeId": userType_Id!,
                         "DeviceId":deviceId,
                         "Latitude":latitude!,
                         "Longitude":longitude!,
                         "LocationName":location ]
                print(param)
                //*         APIRequests.Registeration(parameters: param, completion: APIRequestCompleted)
            }
            else if(userTypeId == 2){
                param = ["UserName":name!,
                         "Email":email!,
                         "Password":password1!,
                         "Mobile":phone!,
                         "UserTypeId": userType_Id!,
                         "DeviceId":deviceId,
                         "PartsTypeId":partTypeId,
                         "Latitude":latitude!,
                         "Longitude":longitude!,
                         "LocationName":location]
                print(param)
                //*         APIRequests.Registeration(parameters: param, completion: APIRequestCompleted)
            }
            else if(userTypeId == 4){
                param = ["UserName":name!,
                         "Email":email!,
                         "Password":password1!,
                         "Mobile":phone!,
                         "UserTypeId": userType_Id!,
                         "DeviceId":deviceId,
                         "UserCategories":self.catarray,
                         "Latitude":latitude!,
                         "Longitude":longitude!,
                         "LocationName":location ]
                print(param)
                //*         APIRequests.Registeration(parameters: param, completion: APIRequestCompleted)
            }
                
            else if(userTypeId == 5){
                param = ["UserName":name!,
                         "Email":email!,
                         "Password":password1!,
                         "Mobile":phone!,
                         "UserTypeId": userType_Id!,
                         "DeviceId":deviceId,
                         "UserCompanies":self.catarray,
                         "Latitude":latitude!,
                         "Longitude":longitude!,
                         "LocationName":location ]
                print(param)
                //*         APIRequests.Registeration(parameters: param, completion: APIRequestCompleted)
            }
            
            
            activityIndicator.startAnimating()
            
            APIRequests.Registeration(parameters: param, completion: APIRequestCompleted)
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
                
                let registerationResponse = try decoder.decode(RegisterationModelResponse.self, from: data)
                print(registerationResponse.CNIC)
                print(registerationResponse.Email)
                print(registerationResponse.UserName)
                print(registerationResponse.UserId)
                
                
                
                self.id = registerationResponse.UserId
                self.name = registerationResponse.UserName
                self.imagePaths = registerationResponse.ImagePath
                
                uploadImage(userId: registerationResponse.UserId)
//                setFirebaseParam(userId: id! , userName: name! , imagePaths: imagePaths!)
                
//                repeat{
//                    print("no image path")
//                }while self.imagePaths == ""
//
                
                
               
                
            }
            catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage, controller: self)
            }
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Login Error", message: Constants.loginErrorMessage, controller: self)
        }
        
    }
    func setFirebaseParam(userId: Int, userName: String , imagePaths: String){
        self.ref.child("users").child("\(self.id!)").setValue([
            "id":"\(self.id!)",
            "name":"\(self.name!)",
            //"senderId":"2345",
            "profileImage":"\(imagePaths)"
        ])
    }
    func handlerSuccessAlert() -> (UIAlertAction) -> () {
        return { action in
            // self.performSegue(withIdentifier: "Reset", sender: nil)
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    
    func setUI(){
        // Setting buttons and borders
        signUpBtn.layer.cornerRadius = 5
        loginBtn.borderWidth = 1
        loginBtn.layer.cornerRadius = 5
        loginBtn.borderColor = UIColor.init(named: "app_blue")
        loginBtn.clipsToBounds = true
        submitBtn.cornerRadius = 8
        
        // Setting fields spacings and paddings
        
        emailTF.setLeftPaddingPoints(25)
        phoneTF.setLeftPaddingPoints(25)
        passwordTF.setLeftPaddingPoints(25)
        confirmPasswordTF.setLeftPaddingPoints(25)
        usernameTF.setLeftPaddingPoints(25)
        locationTF.setLeftPaddingPoints(25)
        categoryTF.setLeftPaddingPoints(25)
        catTypeTF.setLeftPaddingPoints(25)
        
        
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
        self.userImageView.clipsToBounds = true;
        
        self.hideKeyboardWhenTappedAround()
        
        //Mark:- setting label for user type
        if (userTypeId == 3){
            userTypeLabel.text = "Customer"
            categoryView.isHidden = true
            radioBtnView.isHidden = true
            attachPhotoConstraint.constant = 20
        }
        else if (userTypeId == 2){
            userTypeLabel.text = "Dealer"
            categoryView.isHidden = true
            attachPhotoConstraint.constant = 90
        }
        else {
            userTypeLabel.text = "Specialist"
            radioBtnView.isHidden = true
            
        }
        
        if isImageAttached == false{
            submitBtnTopConstraint.constant = 20
        }
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Mark:- Did  Finish Func for image picker
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        
    {
        userImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let image = userImageView.image
        //print(image)
        //let data = image0?.pngData()
        //print(data)
        let data = image?.jpegData(compressionQuality: 0.9)
        imageData = data
        let uiImage = UIImage(data: data! as Data)
        //print(data!)
        //print(data1!)
        //print(uiImage!)
        //var typeArray = getImageString(imageData: data1! as NSData)
        //print(typeArray)
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let fileName = imgUrl.absoluteString
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            let data = image.jpegData(compressionQuality: 1)
            //data!.write(toFile: localPath!)
            //let imageData = NSData(contentsOfFile: localPath!)!
            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            print(photoURL)
            // print(imgUrl)
            // print(imgName)
            let  myStringArr = imgName.components(separatedBy: ".")
            // print(myStringArr)
            // imageExtension = myStringArr[1]
            //print(imageExtension)
            
            // print(documentDirectory)
            //  print(localPath)
            //  print(image)
            //  print(data)
            
            var param:[String:Any] = [:]
            
            param = ["Data":data!]
            print(param)
            
            // APIRequests.imageUploading(imageData:data!, parameters: param, completion: APIRequestCompleted)
            
        }
        
        
        
        isImageAttached = true
        
        submitBtnTopConstraint.constant = 70
        self.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(userId: Int ) {
        
        let url = "http://pimptup.jinnbytedev.com/api/Mobile/UploadUserImage?UserId=\(userId)"
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(self.imageData!, withName: "Data",fileName: "Data.jpg", mimeType: "Data/jpg")
            //            for (key, value) in parameters {
            //                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            //            } //Optional for extra parameters
        },
                         to:url)
        { (result) in
            switch result {
            case .success(let upload, _,_ ):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    DispatchQueue.main.async {
                        do{
                            if response.result.error == nil {
                                //                                            print(response.result.value!)
                                guard let data = response.data else{return}
                                print(data,"data from multipart image upldaing//")
                                print("finished calling")
                                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                                let url = json["ImagePath"] as? String
                                let name = json["UserName"] as? String
                                
                                self.setFirebaseParam(userId: self.id! , userName: self.name! , imagePaths: url!)
                                           
                                               
                                Constants.Alert(title: "USER REGISTERED", message: "\(name!) Successfully Registered", controller: self, action: self.handlerSuccessAlert())
                            }
                            else {
                                
                                debugPrint(response.result.error as Any)
                                // self.showMessageToUser(title: "Alert", msg: "wrong Detail")
                                print("errorr else section")
                            }
                        }catch let err{
                            debugPrint(err)
                            print("errorr catch seciton")
                        }
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                print("errorr case fail seciton")
                
            }
        }
     print("in function end clause")
    }
    
}

//Mark:- Setting Picker view for category just for Specialist


extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func getCompanies(){
        APIRequests.GetComapnies(completion: APIRequestCompletedForComanies)
    }
    fileprivate func APIRequestCompletedForComanies(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let companies = try decoder.decode(CompaniesModelResponse.self, from: data)
                print(companies)
                companiesId = companies.companyList
                
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
    
    func getSpecialists(){
        APIRequests.GetSpecialists(completion: APIRequestCompletedForSpecialists)
    }
    fileprivate func APIRequestCompletedForSpecialists(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let companies = try decoder.decode(SpecialistsCategoriesModel.self, from: data)
                print(companies)
                specialistTypes = companies.categorires
                print(specialistTypes)
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
    func setPickerView(){
        
        // specialist.delegate = self
        // company.delegate = self
        specialistTypePicker.delegate = self
        //catPicker.backgroundColor = UIColor.init(n)
        //company.setValue(UIColor.black, forKeyPath: "textColor")
        //catPicker.showsSelectionIndicator = true
        // categoryTF.inputView = specialist
        categoryTF.inputView = specialistTypePicker
        
        
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
        categoryTF.inputAccessoryView = toolBar
        catTypeTF.inputAccessoryView = toolBar
        
    }
    @objc func cancelButton(){
        view.endEditing(true)
    }
    @objc func donePicker() {
        if ( categoryTF.resignFirstResponder()){
            if (categoryTF.text?.isEmpty)! {
                categoryTF.text = self.specialistType.first
                //catTypeTF.inputView = specialistTypePicker
                userTypeId = 4
            }
        }
        //        if ( catTypeTF.resignFirstResponder()){
        //            if (catTypeTF.text!.isEmpty && categoryTF.text == "Mechanic" ) {
        //                catTypeTF.text = self.companiesId[0].Description
        //                companyId = self.companiesId[0].CompanyId
        //
        //            }
        //            else if (catTypeTF.text!.isEmpty && categoryTF.text == "Specialist") {
        //                catTypeTF.text = self.specialistTypes[0].Description
        //                specialistTypeId = specialistTypes[0].SpecialistCategoryId
        //
        //            }
        //        }
        
        
        view.endEditing(true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == specialist{
            return specialistTypes.count
        }
        else if (pickerView == company) {
            return companiesId.count
        }
        else if (pickerView == specialistTypePicker){
            return specialistType.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == company{
            return companiesId[row].Description
        }
        else if( pickerView == specialist){
            return specialistTypes[row].Description
        }
            
        else if( pickerView == specialistTypePicker){
            // userTypeId = newUserTypeId[row]
            return specialistType[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        if pickerView == specialist{
        //            self.categoryTF.text = specialistType[row]
        //            catTypeTF.text = ""
        //            if (categoryTF.text == "Mechanic"){
        //                catTypeTF.inputView = company
        //
        //            }
        //            else {
        //                catTypeTF.inputView = specialistTypePicker
        //            }
        //        }
        //        else if (pickerView == company){
        //            self.catTypeTF.text = companiesId[row].Description
        //            self.companyId = companiesId[row].CompanyId
        //        }
        if (pickerView == specialistTypePicker){
            self.categoryTF.text = specialistType[row]
            if (specialistType[row] == "Mechanic"){
                catTypeTF.attributedPlaceholder = NSAttributedString(string: "Select Company",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            }
            else{
                catTypeTF.attributedPlaceholder = NSAttributedString(string: "Select Category",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                
            }
            //            self.specialistTypeId = specialistTypes[row].SpecialistCategoryId
            userTypeId = newUserTypeId[row]
        }
    }
    
}
extension SignUpViewController: CLLocationManagerDelegate{
    
    func setLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        //  locationTF.isUserInteractionEnabled = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        //*        map.setRegion(region, animated: true)
        //        self.map.showsUserLocation = true
        self.locationManager.stopUpdatingLocation()        // latitude = location.coordinate.latitude
        lng = location.coordinate.longitude
        lat = location.coordinate.latitude
        print(lng)
        print(lat)
        var mapAddress = ("\(lng)" + "\(lng)")
        
        
        //mark 1
        //        let geocoder = CLGeocoder()
        //        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
        //            if (error != nil){
        //                print("error in reverseGeocode")
        //            }
        //            let placemark = placemarks! as [CLPlacemark]
        //            if placemark.count>0{
        //                let placemark = placemarks![0]
        //                print(placemark.locality!)
        //                print(placemark.administrativeArea!)
        //                print(placemark.country!)
        //                print(placemark.location!)
        //                print(placemark.areasOfInterest)
        //                print(placemark.name!)
        //                print(placemark.description)
        //                print(placemark.postalCode)
        //                print(placemark.thoroughfare)
        //
        //
        //                self.mapAddress = "\(placemark.name!),\(placemark.postalCode ?? ""),\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
        //                print(self.mapAddress)
        //                self.locationTF.text = self.mapAddress
        //                self.locationTF.isUserInteractionEnabled = false
        //            }
        //        }
        
        //here you will get the core location
    }
}
extension SignUpViewController: getLocaition{
    func onsetLocation(location: String, lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
        self.locationTF.text = location
    }
    
}
extension SignUpViewController: categoriesProtocol{
    func sendName(catNames: [String]) {
        
        self.categoriesName = catNames
        self.catTypeTF.text = (categoriesName.joined(separator: ", " ))
    }
    
    func sendId(catId: [Int]) {
        self.categoriesId = catId
        print(categoriesId.count)
        for i in 0..<categoriesId.count{
            var contractorCategories: [String:Int] = [String:Int]()
            contractorCategories["CategoryId"] = categoriesId[i]
            catarray.append(contractorCategories)
        }
        print(catarray)
    }
    
}
