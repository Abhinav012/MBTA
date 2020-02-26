//
//  APIManager.swift
//  MBTA
//
//  Created by Abhinav Verma on 18/02/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import Foundation
import UIKit

class APIManager{
    
    static let manager = APIManager()
    static var commodities = [Commodity]()
    static var price = Price()
    static var notices = Notice()
    static var ads = [Datum]()
    private init(){
        
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
    
    func parseCommoditiesData(data: Data?, success: Bool){
        if success{
            let decoder = JSONDecoder()
            do{
                let commodities = try decoder.decode(Commodities.self, from: data!)
                APIManager.commodities = commodities.rows ?? [Commodity]()
            }
            catch(let error){
                print(error.localizedDescription)
            }
            
        }
    }
    
     func parsePriceData(data: Data?, success: Bool){
        if success{
            let decoder = JSONDecoder()
            do{
                let price = try decoder.decode(Price.self, from: data!)
                APIManager.price = price
            }
            catch(let error){
                print(error.localizedDescription)
            }
            
        }
    }
   
    func parseNoticeData(data: Data?, success: Bool){
        if success{
            let decoder = JSONDecoder()
            do{
                let noticeboard = try decoder.decode(Noticeboard.self, from: data!)
                APIManager.notices = noticeboard.data!
            }
            catch(let error){
                print(error.localizedDescription)
            }
            
        }
    }
    
    func parseAdsData(data: Data?, success: Bool){
           if success{
               let decoder = JSONDecoder()
               do{
                   let ads = try decoder.decode(Advertisements.self, from: data!)
                   for value in ads.data.values{
                     APIManager.ads += value
                   }
                
               
               }
               catch(let error){
                   print(error.localizedDescription)
               }
               
           }
       }

    func fetchCommodities(completion: @escaping (Bool)->Void){
        fetchAPIData(urlString: commodityRateURL) { (data, success) in
            self.parseCommoditiesData(data: data, success: success)
            completion(success)
        }
    }
    
    func fetchPrices(completion: @escaping (Bool)->Void){
        fetchAPIData(urlString: baseURL+mrtRateUrl) { (data, success) in
            self.parsePriceData(data: data, success: success)
            completion(success)
        }
    }
    
    func fetchNotices(completion: @escaping (Bool)->Void){
        fetchAPIData(urlString: baseURL+noticeboardUrl) { (data, success) in
            self.parseNoticeData(data: data, success: success)
            completion(success)
        }
    }
    
    func fetchAds(completion: @escaping (Bool)->Void){
        fetchAPIData(urlString: baseURL+adsUrl) { (data, success) in
            self.parseAdsData(data: data, success: success)
            completion(success)
        }
    }
    
    func fetchData(completion: @escaping (Bool)->Void){
        fetchCommodities { (success) in
            if success{
                    self.fetchPrices { (success) in
                        if success{
                            self.fetchNotices { (success) in
                                if success{
                                    completion(true)
                                }
                            }
                        }
                   }
            }
        }
       
    }
    
}
