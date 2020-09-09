//
//  TyresAttributesModel.swift
//  PimptUp
//
//  Created by JanAhmad on 06/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct GetTyreAttributesResponse: Codable{
    let tyreAttributes: [Ranges]
}

struct Ranges: Codable {
    let TyreRange: Int
    let Description: String?
    let tyreSizes: [Sizes]
}
struct Sizes: Codable{
    let TyreSizeId: Int
    let Descriptions: String?
    let tyreWidths: [Width]
}
struct Width: Codable {
    let TyreWidthId: Int
    let Description: String?
    let tyreAspectRatios: [AspectRatio]
}
struct AspectRatio: Codable {
    let TyreAspectRatioId: Int
    let Description: String?
}

//    let manufacturers: [Manufacturers]
//    let ranges: [Ranges]
//    let widths: [Widths]
//    let aspectratio: [AspectRatio]
//    let sizes: [Sizes]
//}
//struct Manufacturers: Codable{
//    let Description: String?
//    let Id: Int
//}
//struct Ranges: Codable{
//    let Description: String?
//    let Id: Int
//}
//struct Widths: Codable{
//    let Description: String?
//    let Id: Int
//}
//struct AspectRatio: Codable{
//    let Description: String?
//    let Id: Int
//}
//struct Sizes: Codable{
//    let Description: String?
//    let Id: Int
