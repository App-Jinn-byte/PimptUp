//
//  ProductsModel.swift
//  PimptUp
//
//  Created by JanAhmad on 08/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetProductsModelResponse: Codable {
    let ProductId: Int?
    let Name:String?
    let Description:String?
    let Price:Double
    let UserName: String?
    let ImagePath:String?
    let Category:String?
    let CategoryId:Int
    let Brand: String?
    let ModelDescription:String?
    let ManuFactureDescription: String?
    let TyreSizeDescription: String?
    let TyreAspectRationDescription: String?
    let TyrewidthDescription: String?
    let Mobile: String?
    let LocationName: String?
    
}
