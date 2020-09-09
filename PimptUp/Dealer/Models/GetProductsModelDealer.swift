//
//  GetProductsModelDealer.swift
//  PimptUp
//
//  Created by JanAhmad on 16/07/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetAllProductsDealerCategory: Codable{
    let productListByCategoryDealerModel: [ProductsListDealer]
}
struct ProductsListDealer: Codable {
    let ProductId: Int?
    let Name:String?
    let Price:Double?
    let Description:String?
    let Year: Double?
    let PartNumber:String?
    let CategoryId:Int?
    let VehicleTypeId:Int?
    let ProductTypeId: Int?
    let BrandId: Int?
    let ImagePath: String?
    let Category: String?
    let VehicleType: String?
    let ProductType: String?
    let Brand: String?
    let LocationName: String?
    let UserName: String?
    let DealerImage: String?
    
}
