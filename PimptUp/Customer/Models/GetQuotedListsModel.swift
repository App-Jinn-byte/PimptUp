//
//  GetQuotedListsModel.swift
//  PimptUp
//
//  Created by JanAhmad on 24/06/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetQuotesByUserIdDate: Codable{
    let quotedModelsList: [quotedList]
}
struct quotedList: Codable {
    let PartRequestId: Int?
    let Name: String?
    let UserVehicleYear: String?
    let BrandName: String?
    let ModelName: String?
    let ProductTypeName: String?
    let Description: String?
    let ImagePath: String?
    let Quote: Double?
}
