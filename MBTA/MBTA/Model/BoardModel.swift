// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let boardModel = try? newJSONDecoder().decode(BoardModel.self, from: jsonData)

import Foundation

// MARK: - BoardModel
struct BoardModel: Codable {
    let board: Board
    let success: String
}

// MARK: - Board
struct Board: Codable {
    let patron, president, vicePresident, generalSecretary: [DharamkataIncharge]
    let jointSecretary, treasurer, honourablePanch, executiveMember: [DharamkataIncharge]
    let dharamkataIncharge, mediaIncharge: [DharamkataIncharge]

    enum CodingKeys: String, CodingKey {
        case patron = "Patron"
        case president = "President"
        case vicePresident = "Vice President"
        case generalSecretary = "General Secretary"
        case jointSecretary = "Joint Secretary"
        case treasurer = "Treasurer"
        case honourablePanch = "Honourable Panch"
        case executiveMember = "Executive Member"
        case dharamkataIncharge = "Dharamkata Incharge"
        case mediaIncharge = "Media Incharge"
    }
}

// MARK: - DharamkataIncharge
struct DharamkataIncharge: Codable {
    let memberid, name, mobile1, mobile2: String
    let email, resiAdd, photo: String
    let designation: Designation
    let post, fName: String

    enum CodingKeys: String, CodingKey {
        case memberid, name, mobile1, mobile2, email
        case resiAdd = "resi_add"
        case photo, designation, post
        case fName = "f_name"
    }
}

enum Designation: String, Codable {
    case director = "Director"
    case partner = "Partner"
    case prop = "Prop."
    case proprietor = "Proprietor"
}

