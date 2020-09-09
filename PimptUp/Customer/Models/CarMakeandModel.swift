//
//  CarMakeandModel.swift
//  PimptUp
//
//  Created by JanAhmad on 01/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct CarMakeandModelResponse: Codable{
    let response: [Models]
}
struct Models:Codable{
    let BrandId: Int?
    let Name: String?
    let models: [Model]
}
struct Model: Codable{
    let ModelId: Int?
    let Name: String?
}
