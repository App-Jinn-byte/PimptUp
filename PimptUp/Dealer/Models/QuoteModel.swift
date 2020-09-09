//
//  QuoteModel.swift
//  PimptUp
//
//  Created by JanAhmad on 10/08/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct QuoteRequestResponse: Codable {
    let RequestQuoteId: Int?
    let RequestId:String?
    let Quote:Double?
    let QoutedBy:String?
}
