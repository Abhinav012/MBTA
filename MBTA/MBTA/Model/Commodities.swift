//
//  Price.swift
//  MBTA
//
//  Created by Abhinav Verma on 18/02/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import Foundation

struct Commodities: Codable{
    var rows : [Commodity]?
}

struct Commodity: Codable{
    var symbol: String?
    var bid: String?
    var ask: String?
    var high: String?
    var low: String?
    var time: String?
    
    private enum CodingKeys: String,CodingKey{
        case symbol = "Symbol"
        case bid = "Bid"
        case ask = "Ask"
        case high = "High"
        case low = "Low"
        case time = "Time"
    }
}
