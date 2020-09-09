//
//  AddCarModel.swift
//  PimptUp
//
//  Created by JanAhmad on 01/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct AddCarModelResponse: Codable{
    let UserVehicleId: Int?
    let UserId: Int?
    let BrandId: Int?
    let ModelId: Int?
    //let ThumbNail: String
    // let ToShow: String?
    let VehicleImage: String?
    // let CreatedDate: String?
}
