//
//  GetCategoriesModel.swift
//  PimptUp
//
//  Created by JanAhmad on 08/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetAllCategoriesResponse: Codable{
    let categories: [CatList]
}
struct CatList: Codable {
    let CategoryId: Int?
    let Name:String?
    let Image:String?
    let Products: [String]?
    let TyreAttributes:[String]?
   
}
