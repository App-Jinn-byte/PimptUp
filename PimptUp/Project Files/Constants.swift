//
//  Constants.swift
//  PimptUp
//
//  Created by JanAhmad on 21/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
import UIKit
import Photos

class Constants{
    public static var userTypeId = 0
    public static var userName = ""
    public static var userEmail = ""
    public static var userId = 0
    public static var catId = 0
    public static var partTypeId = 0
    public static var userProfile = ""
    public static var statusCode = 0
    public static var statusMessage = ""
    public static var loginErrorMessage = "Invalid username or password!"
    public static var forgotPasswordErrorMessage = "Invalid username"
    public static var blogimage = URL(string: "")
    
    //public static var ImagePath  = "https://pimptup.com/"
    
    public static var ImagePath  = "http://testtasvir.jinnbytedev.com/"
    
    public static var cars: [Vehicles] = []
    
    public static func Alert(title:String,message:String,controller:UIViewController){
        let alert = UIAlertController.init(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    public static func Alert(title:String,message:String,controller:UIViewController, action: @escaping (UIAlertAction) -> ()){
        let alert = UIAlertController.init(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: action))
        controller.present(alert, animated: true, completion: nil)
    }
    public static func Alert1(title:String,message:String,controller:UIViewController, action: @escaping (UIAlertAction) -> ()){
        let alert = UIAlertController.init(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: action))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: { (action) in
            
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    public static func getUserVehicles(){
        APIRequests.getVehicles(completion: APIRequestCompletedForUserVehicles)
    }
    
    public static func APIRequestCompletedForUserVehicles(response:Any?,error:Error?){
        
        if APIResponse.isValidResponse1(response: response, error: error){
            
            let decoder = JSONDecoder()
            do {
                
                let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                print(data)
                print(data,"PRinting the data here.")
                
                var vehicles = try decoder.decode(GetUserVehiclesModelResponse.self, from: data)
                let cars = vehicles.vehicles
                self.cars = cars
                
            }
            catch {
                print("error trying to convert data to JSON")
            }
        }
        else{
          print("else clause")
        }
    }
}
extension UIViewController{
    func checkPhotoPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            // present(myPickerController, animated: true, completion: nil)
            print("Access is granted by user")
        
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
}
