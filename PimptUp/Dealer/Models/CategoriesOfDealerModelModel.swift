//
//  CategoriesOfDealerModelModel.swift
//  PimptUp
//
//  Created by JanAhmad on 09/07/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetCategoriesOfDealer: Codable{
    let categoriesList: [DCategories]
}
struct DCategories: Codable {
    let CategoryId: Int?
    let Name:String?
    let Image:String?
    let Products: [String]?
    let TyreAttributes:[String]?
    
}
