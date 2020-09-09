//
//  GetSpecialistsCategoriesModel.swift
//  PimptUp
//
//  Created by JanAhmad on 30/03/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct SpecialistsCategoriesModel: Codable {
    let categorires:[specialist]
    
}
struct specialist: Codable{
    let SpecialistCategoryId: Int
    let Description: String?
    var isCheck = false
    
    enum CodingKeys: String, CodingKey {
        case SpecialistCategoryId
        case Description
    }
  
}
