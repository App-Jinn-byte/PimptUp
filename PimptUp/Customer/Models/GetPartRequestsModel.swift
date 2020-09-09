//
//  GetPartRequestsModel.swift
//  PimptUp
//
//  Created by JanAhmad on 05/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetPartsRequestModelresponse: Codable{
    let partRequests: [PartsRequests]
}
struct PartsRequests: Codable{
    let PartRequestId: Int
    let Name: String?
    let ImagePath: String?
    let Description: String?
}
