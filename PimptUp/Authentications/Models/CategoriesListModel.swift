//
//  CategoriesListModel.swift
//  PimptUp
//
//  Created by JanAhmad on 04/08/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct CategoriesListModelResponse: Codable {
    
    let CategoryId: Int
    let Name: String?
    //    let FeedBack: String?
    //    let IsApproved: Bool?
    //    let Status: String?z
    let Image: String
    //    let Icon: String?
    //    let IsActive: Bool?
    //    let CreatedDate: String?
    //    let CreatedBy: Int?
    //    let UpdatedDate: String?
    //    let UpdatedBy: Int?
    //    let ImageAd: String?
    //    let URL: String?
    var isCheck = false
    
    enum CodingKeys: String, CodingKey {
        case CategoryId
        case Name
        case Image
    }
}
