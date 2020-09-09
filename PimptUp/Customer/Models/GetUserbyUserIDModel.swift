//
//  GetUserbyUserIDModel.swift
//  PimptUp
//
//  Created by JanAhmad on 02/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetUserModelResponse: Codable{
    let UserName: String?
    let Email: String?
    let Mobile: String?
    let LocationName: String?
    let Latitude: Double
    let Longitude: Double
    let ImagePath: String?
    let Password: String?
    let DeviceId:  String?
    let UserId: Int?
    let UserTypeId: Int?
    let PartsTypeId: Int?
    let UserCategories: [categories]?
    let UserCompanies: [companies1]?
}

struct categories: Codable
{
    let CategoryId: Int?
    let Description: String?
}
struct companies1: Codable
{
    let CompanyId: Int?
    let Description: String?
}
