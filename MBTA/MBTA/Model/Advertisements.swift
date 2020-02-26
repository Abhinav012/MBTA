//
//  Advertisements.swift
//  MBTA
//
//  Created by Abhinav Verma on 19/02/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import Foundation

struct Advertisements: Codable {
    let data: [String: [Datum]]
    let success: String
}

// MARK: - Datum
struct Datum: Codable {
    let id: String
    let sliderImage: SliderImage
    let fullImage: FullImage
    let year, startMonth, endMonth: String
    let videoLink: String
    let priority, isImage: String
    let createdDate: CreatedDate

    enum CodingKeys: String, CodingKey {
        case id
        case sliderImage = "slider_image"
        case fullImage = "full_image"
        case year
        case startMonth = "start_month"
        case endMonth = "end_month"
        case videoLink = "video_link"
        case priority
        case isImage = "is_image"
        case createdDate = "created_date"
    }
}

enum CreatedDate: String, Codable {
    case the20190911055837 = "2019-09-11 05:58:37"
    case the20191114120501 = "2019-11-14 12:05:01"
}

enum FullImage: String, Codable {
    case adImg5Dcd42Ed19A7BPNG = "ad_img/5dcd42ed19a7b.png"
    case adImgTechive1PNG = "ad_img/techive-1.png"
}

enum SliderImage: String, Codable {
    case adImg5Dcd42Ed19A5EPNG = "ad_img/5dcd42ed19a5e.png"
    case adImgTechivePNG = "ad_img/techive.png"
}
