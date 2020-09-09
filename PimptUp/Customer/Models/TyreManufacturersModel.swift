//
//  TyreManufacturersModel.swift
//  PimptUp
//
//  Created by JanAhmad on 06/06/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation

struct TyreManufacturersModelResponse: Codable {
    let manufacturers: [Manu]
}
struct Manu: Codable{
    let ManufacturerId: Int
    let Description: String?
}
