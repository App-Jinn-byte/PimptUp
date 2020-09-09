//
//  QuotesListModel.swift
//  PimptUp
//
//  Created by JanAhmad on 05/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetQuotesByPartIdResponse: Codable{
    let Quotes: [quotesList]
}
struct quotesList: Codable {
    let RequetQuoteId: Int?
    let RequestId:Int?
    let DealerName:String?
    let QuotePrice: Double
    let DealerImagePath: String?
    let DealerID: Int?
}
