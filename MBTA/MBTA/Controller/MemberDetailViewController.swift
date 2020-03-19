//
//  MemberDetailViewController.swift
//  MBTA
//
//  Created by AllSpark on 19/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import SDWebImage

class MemberDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

	@IBOutlet var Firm_nature: UILabel!
	@IBOutlet var Firm_url: UIButton!
	@IBOutlet var Firm_address: UILabel!
	@IBOutlet var Firm_name: UILabel!
	@IBOutlet var Firm_id: UILabel!
	@IBOutlet var Firm_logo: UIImageView!
	
	@IBOutlet var Membre_tbl: UITableView!
	
	public var firm : Firm?
	
	override func viewDidLoad() {
        super.viewDidLoad()

		self.Membre_tbl.delegate = self
		self.Membre_tbl.dataSource = self
		self.Membre_tbl.tableFooterView = UIView()
		
		if let firm = self.firm {
			self.Firm_id.text = (firm.memberid == nil ? "" : firm.memberid)?.formaeID()
			self.Firm_nature.text = firm.nature
			self.Firm_name.text = firm.fname
			self.Firm_address.text = firm.fadd
			if let text = firm.f_url {
				let textRange = NSMakeRange(0, text.count)
				let attributedText = NSMutableAttributedString(string: text)
				attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
				
				self.Firm_url.setAttributedTitle(attributedText, for: .normal)
			} else {
				self.Firm_url.setTitle(nil, for: .normal)
			}
			DispatchQueue.main.async {
				self.Firm_logo.sd_setImage(with: URL(string: baseURL+(firm.flogo ?? "")),placeholderImage: #imageLiteral(resourceName: "appLogo"), completed: nil)
			}
			
			self.Membre_tbl.reloadData()
		}
    }
    
	@IBAction func Firm_Link_Tapped(_ sender: UIButton) {
		
		
	}
	@IBAction func Call_Tapped(_ sender: UIButton) {
	}
	@IBAction func Whatsapp_Tapped(_ sender: UIButton) {
	}
	@IBAction func Email_Tapped(_ sender: UIButton) {
	}
	@IBAction func Chat_Tapped(_ sender: UIButton) {
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let members = self.firm?.member else {
			return 0
		}
		
		return members.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
		
		if let member = self.firm?.member?[indexPath.row] {
			
			cell.Member_name.text = member.name
			cell.Member_position.text = member.post == nil ? nil : "( \(member.post!) )"
			cell.Member_phone1.text = member.mobile1
			cell.Member_phone2.text = member.mobile2
			cell.Member_email.text = member.email
			cell.Member_adress.text = member.resi_add
			DispatchQueue.main.async {
				cell.Member_logo.sd_setImage(with: URL(string: baseURL+(member.photo ?? "")),placeholderImage: #imageLiteral(resourceName: "user"), completed: nil)
			}
			
		}
		
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
}
