//
//  APIResponse.swift
//  PimptUp
//
//  Created by JanAhmad on 21/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//
import Foundation
import UIKit
import Alamofire

class APIResponse {
    
    public static func isValidResponse(viewController: UIViewController,response: Any?, error: Error?, renderError: Bool = false,dismissLoading: Bool = true) -> Bool {
        
        var isValidResponse = false
        var message = ""
        
        //   print(response)
        
        if dismissLoading {
            
        }
        if error != nil {
            message = "Constants.GenericError"
            
        } else {
            if response != nil {
                isValidResponse = true
            }
        }
        
        if !isValidResponse && message.count > 0 && renderError {
            //            ViewControllerUtil.showAlertView(viewController: viewController, title: "Wait", message: message, successTitle: "OK")
        }
        
        return isValidResponse
    }
    public static func isValidResponse1(response: Any?, error: Error?, renderError: Bool = false,dismissLoading: Bool = true) -> Bool {
        
        var isValidResponse = false
        var message = ""
        
        //   print(response)
        
        if dismissLoading {
            
        }
        if error != nil {
            message = "Constants.GenericError"
            
        } else {
            if response != nil {
                isValidResponse = true
            }
        }
        
        if !isValidResponse && message.count > 0 && renderError {
            //            ViewControllerUtil.showAlertView(viewController: viewController, title: "Wait", message: message, successTitle: "OK")
        }
        
        return isValidResponse
    }
}
