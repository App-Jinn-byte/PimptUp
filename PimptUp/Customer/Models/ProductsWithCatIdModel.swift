//
//  ProductsWithCatIdModel.swift
//  PimptUp
//
//  Created by JanAhmad on 08/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetAllProductsWithCatId: Codable{
    let productsList: [ProductsList]
}
struct ProductsList: Codable {
    let ProductId: Int?
    let Name:String?
    let Description:String?
    let Price:Double
    let UserName: String?
    let ImagePath:String?
    let Category:String?
    let CategoryId:Int
    let Brand: String?
    let ProductType: String?
    let ModelDescription: String?
    let Mobile: String?
    let ManuFactureDescription: String?
    let TyreSizeDescription: String?
    let TyreAspectRationDescription: String?
    let TyrewidthDescription: String?
    let LocationName: String?
    
}
