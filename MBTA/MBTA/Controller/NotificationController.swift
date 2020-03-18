//
//  NotificationController.swift
//  MBTA
//
//  Created by Ravi on 06/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit

class NotificationController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var Table_view: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.Table_view.delegate = self
        self.Table_view.dataSource = self
        self.Table_view.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.Title_lbl.text = "SAndeep Agarwal"
        cell.SubTitle_lbl.text = "(Dharamkata Incharge)"
        cell.Date_lbl.text = "2020-03-06 19:12 pm"
        cell.Header_lbl.text = "visit Meerut Bullion Association (MBTA) on facebook also"
		cell.Description_lbl.text = indexPath.row % 2 == 0 ? "No Description" : "Lorem ipsum मातम बैठ अमेट consectetur adipiscing elit। माइक्रोवेव प्लेस्टेशन समय, नि: शुल्क बिल्लियों नहीं बैठता ग्रील्ड। फ़ुटबॉल लियो सदस्यों, मुझे उस ग्राफ ग्रील्ड। फ़ुटबॉल ईयू उपभोक्ता, सबसे बड़ी महान। उक्ति sapien के सिरों के कलश में कल, गैर laoreet Metus lobortis। वास्तव में, lorem Metus, मुलायम नहीं बैठता अमेट iaculis, फेलिस पर ornare"
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
