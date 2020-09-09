//
//  DealersTyresModel.swift
//  PimptUp
//
//  Created by JanAhmad on 17/07/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct DealerTyresModelResponse: Codable{
    let TyresModels: [DealerTyresList]
}
struct DealerTyresList: Codable {
    let ProductId: Int?
    let Name:String?
    let Price:Double?
    let Description: String?
    let ImagePath: String?
    let TyreRange:String?
    let RimSize: String?
    let TyreWidth: String?
    let AspectRatio: String?
    let manufacturer: String?
    let UserName: String?
}
