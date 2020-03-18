//
//  LoginResponse.swift
//  MBTA
//
//  Created by Ravi on 16/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//


import Foundation

// MARK: - LoginData
struct LoginModel : Codable {
    let data : User?
    let login_type : String?
    let success : String?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case login_type = "login_type"
        case success = "success"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(User.self, forKey: .data)
        login_type = try values.decodeIfPresent(String.self, forKey: .login_type)
        success = try values.decodeIfPresent(String.self, forKey: .success)
    }

}
// MARK: - DataClass
struct User : Codable {
    let id : String?
    let member_id : String?
    let f_name : String?
    let f_add : String?
    let bazar : String?
    let f_logo : String?
    let f_url : String?
    let userid : String?
    let pwd : String?
    let login_type : String?
    let nature : String?
    let status : String?
    let create_date : String?
    let memberid : String?
    let name : String?
    let mobile1 : String?
    let mobile2 : String?
    let email : String?
    let address : String?
    let resi_add : String?
    let photo : String?
    let designation : String?
    let post : String?
    let member_notifiID : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case member_id = "member_id"
        case f_name = "f_name"
        case f_add = "f_add"
        case bazar = "bazar"
        case f_logo = "f_logo"
        case f_url = "f_url"
        case userid = "userid"
        case pwd = "pwd"
        case login_type = "login_type"
        case nature = "nature"
        case status = "status"
        case create_date = "create_date"
        case memberid = "memberid"
        case name = "name"
        case mobile1 = "mobile1"
        case mobile2 = "mobile2"
        case email = "email"
        case address = "address"
        case resi_add = "resi_add"
        case photo = "photo"
        case designation = "designation"
        case post = "post"
        case member_notifiID = "member_notifiID"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        member_id = try values.decodeIfPresent(String.self, forKey: .member_id)
        f_name = try values.decodeIfPresent(String.self, forKey: .f_name)
        f_add = try values.decodeIfPresent(String.self, forKey: .f_add)
        bazar = try values.decodeIfPresent(String.self, forKey: .bazar)
        f_logo = try values.decodeIfPresent(String.self, forKey: .f_logo)
        f_url = try values.decodeIfPresent(String.self, forKey: .f_url)
        userid = try values.decodeIfPresent(String.self, forKey: .userid)
        pwd = try values.decodeIfPresent(String.self, forKey: .pwd)
        login_type = try values.decodeIfPresent(String.self, forKey: .login_type)
        nature = try values.decodeIfPresent(String.self, forKey: .nature)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        create_date = try values.decodeIfPresent(String.self, forKey: .create_date)
        memberid = try values.decodeIfPresent(String.self, forKey: .memberid)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        mobile1 = try values.decodeIfPresent(String.self, forKey: .mobile1)
        mobile2 = try values.decodeIfPresent(String.self, forKey: .mobile2)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        resi_add = try values.decodeIfPresent(String.self, forKey: .resi_add)
        photo = try values.decodeIfPresent(String.self, forKey: .photo)
        designation = try values.decodeIfPresent(String.self, forKey: .designation)
        post = try values.decodeIfPresent(String.self, forKey: .post)
        member_notifiID = try values.decodeIfPresent(String.self, forKey: .member_notifiID)
    }

}
