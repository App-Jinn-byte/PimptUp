//
//  BannersImagesModel.swift
//  PimptUp
//
//  Created by JanAhmad on 18/04/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
struct BannersImagesModelResponse: Codable {
    let bannersList: [BannersList]
}
struct BannersList: Codable {
    let HomePageBannersId: Int
    let ImagePath: String?
}
