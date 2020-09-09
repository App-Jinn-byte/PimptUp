//
//  LoginModel.swift
//  PimptUp
//
//  Created by JanAhmad on 23/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
import Alamofire


struct LoginModelResponse: Codable {
    
    let UserId: Int
    let UserName: String?
    let Email: String
    let Password: String
    let PhoneNumber: String?
    let Mobile: String?


    let LocationName: String?
    let ImagePath: String?
    let DeviceId: String?
    let UserTypeId: Int
//    let UserCompanies: [Int]?
//    let UserCategories: [Int]?
    let PartsTypeId: Int?
    
}
