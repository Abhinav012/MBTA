/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Member : Codable {
	var senderid : String?
	var name : String?
	var email : String?
	var mobile1 : String?
	var mobile2 : String?
	var resi_add : String?
	var photo : String?
	var designation : String?
	var post : String?

	enum CodingKeys: String, CodingKey {

		case senderid = "senderid"
		case name = "name"
		case email = "email"
		case mobile1 = "mobile1"
		case mobile2 = "mobile2"
		case resi_add = "resi_add"
		case photo = "photo"
		case designation = "designation"
		case post = "post"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		senderid = try values.decodeIfPresent(String.self, forKey: .senderid)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		mobile1 = try values.decodeIfPresent(String.self, forKey: .mobile1)
		mobile2 = try values.decodeIfPresent(String.self, forKey: .mobile2)
		resi_add = try values.decodeIfPresent(String.self, forKey: .resi_add)
		photo = try values.decodeIfPresent(String.self, forKey: .photo)
		designation = try values.decodeIfPresent(String.self, forKey: .designation)
		post = try values.decodeIfPresent(String.self, forKey: .post)
	}

}