//
//  ViewController.swift
//  MBTA
//
//  Created by Abhinav Verma on 16/02/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var scrollContentView: UITextView!
    @IBOutlet weak var rateTableView: UITableView!
    @IBOutlet weak var adsCollectionView: UICollectionView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var shouldScrollRightToLeft = true
    var shouldFireAdsTimer = true
    var indexPath = IndexPath(item: 1, section: 0)
    var item = 0
    var valForInterval: Float = 3.0
    var interval = TimeInterval(exactly: 3.0)
    var count = 0
    var timer = Timer()
    
    var commodities = [Commodity]()
    var price = Price()
    
    static var mcxGoldColor = UIColor.noChangeColor
    static var mcxSilverColor = UIColor.noChangeColor
    static var inrRateColor = UIColor.noChangeColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loader.startAnimating()
        
        APIManager.manager.fetchData { (success) in
            if success{
                
                APIManager.manager.fetchAds { (success) in
                    if success{
                        print(APIManager.ads.first?.sliderImage.rawValue)
                        DispatchQueue.main.async {
                            self.loader.stopAnimating()
                            self.loader.isHidden = true
                            self.commodities=APIManager.commodities
                            self.price = APIManager.price
                            self.rateTableView.reloadData()
                            self.scrollContentView.text = APIManager.notices.concatNotices()
                            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.updateRates), userInfo: nil, repeats: true)
                            
                            self.adsCollectionView.reloadData()
                            
                            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.switchAdvertisement), userInfo: nil, repeats: true)
                            
                            
                           
                        }
                    }
                    
                }
                
                
                
            }
        }
        
        
        
        
        
        
    }
    
    @objc func updateRates(){
        APIManager.manager.fetchCommodities { (success) in
            if success{
                
                if Int(self.commodities.first!.bid!) ?? 0 > Int(APIManager.commodities.first!.bid!) ?? 0 {
                    ViewController.self.mcxGoldColor = UIColor.lossColor
                }
                else if Int(self.commodities.first!.bid!) == Int(APIManager.commodities.first!.bid!){
                    ViewController.self.mcxGoldColor = UIColor.noChangeColor
                }
                else {
                    ViewController.self.mcxGoldColor = UIColor.gainColor
                }
                
                
                
                
                if Double(self.commodities.last!.bid!) ?? 0.0 > Double(APIManager.commodities.last!.bid!) ?? 0.0 {
                    ViewController.self.inrRateColor = UIColor.lossColor
                }
                else if Int(self.commodities.last!.bid!) ?? 0 == Int(APIManager.commodities.last!.bid!) ?? 0{
                    ViewController.self.inrRateColor = UIColor.noChangeColor
                }
                else {
                    ViewController.self.inrRateColor = UIColor.gainColor
                }
                
                
                
                
                if Int(self.commodities[1].bid!) ?? 0 > Int(APIManager.commodities[1].bid!) ?? 0{
                    ViewController.self.mcxSilverColor = UIColor.lossColor
                }
                else if Int(self.commodities[1].bid!) ?? 0  == Int(APIManager.commodities[1].bid!) ?? 0 {
                    ViewController.self.mcxSilverColor = UIColor.noChangeColor
                }
                else {
                    ViewController.self.mcxSilverColor = UIColor.gainColor
                }
                
                self.commodities = APIManager.commodities
                
                DispatchQueue.main.async {
                    self.rateTableView.reloadData()
                }
            }
            
        }
    }

    @objc func switchAdvertisement(){
       
        if shouldFireAdsTimer{
            shouldFireAdsTimer = false
         if item == 0{
                 shouldScrollRightToLeft = true
             }
             else if item == APIManager.ads.count-1{
                 shouldScrollRightToLeft = false
             }
             

             
             indexPath = IndexPath(item: item, section: 0)
             
             let priority = APIManager.ads[item].priority
             if priority == "1"{
                 
                     valForInterval+=8
                     interval = TimeInterval(valForInterval)
                   
             }else if priority == "2"{
                valForInterval+=5
                interval = TimeInterval(valForInterval)
             }
             else{
                 valForInterval+=3
                 interval = TimeInterval(valForInterval)
             }
             
            
             

             Timer.scheduledTimer(timeInterval: TimeInterval(self.valForInterval), target: self, selector: #selector(self.showAd), userInfo: nil, repeats: false)
         
            
        }
    }
    
    @objc func showAd(){
        shouldFireAdsTimer = true
        if shouldScrollRightToLeft {
            item += 1
            }
        else{
            item -= 1
        }
        
        DispatchQueue.main.async{
        self.adsCollectionView.scrollToItem(at: self.indexPath, at: .right, animated: true)
            print(self.indexPath.row)
        }
        
    }
    
}

 


extension UIViewController: UITableViewDataSource, UITableViewDelegate{
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceTableViewCell", for: indexPath) as! PriceTableViewCell
        cell.priceCollectionView.tag = indexPath.section+2
        cell.priceCollectionView.reloadData()
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
        return 5
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.5))
        footerView.backgroundColor = UIColor.white
        return footerView
    }
    
}

extension UIViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func updateAttributedString(str: String, subStr: String)-> NSAttributedString{

        let range = (str as NSString).range(of: subStr)
        
        let attributedString = NSMutableAttributedString(string: str)
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)], range: range)
        
        return attributedString
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1{
            return APIManager.ads.count
        }
        
        return APIManager.commodities.count-1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adsCollectionViewCell", for: indexPath) as! AdvertisementsCollectionViewCell
            cell.adsImageView.sd_setImage(with: URL(string: baseURL+APIManager.ads[indexPath.row].sliderImage.rawValue), completed: nil)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "priceCollectionViewCell", for: indexPath) as! PriceCollectionViewCell
        
        if indexPath.row == 0 && collectionView.tag == 2{
            cell.commodityLabel.text = "MCX Gold"
            cell.commodityValueLabel.text = APIManager.commodities.first?.bid
            cell.commodityValueLabel.backgroundColor = ViewController.mcxGoldColor
        }
        if indexPath.row == 1 && collectionView.tag == 2{
            cell.commodityLabel.attributedText = self.updateAttributedString(str: "MRT G-999 *GSTExtra", subStr: "*GSTExtra")
            cell.commodityValueLabel.text = APIManager.price.gMrt
        }
        if indexPath.row == 2 && collectionView.tag == 2{
            cell.commodityLabel.attributedText = self.updateAttributedString(str: "MRT G-HZR *GSTExtra", subStr: "*GSTExtra")
            cell.commodityValueLabel.text = APIManager.price.gHzr
        }
        
        if indexPath.row == 3 && collectionView.tag == 2{
                   cell.commodityLabel.attributedText = self.updateAttributedString(str: "MRT G-Jewar *GSTExtra", subStr: "*GSTExtra")
                   cell.commodityValueLabel.text = APIManager.price.gJvr
                   cell.commodityValueLabel.backgroundColor = UIColor.noChangeColor
               }
        
        if indexPath.row == 0 && collectionView.tag == 3{
            cell.commodityLabel.text = "MCX Silver"
            cell.commodityValueLabel.text = APIManager.commodities[1].bid
            cell.commodityValueLabel.backgroundColor = ViewController.mcxSilverColor
        }
        if indexPath.row == 1 && collectionView.tag == 3{
            cell.commodityLabel.attributedText = self.updateAttributedString(str: "MRT S-999 *GSTExtra", subStr: "*GSTExtra")
            cell.commodityValueLabel.text = APIManager.price.sMrt
        }
        if indexPath.row == 2 && collectionView.tag == 3{
            cell.commodityLabel.attributedText = self.updateAttributedString(str: "MRT S-HZR *GSTExtra", subStr: "*GSTExtra")
            cell.commodityValueLabel.text = APIManager.price.sHzr
        }
        
        if indexPath.row == 3 && collectionView.tag == 3{
            cell.commodityLabel.text = "USD(1$)"
            cell.commodityValueLabel.text = APIManager.commodities.last?.bid
            cell.commodityValueLabel.backgroundColor = ViewController.inrRateColor
               }
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1{
            return CGSize(width: self.view.frame.width, height: 212)
        }
        
        return CGSize(width: (self.view.frame.width-1.5)/4, height: 65)
    }
}

