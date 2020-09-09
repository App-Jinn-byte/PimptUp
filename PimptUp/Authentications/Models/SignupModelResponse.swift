//
//  SignupModelResponse.swift
//  PimptUp
//
//  Created by JanAhmad on 27/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct RegisterationModelResponse: Codable {
    
    let UserId: Int
    let UserName: String
    let Email: String
    let Password: String
    let PhoneNumber: String?
    let Mobile: String?
    let CNIC: String?
    let LocationCord: String?
    let LocationName: String?
    let ImagePath: String?
    let DeviceId: String?
    let UserTypeId: Int
    //let CompanyId: Int?
    let PartTypeId: Int?
    let UserCategories: [Specialist]?
    let UserCompanies: [Mechanic]?
}

struct Specialist: Codable{
    let CategoryId: Int?
    let Description: String?
}

struct Mechanic: Codable{
    let CompanyId: Int?
    let Description: String?
}
