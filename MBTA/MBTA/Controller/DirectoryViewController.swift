//
//  DirectoryViewController.swift
//  MBTA
//
//  Created by AllSpark on 18/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import JGProgressHUD
import SDWebImage
import iOSDropDown

class DirectoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {

	@IBOutlet var Directory_tbl: UITableView!
	
	@IBOutlet var Category_Filter: UIView!
	@IBOutlet var Bazar_Filter: UIView!
	@IBOutlet var Bazar_DropDown: DropDown!
	@IBOutlet var Category_DropDown: DropDown!
	
	@IBOutlet var Searchbar: UISearchBar!
	@IBOutlet var Search_btn: UIButton!
	
	@IBOutlet var SearchBar_HC: NSLayoutConstraint!

	var hud = JGProgressHUD(style: .dark)

	var directories = [Firm]()
	var bazars = [String]()
	var categories = ["Retail","Manufacturer","Whole Seller","Silver","Gold","Diamond"]
	
	var filterCategoryBy = String()
	var filterBazarBy = String()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.SearchBar_HC.constant = 0
		self.Directory_tbl.tableFooterView = UIView()
    }
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.getData()
	}
	
	
	func getData() {
		
		self.Bazar_DropDown.delegate = self
		self.Category_DropDown.delegate = self
		hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
		hud.vibrancyEnabled = true
		hud.textLabel.text = "Loading"
		hud.show(in: self.view, animated: true)
		self.directories.removeAll()
		APIManager.manager.fetchDirectoryData { (data, error) in
			guard let error = error else {
				
				guard let directories = data?.firms else {
					
					DispatchQueue.main.async {
						self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
						self.hud.textLabel.text = "No Directory Found !!!"
						self.hud.dismiss(afterDelay: 2.0)
						
						self.Directory_tbl.reloadData()
						self.hud.dismiss(afterDelay: 1.0)
					}
					
					return
				}
				self.directories = directories
				
				DispatchQueue.global().async {
					let bazarAll = self.directories.map({ (firm) -> String in
						return (firm.bazar ?? "")
						}).removeDuplicates()
					
//					let categoryAll = self.directories.map({ (firm) -> String in
//					return (firm.nature ?? "")
//					}).removeDuplicates()
					
					self.bazars = bazarAll
					self.bazars.insert("Select Bazar", at: 0)
					self.categories.insert("Select Category", at: 0)
//					self.categories = categoryAll
					
					DispatchQueue.main.async {
						self.configureDropDowns()
					}
					
				}
				
				DispatchQueue.main.async {
					self.Directory_tbl.reloadData()
					self.hud.dismiss(afterDelay: 1.0)
				}
				return
			}
			
			print(error.localizedDescription)
			self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
			self.hud.textLabel.text = "Try Later !!!"
			self.hud.dismiss(afterDelay: 2.0)
			
		}
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return false
	}
	
	
	func configureDropDowns() {
		
		Bazar_DropDown.listHeight = self.view.frame.height / 2
		Bazar_DropDown.optionArray = self.bazars
		
		Bazar_DropDown.text = self.filterCategoryBy
		Bazar_DropDown.selectedRowColor = .lightGray
		
		Bazar_DropDown.didSelect{(selectedText , index ,id) in
			self.filterBazarBy = selectedText
			self.Bazar_DropDown.hideList()
			
		}
		Bazar_DropDown.text = "Select Bazar"
		
		Category_DropDown.listHeight = self.view.frame.height / 2
		Category_DropDown.optionArray = self.categories
		
		Category_DropDown.text = self.filterCategoryBy
		Category_DropDown.selectedRowColor = .lightGray
		
		Category_DropDown.didSelect{(selectedText , index ,id) in
			self.filterCategoryBy = selectedText
			self.Category_DropDown.hideList()
			
		}
		Category_DropDown.text = "Select Category"
		
	}
	
	@IBAction func Link_Tapped(_ sender: UIButton) {
		
		guard let string = sender.attributedTitle(for: .normal) else {
			return
		}
		
		guard let url = URL(string: string.string) else {
			return
		}
		UIApplication.shared.open(url)
	}
	
	@IBAction func SearchBtn_Tapped(_ sender: UIButton) {
		
		if self.SearchBar_HC.constant == 0 {
			self.SearchBar_HC.constant = 44
			UIView.animate(withDuration: 0.3, animations: {
				self.view.layoutIfNeeded()
			}) { (true) in
				sender.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
			}
		} else {
			self.SearchBar_HC.constant = 0
			UIView.animate(withDuration: 0.3, animations: {
				self.view.layoutIfNeeded()
			}) { (true) in
				sender.setImage(#imageLiteral(resourceName: "search"), for: .normal)
			}
		}
		
	}
	

	func numberOfSections(in tableView: UITableView) -> Int {
		self.directories.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let members = self.directories[section].member else {
			return 0
		}
		return members.count + 1
	}
    
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.row == 0 {
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "FirmCell", for: indexPath) as! FirmCell
			
			let firm = self.directories[indexPath.section]
			
			cell.Firm_id.text = firm.memberid
			cell.Firm_type.text = firm.nature
			cell.Firm_title.text = firm.fname
			cell.Firm_adress.text = firm.fadd
			if let text = firm.f_url {
				let textRange = NSMakeRange(0, text.count)
				let attributedText = NSMutableAttributedString(string: text)
				attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
				
				cell.Link_btn.setAttributedTitle(attributedText, for: .normal)
			} else {
				cell.Link_btn.setTitle(nil, for: .normal)
			}
			DispatchQueue.main.async {
				cell.Firm_logo.sd_setImage(with: URL(string: baseURL+(firm.flogo ?? "")),placeholderImage: #imageLiteral(resourceName: "applogo"), completed: nil)
			}
			return cell
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "FirmMemberCell", for: indexPath) as! FirmMemberCell
		
		let index = indexPath.row > 0 ? indexPath.row - 1 : 0
		
		if let members = self.directories[indexPath.section].member {
			
			let member = members[index]
			cell.Member_name.text = "\(member.name ?? "") ( \(member.designation ?? "") )"
		}
		
		
		return cell
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return UITableView.automaticDimension
		}
		
		return 50
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let lable = UILabel (frame: CGRect (x: 0, y: 0, width: self.view.frame.width, height: 10))
		lable.text = "--------------------------------------------------------------------"
		lable.numberOfLines = 1
		lable.textColor = .systemGray2
		lable.lineBreakMode = .byCharWrapping
		return lable
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 10
	}
	
}
