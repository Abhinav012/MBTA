//
//  ProfileModel.swift
//  MBTA
//
//  Created by Ravi on 23/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import Foundation

struct ProfileModel : Codable {

        let firm : FirmProfile?
        let member : [Member]?
        let success : String?

        enum CodingKeys: String, CodingKey {
                case firm = "firm"
                case member = "member"
                case success = "success"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
            firm = try? values.decodeIfPresent(FirmProfile.self, forKey: .firm)
                member = try values.decodeIfPresent([Member].self, forKey: .member)
                success = try values.decodeIfPresent(String.self, forKey: .success)
        }

}

struct FirmProfile : Codable {
    
    var member_id : String?
    var f_name : String?
    var f_add : String?
    var f_logo : String?
    var f_url : String?
    var bazar : String?
    var nature : String?

    enum CodingKeys: String, CodingKey {

        case member_id = "member_id"
        case f_name = "f_name"
        case f_add = "f_add"
        case f_logo = "f_logo"
        case f_url = "f_url"
        case bazar = "bazar"
        case nature = "nature"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        member_id = try values.decodeIfPresent(String.self, forKey: .member_id)
        f_name = try values.decodeIfPresent(String.self, forKey: .f_name)
        f_add = try values.decodeIfPresent(String.self, forKey: .f_add)
        f_logo = try values.decodeIfPresent(String.self, forKey: .f_logo)
        f_url = try values.decodeIfPresent(String.self, forKey: .f_url)
        bazar = try values.decodeIfPresent(String.self, forKey: .bazar)
        nature = try values.decodeIfPresent(String.self, forKey: .nature)
    }

}
