//
//  FtProductsModel.swift
//  PimptUp
//
//  Created by JanAhmad on 18/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetFtProductsModelResponse: Codable{
    let products: [FtProducts]
}
struct FtProducts: Codable {
    let ProductId: Int?
    let Name:String?
    let Description:String?
    let Price:Double
    let ProductImages: [ImageArrays]
}
struct ImageArrays:Codable {
    let ProductImageId: Int
    let ImagePath: String?
}
