//
//  Price.swift
//  MBTA
//
//  Created by Abhinav Verma on 18/02/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import Foundation

struct Price: Codable{
    var goldMcx: String?
    var silverMcx: String?
    var inrMcx: String?
    var gMrt: String?
    var gHzr: String?
    var gJvr: String?
    var sMrt: String?
    var sHzr: String?
    
    enum CodingKeys: String, CodingKey{
        case goldMcx = "GOLD_MCX"
        case silverMcx = "SILVER_MCX"
        case inrMcx = "INR_MCX"
        case gMrt = "g_mrt"
        case gHzr = "g_hzr"
        case gJvr = "g_jvr"
        case sMrt = "s_mrt"
        case sHzr = "s_hzr"
    }
}
