//
//  GetUserVehiclesModel.swift
//  PimptUp
//
//  Created by JanAhmad on 01/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetUserVehiclesModelResponse: Codable{
    let vehicles: [Vehicles]
}
struct Vehicles: Codable{
    let BrandId: Int
    let ModelId: Int
    let BrandName: String
    let ModelName: String
    let ImagePath: String?
    let VechileName: String?
    let Year: String?
    let VinNumber: String?
    let UserVehicleId: Int
    
}
