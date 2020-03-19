//
//  AdertisementViewController.swift
//  MBTA
//
//  Created by AllSpark on 19/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation


class AdertisementViewController: UIViewController {

	@IBOutlet var Poster_img: UIImageView!
	
	public var ad: Datum?
	
	override func viewDidLoad() {
        super.viewDidLoad()

		guard let ad = self.ad else {
			self.dismiss(animated: true, completion: nil)
			return
		}
		
		DispatchQueue.main.async {
			if ad.isImage == "1" {
				
				self.Poster_img.sd_setImage(with: URL(string: baseURL+(ad.fullImage.rawValue)), completed: { (img, error, tyoe, url) in
					guard let error = error else {
						return
					}
					print(error.localizedDescription)
					self.dismiss(animated: true, completion: nil)
					
				})
				
			} else {
				
				let player = AVPlayer(url: URL(string: ad.videoLink)!)
				let playerLayer = AVPlayerLayer(player: player)
				playerLayer.frame = self.Poster_img.bounds
				self.Poster_img.layer.addSublayer(playerLayer)
				player.play()
			}
		}
		
    }
    

}
