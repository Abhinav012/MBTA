//
//  BoardViewController.swift
//  MBTA
//
//  Created by Ravi on 30/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import SDWebImage

class BoardViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    

    var boardMembers: Board? {
        didSet {
            DispatchQueue.main.async {
                self.Board_View.delegate = self
                self.Board_View.dataSource = self
                self.Board_View.reloadData()
            }
        }
    }
    
    @IBOutlet weak var Board_View: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        APIManager.manager.fetchBoardMember { (model, error) in
            guard let error = error else {
                self.boardMembers = model?.board
                return
            }
            
            print(error.localizedDescription)
        }
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return (self.boardMembers?.patron.count ?? 0) + 1
        case 1:
            return (self.boardMembers?.president.count ?? 0) + 1
        case 2:
            return (self.boardMembers?.vicePresident.count ?? 0) + 1
        case 3:
            return (self.boardMembers?.generalSecretary.count ?? 0) + 1
        case 4:
            return (self.boardMembers?.jointSecretary.count ?? 0) + 1
        case 5:
            return (self.boardMembers?.treasurer.count ?? 0) + 1
        case 6:
            return (self.boardMembers?.honourablePanch.count ?? 0) + 1
        case 7:
            return (self.boardMembers?.executiveMember.count ?? 0) + 1
        case 8:
            return (self.boardMembers?.dharamkataIncharge.count ?? 0) + 1
        case 9:
            return (self.boardMembers?.mediaIncharge.count ?? 0) + 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard indexPath.row != 0 else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardHeaderCell", for: indexPath) as! BoardHeaderCell
            
            switch indexPath.section {
                
            case 0:
                cell.Title.text = self.boardMembers?.patron[0].post
            case 1:
               cell.Title.text = self.boardMembers?.president[0].post ?? "President"
            case 2:
                cell.Title.text = self.boardMembers?.vicePresident[0].post
            case 3:
                cell.Title.text = self.boardMembers?.generalSecretary[0].post
            case 4:
                cell.Title.text = self.boardMembers?.jointSecretary[0].post
            case 5:
                cell.Title.text = self.boardMembers?.treasurer[0].post
            case 6:
                cell.Title.text = self.boardMembers?.honourablePanch[0].post
            case 7:
                cell.Title.text = self.boardMembers?.executiveMember[0].post
            case 8:
                cell.Title.text = self.boardMembers?.dharamkataIncharge[0].post
            default:
                cell.Title.text = self.boardMembers?.mediaIncharge[0].post
                
            }
            
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardMemberCell", for: indexPath) as! BoardMemberCell
        var person : DharamkataIncharge?
        
        switch indexPath.section {
        case 0:
            person = self.boardMembers?.patron[indexPath.row - 1]
        case 1:
            person = self.boardMembers?.president[indexPath.row - 1]
        case 2:
            person = self.boardMembers?.vicePresident[indexPath.row - 1]
        case 3:
            person = self.boardMembers?.generalSecretary[indexPath.row - 1]
        case 4:
            person = self.boardMembers?.jointSecretary[indexPath.row - 1]
        case 5:
            person = self.boardMembers?.treasurer[indexPath.row - 1]
        case 6:
            person = self.boardMembers?.honourablePanch[indexPath.row - 1]
        case 7:
            person = self.boardMembers?.executiveMember[indexPath.row - 1]
        case 8:
            person = self.boardMembers?.dharamkataIncharge[indexPath.row - 1]
        default:
            person = self.boardMembers?.mediaIncharge[indexPath.row - 1]
        }
        
        cell.Member_Firm.text = person?.fName
        cell.Member_name.text = person?.name
        
        DispatchQueue.main.async {
            cell.Member_img.sd_setImage(with: URL(string: baseURL+(person?.photo ?? "")),placeholderImage: #imageLiteral(resourceName: "user"), completed: nil)
        }
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard indexPath.row != 0 else {
            return CGSize (width: (self.view.frame.width) - 15, height: 50)
        }
        
        guard indexPath.section != 1 else {
            return CGSize (width: (self.view.frame.width) - 15, height: 250)
        }
        
        return CGSize (width: (self.view.frame.width/2.0) - 15, height: 270)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets (top:10, left: 7.5, bottom: 10, right: 7.5)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize (width: self.view.frame.width, height: 50)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BoardHeaderView", for: indexPath) as! BoardHeaderView
//
//        headerView.frame.size.height = 50
//        guard self.boardMembers != nil, indexPath.row == 0 else{
//            return headerView
//        }
//
//        for item in headerView.subviews {
//            item.removeFromSuperview()
//        }
//
//        let Title = UILabel ()
//        Title.frame = headerView.frame
//        Title.font = .systemFont(ofSize: 19, weight: .semibold )
//        Title.textAlignment = .center
//        Title.backgroundColor = .clear
//        Title.textColor = .white
//
//        switch indexPath.section {
//
//        case 0:
//            Title.text = self.boardMembers?.patron[0].post
//        case 1:
//            Title.text = self.boardMembers?.president[0].post ?? "President"
//        case 2:
//            Title.text = self.boardMembers?.vicePresident[0].post
//        case 3:
//            Title.text = self.boardMembers?.generalSecretary[0].post
//        case 4:
//            Title.text = self.boardMembers?.jointSecretary[0].post
//        case 5:
//            Title.text = self.boardMembers?.treasurer[0].post
//        case 6:
//            Title.text = self.boardMembers?.honourablePanch[0].post
//        case 7:
//            Title.text = self.boardMembers?.executiveMember[0].post
//        case 8:
//            Title.text = self.boardMembers?.dharamkataIncharge[0].post
//        default:
//            Title.text = self.boardMembers?.mediaIncharge[0].post
//
//        }
//
//        headerView.addSubview(Title)
//
//        return headerView
//    }
}
