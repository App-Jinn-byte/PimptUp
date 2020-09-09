//
//  FIndSpecialistsModel.swift
//  PimptUp
//
//  Created by JanAhmad on 04/06/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation

struct FindSpecialistsModelResponse: Codable{
    let specialists: [list]
}
struct list: Codable{
    let CompanyNames: String?
    let ImagePath: String?
    let SpecialistCategoryNames: String?
    let UserId: Int?
    let UserName: String?
}
