//
//  HomeController.swift
//  MBTA
//
//  Created by Abhinav Verma on 16/02/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import SDWebImage
import SideMenuSwift



class HomeController: UIViewController {
    
    @IBOutlet weak var BD_btn: UIButton!
	@IBOutlet var Top_Menubar: UIStackView!
	@IBOutlet var Bottom_Menubar: UIStackView!
	@IBOutlet var Bottom_SC: NSLayoutConstraint!
	
    @IBOutlet var Bottom_DrawerView: DrawerView!
    @IBOutlet weak var rateTableView: UITableView!
    @IBOutlet weak var adsCollectionView: UICollectionView!
    
    @IBOutlet weak var Middle_TextView: UITextView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var shouldScrollRightToLeft = true
    var shouldFireAdsTimer = true
    var indexPath = IndexPath(item: 1, section: 0)
    var item = 0
    var valForInterval: Float = 3.0
    var interval = TimeInterval(exactly: 3.0)
    var count = 0
    var timer = Timer()
    var ads = [Datum]()
    var commodities = [Commodity]()
    var price = Price()
    
    var flotingBtn = UIButton()
    
    static var mcxGoldColor = UIColor.noChangeColor
    static var mcxSilverColor = UIColor.noChangeColor
    static var inrRateColor = UIColor.noChangeColor
    
    var isAuthenticated =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "isAuthenticated") {
            self.isAuthenticated = true
        }
        
        self.setupSideMenu()
        setupFloatingButton()
        setupTabDrawerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		self.flotingBtn.alpha = 0
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        if isAuthenticated && self.Bottom_DrawerView.position != .partiallyOpen {
                self.flotingBtn.alpha = 1
            }
          navigationController?.navigationBar.isHidden = true
          fetchHomeData()
      }
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
      }
    
    func setupTabDrawerView() {
		self.Top_Menubar.alpha = 0
		self.Bottom_Menubar.alpha = 0
		
		var extraHeight: CGFloat = 10
		
		if let bottomSafeArea = SceneDelegate.shared?.window?.safeAreaInsets.bottom {
			extraHeight += bottomSafeArea
		}
		
		self.Bottom_SC.constant = extraHeight
    
        Bottom_DrawerView.attachTo(view: self.view)
        Bottom_DrawerView.snapPositions = [.collapsed, .partiallyOpen]
        Bottom_DrawerView.insetAdjustmentBehavior = .superviewSafeArea
        Bottom_DrawerView.delegate = self
        Bottom_DrawerView.position = .collapsed
		Bottom_DrawerView.collapsedHeight = 50
        Bottom_DrawerView.partiallyOpenHeight = isAuthenticated ? (200) : (120) 
        Bottom_DrawerView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.01568627451, blue: 0.01568627451, alpha: 1)
        Bottom_DrawerView.backgroundEffect = nil
    }
    
    private func setupSideMenu() {
        
        SideMenuController.preferences.basic.menuWidth = self.view.frame.width/1.3
        SideMenuController.preferences.basic.enablePanGesture = true
        SideMenuController.preferences.basic.supportedOrientations = .portrait
		
    }
    
    private func setupFloatingButton() {
        
        guard isAuthenticated else {
            return
        }
        
        var bottomMargin: CGFloat = 0
        if let bottomSafeArea = SceneDelegate.shared?.window?.safeAreaInsets.bottom {
            bottomMargin = bottomSafeArea
        }
        
        self.flotingBtn = UIButton(frame: CGRect(x: self.view.frame.width - 80, y: self.view.frame.height - (80 + bottomMargin), width: 60, height: 60))
        self.flotingBtn.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        self.flotingBtn.imageEdgeInsets = UIEdgeInsets (top: 10, left: 10, bottom: 10, right: 10)
        self.flotingBtn.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        self.flotingBtn.cornerRadius = 30
        self.flotingBtn.enableShadow = true
        self.flotingBtn.layer.shadowColor = UIColor.black.cgColor
        self.flotingBtn.addTarget(self, action: #selector(floatingButton_Tapped), for: .touchUpInside)
        
        SceneDelegate.shared?.window?.addSubview(self.flotingBtn)
    }
    
    @objc func floatingButton_Tapped() {
        if let topviewController = navigationController?.topViewController {
          
            guard topviewController.isKind(of: NotificationController.self) else {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                       let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "NotificationController") as! NotificationController
                       navigationController?.pushViewController(vc, animated: true)
                return
            }
            
        }
        
    }
    
  
    
    func fetchHomeData () {
        loader.startAnimating()
        
        APIManager.manager.fetchCommodities { (comodities, error) in
            if let data = comodities {
                self.commodities = data
                DispatchQueue.main.async {
                    self.rateTableView.reloadData()
                }
            }
        }
        
        APIManager.manager.fetchAds { (ads, error) in
            if let data = ads {
                self.ads = self.ads + data
                DispatchQueue.main.async {
                    self.adsCollectionView.reloadData()
                    self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.switchAdvertisement), userInfo: nil, repeats: true)
                }
            }
        }
        
        APIManager.manager.fetchPrices { (prices, error) in
            if let data = prices {
                self.price = data
                DispatchQueue.main.async {
                    self.rateTableView.reloadData()
                    Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.updateRates), userInfo: nil, repeats: true)
                }
            }
        }
        
        
        APIManager.manager.fetchNotices { (notice, error) in
            if let data = notice {
                DispatchQueue.main.async {
                    self.Middle_TextView.text = data.concatNotices()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        self.scrollTextView()
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
            self.loader.stopAnimating()
            self.loader.isHidden = true
        }
    }
    
    
    @IBAction func BD_Info_Tapped(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func Drawer_Tapped(_ sender: UIButton) {
        if Bottom_DrawerView.position == .collapsed {
            Bottom_DrawerView?.setPosition(.partiallyOpen, animated: true)
        } else {
            Bottom_DrawerView?.setPosition(.collapsed, animated: true)
        }
    }
    
    @IBAction func SideMenuTapped(_ sender: UIButton) {
        sideMenuController?.revealMenu()
        
    }
    
    public func scrollTextView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 15, delay: 2, options: [.curveLinear, .beginFromCurrentState,.allowUserInteraction], animations: {
                
                self.Middle_TextView.contentOffset = CGPoint.init(x: 0, y: self.Middle_TextView.frame.height)
                
            }, completion: { (finished) in
                UIView.animate(withDuration: 15, delay: 2, options: [.curveLinear, .beginFromCurrentState, .allowUserInteraction], animations: {
                    
                    self.Middle_TextView.contentOffset = CGPoint.zero
                    
                }, completion: { (finished) in
                    self.scrollTextView()
                })
            })
        }
    }
    
    @objc func updateRates(){
        APIManager.manager.fetchCommodities { (commodities, error) in
            guard let data = commodities else {
                return
            }
            
            DispatchQueue.main.async {
                
                if self.commodities.count > 0 {
                    
                    if Int(self.commodities.first!.bid!) ?? 0 > Int(data.first!.bid!) ?? 0 {
                        HomeController.self.mcxGoldColor = UIColor.lossColor
                    }
                    else if Int(self.commodities.first!.bid!) == Int(data.first!.bid!){
                        HomeController.self.mcxGoldColor = UIColor.noChangeColor
                    }
                    else {
                        HomeController.self.mcxGoldColor = UIColor.gainColor
                    }
                    
                    if Double(self.commodities.last!.bid!) ?? 0.0 > Double(data.last!.bid!) ?? 0.0 {
                        HomeController.self.inrRateColor = UIColor.lossColor
                    }
                    else if Int(self.commodities.last!.bid!) ?? 0 == Int(data.last!.bid!) ?? 0{
                        HomeController.self.inrRateColor = UIColor.noChangeColor
                    }
                    else {
                        HomeController.self.inrRateColor = UIColor.gainColor
                    }
                    
                    if Int(self.commodities[1].bid!) ?? 0 > Int(data[1].bid!) ?? 0{
                        HomeController.self.mcxSilverColor = UIColor.lossColor
                    }
                    else if Int(self.commodities[1].bid!) ?? 0  == Int(data[1].bid!) ?? 0 {
                        HomeController.self.mcxSilverColor = UIColor.noChangeColor
                    }
                    else {
                        HomeController.self.mcxSilverColor = UIColor.gainColor
                    }
                }
                self.commodities = data
                
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
            
            let priority = self.ads[item].priority
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


extension HomeController: UITableViewDataSource, UITableViewDelegate{
    
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
        
        return 75
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

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func updateAttributedString(str: String, subStr: String)-> NSAttributedString{

        let range = (str as NSString).range(of: subStr)
        
        let attributedString = NSMutableAttributedString(string: str)
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)], range: range)
        
        return attributedString
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1{
            return self.ads.count
        }
        
        return self.commodities.count-1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adsCollectionViewCell", for: indexPath) as! AdvertisementsCollectionViewCell
            cell.adsImageView.sd_setImage(with: URL(string: baseURL+self.ads[indexPath.row].sliderImage.rawValue), completed: nil)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "priceCollectionViewCell", for: indexPath) as! PriceCollectionViewCell
        
        if indexPath.row == 0 && collectionView.tag == 2{
            cell.commodityLabel.text = "MCX Gold"
            cell.commodityValueLabel.text = self.commodities.first?.bid
            cell.commodityValueLabel.backgroundColor = HomeController.mcxGoldColor
        }
        if indexPath.row == 1 && collectionView.tag == 2{
            cell.commodityLabel.attributedText = self.updateAttributedString(str: "MRT G-999 *GSTExtra", subStr: "*GSTExtra")
            cell.commodityValueLabel.text = self.price.gMrt
        }
        if indexPath.row == 2 && collectionView.tag == 2{
            cell.commodityLabel.attributedText = self.updateAttributedString(str: "MRT G-HZR *GSTExtra", subStr: "*GSTExtra")
            cell.commodityValueLabel.text = self.price.gHzr
        }
        
        if indexPath.row == 3 && collectionView.tag == 2{
                   cell.commodityLabel.attributedText = self.updateAttributedString(str: "MRT G-Jewar *GSTExtra", subStr: "*GSTExtra")
                   cell.commodityValueLabel.text = self.price.gJvr
                   cell.commodityValueLabel.backgroundColor = UIColor.noChangeColor
               }
        
        if indexPath.row == 0 && collectionView.tag == 3{
            cell.commodityLabel.text = "MCX Silver"
            cell.commodityValueLabel.text = self.commodities[1].bid
            cell.commodityValueLabel.backgroundColor = HomeController.mcxSilverColor
        }
        if indexPath.row == 1 && collectionView.tag == 3{
            cell.commodityLabel.attributedText = self.updateAttributedString(str: "MRT S-999 *GSTExtra", subStr: "*GSTExtra")
            cell.commodityValueLabel.text = self.price.sMrt
        }
        if indexPath.row == 2 && collectionView.tag == 3{
            cell.commodityLabel.attributedText = self.updateAttributedString(str: "MRT S-HZR *GSTExtra", subStr: "*GSTExtra")
            cell.commodityValueLabel.text = self.price.sHzr
        }
        
        if indexPath.row == 3 && collectionView.tag == 3{
            cell.commodityLabel.text = "USD(1$)"
            cell.commodityValueLabel.text = self.commodities.last?.bid
            cell.commodityValueLabel.backgroundColor = HomeController.inrRateColor
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
        
        return CGSize(width: (self.view.frame.width-1.5)/4, height: 75)
    }
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		collectionView.deselectItem(at: indexPath, animated: true)
		
		if collectionView.tag == 1 {
			self.flotingBtn.alpha = 0
			let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(withIdentifier: "AdertisementViewController") as! AdertisementViewController
			vc.ad = self.ads[indexPath.row]
			navigationController?.pushViewController(vc, animated: true)
			
		}
	}
}


extension HomeController : DrawerViewDelegate {
    
	func drawer(_ drawerView: DrawerView, willTransitionFrom startPosition: DrawerPosition, to targetPosition: DrawerPosition) {
		if targetPosition == .partiallyOpen {
			self.Bottom_Menubar.alpha = isAuthenticated ? 1 : 0
			self.Top_Menubar.alpha = 1
            self.flotingBtn.alpha = 0
		} else {
            self.Top_Menubar.alpha = 0
            self.Bottom_Menubar.alpha = 0
		}
	}
	
    func drawer(_ drawerView: DrawerView, didTransitionTo position: DrawerPosition) {
        if position == .partiallyOpen {
            UIView.animate(withDuration: 0.5) {
                self.BD_btn.transform = CGAffineTransform (rotationAngle: -3.14)
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.flotingBtn.alpha = 1
                self.BD_btn.transform = .identity
            }
        }
    }
    
    
}
