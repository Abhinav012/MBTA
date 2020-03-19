//
//  UIColor+Extension.swift
//  MBTA
//
//  Created by Abhinav Verma on 19/02/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    static let gainColor = #colorLiteral(red: 0.2453502715, green: 0.6281521916, blue: 0.09683348984, alpha: 1)
    static let lossColor = #colorLiteral(red: 0.8620759845, green: 0.2074970901, blue: 0.1488315463, alpha: 1)
    static let noChangeColor = #colorLiteral(red: 0.1107075289, green: 0.1301555037, blue: 0.208319366, alpha: 1)
    
}

public extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

public extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return self.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    
    @IBInspectable
    var enableShadow: Bool {
        get { return self.enableShadow }
        set { if newValue {
            self.layer.shadowColor = UIColor.lightGray.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 5
            self.layer.shadowOpacity = 0.5
            self.layer.masksToBounds = false
            } }
    }
}

public extension String {
    
	func formaeID() -> String {
		
		switch self.count {
		case 0:
			return "0000"
		case 1:
			return "000"+self
		case 2:
			return "00"+self
		case 3:
			return "0"+self
		default:
			return self
		}
	}
	
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}


public extension UIWindow {
    
    func replaceRootViewController(with viewController: UIViewController, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let view = rootViewController?.view else {
            rootViewController = viewController
            if let completion = completion {
                completion(true)
            }
            return
        }
        
        UIView.transition(from: view, to: viewController.view, duration: (animated) ? 0.3 : 0, options: .transitionCrossDissolve, completion: { (success) in
            self.rootViewController = viewController
            if let completion = completion {
                completion(success)
            }
        })
    }
    
}

