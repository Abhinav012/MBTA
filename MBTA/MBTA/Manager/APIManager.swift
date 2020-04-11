//
//  APIManager.swift
//  MBTA
//
//  Created by Abhinav Verma on 18/02/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

enum APIURLRequest: URLRequestConvertible {
    
    static let baseUrl = "https://www.techiveservices.com/Bullion_Association/Mbta/api/"

    case loginURL([String: Any])
    case fetchUserProfile([String: Any])
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .loginURL :
            return .post
        case .fetchUserProfile :
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .loginURL:
            return "login.php"
        case .fetchUserProfile:
            return "profile_details.php"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        var url = URL(string: APIURLRequest.baseUrl)!
        
        switch self {
        case .loginURL:
            url = url.appendingPathComponent(path)
        case .fetchUserProfile:
            url = url.appendingPathComponent(path)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .loginURL(let parameters):
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        case .fetchUserProfile(let parameters):
        return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
    

class APIManager{
    
    static let manager = APIManager()
    static var commodities = [Commodity]()
    static var price = Price()
    static var notices = Notice()
    static var ads = [Datum]()
    private init(){
        
    }
    
    static func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    func Login(userId : String, password: String, completion : @escaping (Bool, Error?) -> Void) {
        
        let params = ["userid": userId,"password": password]
        let url = URL (string: "https://www.techiveservices.com/Bullion_Association/Mbta/api/login.php")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = APIManager.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)
        
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    completion(false, error)
                    return
                }
                do {
                    guard let jsonData = data else {
                        completion(false, error)
                        return
                    }
                    let loginData = try JSONDecoder().decode(LoginModel.self, from: jsonData)
                    
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(loginData.data), forKey:"user@MBTA")
                    
                    UserDefaults.standard.set(true, forKey: "isAuthenticated")
                    UserDefaults.standard.synchronize()
                    completion(true, nil)
                    
                } catch {
                    completion(false, error)
                }
            }
            task.resume()
        }
        
    }
    
    func forgotPassword(by email : String, completion : @escaping (Bool, Error?) -> Void) {
        
        let params = ["email": email]
        let url = URL (string: "https://www.techiveservices.com/Bullion_Association/Mbta/api/forget_password.php")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = APIManager.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)
        
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    completion(false, error)
                    return
                }
                
                completion(true, nil)
            }
            task.resume()
        }
        
    }
    
    
    
    func getuserProfile(completion : @escaping (ProfileModel?, Error?) -> Void) {
        
        var id: String?
        
        if let data = UserDefaults.standard.value(forKey:"user@MBTA") as? Data {
            let user = try? PropertyListDecoder().decode(User.self, from: data)
            id = user?.userid
            
            let toRemove = "mbta"
            if let range = id?.range(of: toRemove) {
               id?.removeSubrange(range)
            }
        }
        
        guard let userId = id else {
            return
        }

        let params = ["memberid": userId]
        let url = URL (string: "https://www.techiveservices.com/Bullion_Association/Mbta/api/profile_details.php")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = APIManager.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)
        
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                do {
                    guard let jsonData = data else {
                        completion(nil, error)
                        return
                    }
                    
                    let profileData = try JSONDecoder().decode(ProfileModel.self, from: jsonData)
                    
                    completion(profileData, nil)
                    
                } catch {
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
    
    func addNewMember(for parametes: [String: Any], completion: @escaping (Bool, Error?) -> Void ) {
        
        let url = URL (string: "https://www.techiveservices.com/Bullion_Association/Mbta/api/add_member.php")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = APIManager.getPostString(params: parametes)
        request.httpBody = postString.data(using: .utf8)
        
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    completion(false, error)
                    return
                }
                
                completion(true, error)
            }
            task.resume()
        }
    }
    
    func updateFirm(for parametes: [String: Any], completion: @escaping (Bool, Error?) -> Void ) {
        
        let url = URL (string: "https://www.techiveservices.com/Bullion_Association/Mbta/api/firm_update.php")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = APIManager.getPostString(params: parametes)
        request.httpBody = postString.data(using: .utf8)
        
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    completion(false, error)
                    return
                }
                
                completion(true, error)
            }
            task.resume()
        }
    }
    
    func updateMember(for parametes: [String: Any], completion: @escaping (Bool, Error?) -> Void ) {
        
        let url = URL (string: "https://www.techiveservices.com/Bullion_Association/Mbta/api/update_member_profile.php")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = APIManager.getPostString(params: parametes)
        request.httpBody = postString.data(using: .utf8)
        
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    completion(false, error)
                    return
                }
                
                completion(true, error)
            }
            task.resume()
        }
    }
    
    func fetchDirectoryData(completion: @escaping (DirectoryData?, Error?) -> Void) {
        
        let url = URL(string: "https://www.techiveservices.com/Bullion_Association/Mbta/api/directory.php")
        
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error{
                completion( nil, error)
            } else {
                guard let jsonData = data else {
                    completion(nil, error)
                    return
                }
                do {
                    let directoryData = try JSONDecoder().decode(DirectoryData.self, from: jsonData)
                    
                    completion(directoryData, nil)
					
                } catch {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
    }
    
    func fetchBoardMember(completion: @escaping (BoardModel?,Error?)->Void) {
        
        let url = URL(string: "https://www.techiveservices.com/Bullion_Association/Mbta/api/board_members.php")
        
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error{
                completion( nil, error)
            } else {
                guard let jsonData = data else {
                    completion(nil, error)
                    return
                }
                do {
                    let directoryData = try JSONDecoder().decode(BoardModel.self, from: jsonData)
                    
                    completion(directoryData, nil)
                    
                } catch {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
    }
    
    func fetchAPIData(urlString: String, completion: @escaping (Data?,Bool)->Void){
        let url = URL(string: urlString)
        guard let validUrl = url else {return}
        
        let request = URLRequest(url: validUrl)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let _ = error{
                completion(nil,false)
            } else {
                completion(data,true)
            }
        }
        
        task.resume()
        
    }
    
    func parseCommoditiesData(data: Data?, completion: @escaping ([Commodity]?, Error?) -> Void ){
        guard let data = data else {
            completion(nil, nil)
            return
        }
        
        let decoder = JSONDecoder()
        do{
            let commodities = try decoder.decode(Commodities.self, from: data)
            completion(commodities.rows ?? [Commodity](), nil )
        }
        catch(let error){
            completion(nil, error)
        }
        
        
    }
    
    func parsePriceData(data: Data?, completion: @escaping (Price?, Error?) -> Void ){
        
        guard let data = data else {
            completion(nil, nil)
            return
        }
        
        let decoder = JSONDecoder()
        
        do{
            let price = try decoder.decode(Price.self, from: data)
            completion(price, nil)
        }
        catch(let error){
            completion(nil, error)
        }
    }
    
    func parseNoticeData(data: Data?, completion: @escaping (Notice?, Error?) -> Void ){
        guard let data = data else {
            completion(nil, nil)
            return
        }
        let decoder = JSONDecoder()
        do{
            let noticeboard = try decoder.decode(Noticeboard.self, from: data)
            completion (noticeboard.data!, nil)
        }
        catch(let error){
            completion(nil, error)
        }
    }
    
    func parseAdsData(data: Data?,  completion: @escaping ([Datum]?, Error?) -> Void ){
        
        guard let data = data else {
            completion(nil, nil)
            return
        }
        
        let decoder = JSONDecoder()
        do{
            let ads = try decoder.decode(Advertisements.self, from: data)
            for value in ads.data.values{
                completion (value, nil)
            }
        }
        catch(let error){
            completion(nil, error)
        }
        
    }
    
    func fetchCommodities(completion: @escaping ([Commodity]?, Error?) -> Void ){
        fetchAPIData(urlString: commodityRateURL) { (data, success) in
            self.parseCommoditiesData(data: data, completion: completion)
        }
    }
    
    func fetchPrices(completion: @escaping (Price?, Error?) -> Void){
        fetchAPIData(urlString: baseURL+mrtRateUrl) { (data, success) in
            self.parsePriceData(data: data,completion: completion)
        }
    }
    
    func fetchNotices(completion: @escaping (Notice?, Error?) -> Void){
        fetchAPIData(urlString: baseURL+noticeboardUrl) { (data, success) in
            self.parseNoticeData(data: data, completion: completion)
        }
    }
    
    func fetchAds( completion: @escaping ([Datum]?, Error?) -> Void){
        fetchAPIData(urlString: baseURL+adsUrl) { (data, success) in
            self.parseAdsData(data: data, completion: completion)
        }
    }
    
    
}
