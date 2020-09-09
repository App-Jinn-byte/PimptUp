//
//  BlogsModel.swift
//  PimptUp
//
//  Created by JanAhmad on 25/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct BlogsModelResponse: Codable {
    
    let getblogList:[blogsList]
}

struct blogsList: Codable{
    let BlogId: Int
    let Title: String?
    let Description: String?
    let ImagePath: String?
    //let ThumbNail: String
   // let ToShow: String?
    let UserName: String?
   // let CreatedDate: String?
}
