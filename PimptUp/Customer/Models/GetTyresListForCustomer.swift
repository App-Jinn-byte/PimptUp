//
//  GetTyresListForCustomer.swift
//  PimptUp
//
//  Created by ahmad khan on 10/09/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetTyresListForCustomer: Codable{
    let TyreList: [TyreListCustomer]
}
struct TyreListCustomer: Codable {
    let TyreAttributeId: Int
//    let TyreRange: String?
//    let RimSize: String?
//    let ImagePath: String?
//    let TyreWidth: String?
//    let AspectRatio: String?
//    let manufacturer: String?
//    let CreatedByName: String?
//    let Name: String?
//    let Description: String?
//    let Price: Double?
}
