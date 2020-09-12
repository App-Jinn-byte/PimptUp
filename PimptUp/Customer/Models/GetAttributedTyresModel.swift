//
//  GetAttributedTyresModel.swift
//  PimptUp
//
//  Created by JanAhmad on 06/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetTyresWithAttributesResponse: Codable{
    let TyresList: [TyreList]
}
struct TyreList: Codable {
    let TyreAttributeId: Int?
    let TyreRange: String?
    let RimSize: String?
    let ImagePath: String?
    let TyreWidth: String?
    let AspectRatio: String?
    let manufacturer: String?
    let Name: String?
    let Description: String?
    let Price: Double?
}
