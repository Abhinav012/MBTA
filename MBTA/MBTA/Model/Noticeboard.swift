//
//  Noticeboard.swift
//  MBTA
//
//  Created by Abhinav Verma on 18/02/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import Foundation

struct Noticeboard: Codable{
    var data : Notice?
    var success: String?
    
}

struct Notice: Codable{
    var id: String?
    var notice1 : String?
    var notice2 : String?
    var notice3 : String?
    var notice4 : String?
    var notice5 : String?
    var notice6 : String?
    var notice7 : String?
    var notice8 : String?
    var notice9 : String?
    var notice10 : String?
    var updatedDate: String?
    
    enum CodingKeys: String, CodingKey{
        case updatedDate = "updated_date"
        case id = "id"
        case notice1 = "notice1"
        case notice2 = "notice2"
        case notice3 = "notice3"
        case notice4 = "notice4"
        case notice5 = "notice5"
        case notice6 = "notice6"
        case notice7 = "notice7"
        case notice8 = "notice8"
        case notice9 = "notice9"
        case notice10 = "notice10"
    }
    
    func concatNotices()->String{
        return """
        \(notice1 ?? "")
        
        \(notice2 ?? "")
        
        \(notice3 ?? "")
        
        \(notice4 ?? "")
        
        \(notice5 ?? "")
        
        \(notice6 ?? "")
        
        \(notice7 ?? "")
        
        \(notice8 ?? "")
        
        \(notice9 ?? "")
        
        \(notice10 ?? "")
        """
    }
    
}
