//
//  GetAllCompaniesNodel.swift
//  PimptUp
//
//  Created by JanAhmad on 27/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct CompaniesModelResponse: Codable {
    let companyList:[companies]
}
struct companies: Codable{
    let CompanyId: Int
    let Description: String?
    let ImagePath: String?
     var isCheck = false
    
    enum CodingKeys: String, CodingKey {
        case CompanyId
        case Description
        case ImagePath
    }
}
