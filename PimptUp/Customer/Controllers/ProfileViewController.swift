//
//  ProfileViewController.swift
//  PimptUp
//
//  Created by JanAhmad on 26/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import UIKit
import Photos
import Kingfisher
import Alamofire

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileUserImageView: UIImageView!
    @IBOutlet weak var addProfileImageBtn: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var myVehiclesTV: UITableView!
    @IBOutlet weak var addVehicleBtn: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var addressTF: UILabel!
    @IBOutlet weak var updateProfileBtn: UIButton!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var cnicTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoriesBgView: UIView!
    
    @IBOutlet weak var selectCategoriesBtn: UIButton!
    @IBOutlet weak var dealerBgView: UIView!
    @IBOutlet weak var newRadioBtn: UIButton!
    @IBOutlet weak var oldRadioBtn: UIButton!
    @IBOutlet weak var bothRadioBtn: UIButton!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var lng, lat : Double?
    var userDetail : GetUserModelResponse?
    var imageData: Data?
    var param:[String:Any] = [:]
    var deletedId: Int?
    var userVehicles: [Vehicles] = []
    var isImageAttached = false
    var partTypeId = 2
    var userTypeId: Int?
    let defaults = UserDefaults.standard
    var categoriesForSpecialist: [categories]?
    var categoriesForMechanic: [companies1]?
    var catsArray: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTypeId = defaults.integer(forKey: "UserTypeId")
        if (userTypeId == 2){
        addVehicleBtn.isHidden = true
//        newRadioBtn.isEnabled = false
//        bothRadioBtn.isEnabled = false
//        oldRadioBtn.isEnabled = false
        }
        setUI()
        if userTypeId == 3{
        
        getUserVehicles()
        addVehicleBtn.isHidden = false
            
        }
        if (userTypeId == 4 || userTypeId == 5){
            categoriesBgView.dropShadow()
            categoriesBgView.layer.cornerRadius = categoriesBgView.frame.width/20
        }
        userInteraction()
        getUserDetail()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        getUserVehicles()
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
    
    @IBAction func editProfile(_ sender: Any) {
        self.addressTF.isUserInteractionEnabled = true
        self.userNameTF.isUserInteractionEnabled = true
        
        addProfileImageBtn.isHidden = false
        updateProfileBtn.isHidden = false
        self.addressTF.textColor = .black
        self.userNameTF.textColor = .black
        if (userTypeId == 2){
//            newRadioBtn.isEnabled = true
//            bothRadioBtn.isEnabled = true
//            oldRadioBtn.isEnabled = true
        }
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        if isImageAttached == true{
        uploadImage()
        }
        updateProfileData()
    }
    @IBAction func attachPhotoBtn(_ sender: Any) {
        checkPermission()
    }
    func userInteraction(){
        self.addressTF.isUserInteractionEnabled = false
        self.userNameTF.isUserInteractionEnabled = false
        if (userTypeId == 4 || userTypeId == 5){
            self.categoriesLabel.textColor = .gray
        }
        self.phoneTF.textColor = .gray
        self.emailTF.textColor = .gray
        
        self.addressTF.textColor = .gray
        self.userNameTF.textColor = .gray
        updateProfileBtn.isHidden = true
        addProfileImageBtn.isHidden = true
        
    }
    
    @IBAction func getLocation(_ sender: Any) {
        print("hello")
        if (addressTF.isUserInteractionEnabled == true){
        print("hello")
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Maps") as? MapsViewController
            vc?.delegate = self
            self.navigationController?.pushViewController(vc!, animated: true)
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
    
    func uploadImage() {
        
        let url = "http://pimptup.tasvir.pk/api/Mobile/UploadUserImage?UserId=\(Constants.userId)"
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
        
    }
    
    func getUserDetail(){
        APIRequests.getUser(completion: APIRequestCompletedForUserDetail)
    }
    
    fileprivate func APIRequestCompletedForUserDetail(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let user = try decoder.decode(GetUserModelResponse.self, from: data)
                 userDetail = user
                self.userNameTF.text = userDetail?.UserName
                self.addressTF.text = userDetail?.LocationName
                self.phoneTF.text = userDetail?.Mobile
                self.emailTF.text = userDetail?.Email
                self.lat = userDetail?.Latitude
                self.lng = userDetail?.Longitude
                if (userTypeId == 2){
                    if (userDetail?.PartsTypeId == 3){
                        bothRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_filled"), for: .normal)
                        oldRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
                        newRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
                    }
                    else if (userDetail?.PartsTypeId == 1){
                        bothRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
                        oldRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_filled"), for: .normal)
                        newRadioBtn.setBackgroundImage(UIImage.init(named: "btn_radio_empty"), for: .normal)
                    }
                    
                }
                if let imagePath = userDetail?.ImagePath{
                    var imagePath = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    let url = URL(string: imagePath!)
                    self.profileUserImageView.kf.setImage(with: url)
                }
                categoriesForSpecialist = userDetail?.UserCategories
                categoriesForMechanic = userDetail?.UserCompanies
                if (userTypeId == 4 ){
                    
                    for category in categoriesForSpecialist!{
                        let cats = category.Description
                        catsArray.append(cats!)
                    }
                    self.categoriesLabel.text = catsArray.joined(separator: ", ")
                }
                else if (userTypeId == 5 ){
                    for category in categoriesForMechanic!{
                        let cats = category.Description
                        catsArray.append(cats!)
                    }
                     self.categoriesLabel.text = catsArray.joined(separator: ", ")
                }
               
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
    
    func updateProfileData(){
        let UserId = userDetail?.UserId
        let userTypeId = userDetail?.UserTypeId
        let name = self.userNameTF.text
        let phone = phoneTF.text
        let location = addressTF.text!
        let email = emailTF.text
        let password = userDetail?.Password
        let deviceId = userDetail?.DeviceId
    
        //    let companyID = companyId
        //    let speciaistTypeId = specialistTypeId
        let latitude = self.lat
        let longitude = self.lng
        print(deviceId)
        
        
            if(userNameTF.text == "" || phoneTF.text == "" || addressTF.text == "" || emailTF.text == ""){
                Constants.Alert(title: "ERROR", message: "All fields are required...", controller: self)
                return
            }
            
        else if !(email!.isValidEmail){
            Constants.Alert(title: "ERROR", message: "Invalid Email address...", controller: self)
            return
        }
      
        
        if Reachability.isConnectedToInternet(){
            var param:[String:Any] = [:]
            
            if(userTypeId == 3){
                param = ["UserId":UserId!,
                         "UserName":name!,
                         "Email":email!,
                         "Password":password!,
                         "Mobile": phone!,
                         "UserTypeId":userTypeId!,
                         "DeviceId":deviceId!,
                         "Latitude":lat!,
                         "Longitude":lng!,
                         "LocationName": location]
                print(param)
                //*         APIRequests.Registeration(parameters: param, completion: APIRequestCompleted)
            }
            else if(userTypeId == 2){
                param = ["UserId":UserId!,
                         "UserName":name!,
                         "Email":email!,
                         "Password":password!,
                         "Mobile": phone!,
                         "UserTypeId":userTypeId!,
                         "DeviceId":deviceId!,
                         "Latitude":lat!,
                         "Longitude":lng!,
                         "LocationName": location,
                         "PartsTypeId": Constants.partTypeId]
                
                print(param)
                //*         APIRequests.Registeration(parameters: param, completion: APIRequestCompleted)
            }
            
            
            activityIndicator.startAnimating()
            
            APIRequests.UpdateProfile(parameters: param, completion: APIRequestCompletedForUpdateUser)
        }
        else {
            print("Internet connection not available")
            
            Constants.Alert(title: "NO Internet Connection", message: "Please make sure You are connected to internet", controller: self)
        }
        
    }
    
    fileprivate func APIRequestCompletedForUpdateUser(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                let registerationResponse = try decoder.decode(RegisterationModelResponse.self, from: data)
               print(registerationResponse)
                
            if let imagePath = registerationResponse.ImagePath{
                let imagePath = imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: imagePath!)
                self.profileUserImageView.kf.setImage(with: url)
            }
                
                activityIndicator.stopAnimating()
                
                Constants.Alert(title: "Success", message: "\(registerationResponse.UserName) Successfully Updated", controller: self, action: handlerSuccessAlert())
                
            }
            catch {
                activityIndicator.stopAnimating()
                print("error trying to convert data to JSON")
                Constants.Alert(title: "Error", message: Constants.statusMessage, controller: self)
            }
        }
        else{
            activityIndicator.stopAnimating()
            Constants.Alert(title: "Update Error", message: "Error Uploading image and data", controller: self)
        }
        
    }

    
    func getUserVehicles(){
        APIRequests.getVehicles(completion: APIRequestCompletedForUserVehicles)
    }
    
    fileprivate func APIRequestCompletedForUserVehicles(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                var cars = try decoder.decode(GetUserVehiclesModelResponse.self, from: data)
                userVehicles = cars.vehicles
                userVehicles.reverse()
                self.myVehiclesTV.reloadData()
                
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
    
    func setUI(){
        self.bgView.layer.cornerRadius = 30
        self.bgView.clipsToBounds  = true
        // self.bgView.layer.shadowPath =
        // UIBezierPath(roundedRect: self.bgView.bounds,
        //            cornerRadius: self.bgView.layer.cornerRadius).cgPath
        self.bgView.layer.shadowColor = UIColor.gray.cgColor
        self.bgView.layer.shadowOpacity = 0.2
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.bgView.layer.shadowRadius = 6
        self.bgView.layer.masksToBounds = false
        
        profileUserImageView.layer.cornerRadius = profileUserImageView.frame.size.width / 2
        profileUserImageView.clipsToBounds = true
        
        if userTypeId == 3{
        addVehicleBtn.layer.cornerRadius = addVehicleBtn.frame.height/5
        addVehicleBtn.clipsToBounds = true
        }
        updateProfileBtn.layer.cornerRadius = updateProfileBtn.frame.height/5
        updateProfileBtn.clipsToBounds = true
    }
    
    func handlerSuccessAlert() -> (UIAlertAction) -> () {
        return { action in
            self.viewDidLoad()
        }
    }
}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Mark:- Did  Finish Func for image picker
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        
    {
        profileUserImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        
        let image = profileUserImageView.image
        
        let data = image?.jpegData(compressionQuality: 0.9)
        imageData = data
        let uiImage = UIImage(data: data! as Data)
        
        
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
        self.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (userTypeId == 2){
            return 0
        }
        return userVehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "VehiclesCell") as! MyVehiclesTableViewCell
        
        cell.brandLabel.text = userVehicles[indexPath.row].BrandName
        cell.modelLabel.text = userVehicles[indexPath.row].ModelName
        cell.winLabel.text = userVehicles[indexPath.row].VinNumber
        cell.yearLabel.text = userVehicles[indexPath.row].Year
        cell.nameLabel.text = userVehicles[indexPath.row].VechileName
        cell.cellData = userVehicles[indexPath.row]
        cell.delegate = self
        let carImage = userVehicles[indexPath.row].ImagePath
        // calling function to set image
        //let url = setImage1(image: carImage ?? "")
        let url = URL(string: carImage!)
        cell.carIV.kf.setImage(with: url)
        
        return cell
    }
    
    func setImage1(image: String) -> URL{
        print (image)
        var url1 = URL(string: "https://www.google.com/imgres?imgurl=https%3A%2F%2Fimages.unsplash.com%2Fphoto-1542362567-b07e54358753%3Fixlib%3Drb-1.2.1%26ixid%3DeyJhcHBfaWQiOjEyMDd9%26w%3D1000%26q%3D80&imgrefurl=https%3A%2F%2Funsplash.com%2Fs%2Fphotos%2Fsports-car&tbnid=xpvlqZHACra5RM&vet=12ahUKEwj8pfj1-YTqAhUBdBoKHZKrAE4QMygAegUIARDPAQ..i&docid=vOo16yb9F5G5bM&w=1000&h=667&q=car%20images&ved=2ahUKEwj8pfj1-YTqAhUBdBoKHZKrAE4QMygAegUIARDPAQ" )
        var imagePaths = String(image.dropFirst(3))
        
        imagePaths = imagePaths.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(imagePaths)
        if  let url = URL(string: imagePaths)  {
            print(url)
            url1 = url
            return(url)
        }
      return url1!
    }
}
extension ProfileViewController: deletecarDelegate{
    func editMyCar(carObj: Vehicles) {
        let vc = UIStoryboard.init(name: "TabBar", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddVehicle") as? AddCarViewController
        vc?.editableCar = carObj
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func deleteMyCar(id: Int , name: String) {
       Constants.Alert1(title: "Alert", message: "Are you sure to want to delete that car   \(name)", controller: self, action: handler())
        param = ["userVehicleId": id]
        deletedId = id
    }
    
   func handler() -> (UIAlertAction) -> () {
    return { action in
        
            APIRequests.deleteMyCar(deleteId: self.deletedId! ,parameters: self.param , completion: self.APIRequestCompletedForDeleteMyCar )
        
    }
}
    
    
    fileprivate func APIRequestCompletedForDeleteMyCar(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse(viewController: self, response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                var cars = try decoder.decode(DeleteVehicleModelResponse.self, from: data)
                let deletedCar = cars
                Constants.Alert(title: "Car Deleted", message: "Your car \(deletedCar.VechileName)  of Vin # \(deletedCar.VinNo!) has been deleted ", controller: self)
                getUserVehicles()
                
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
}

extension ProfileViewController: getLocaition{
    func onsetLocation(location: String, lat: Double, lng: Double) {
       
        self.addressTF.text = location
        self.lat = lat
        self.lng = lng
    }
}

