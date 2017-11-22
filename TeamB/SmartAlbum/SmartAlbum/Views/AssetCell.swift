//
//  AssetCell.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 20..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit

class AssetCell: UICollectionViewCell {
    
    // MARK:- Properties
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var playIcon: UIImageView!
    
    // MARK:- Init
    
    override var isHighlighted: Bool {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.isHighlighted {
            self.layer.borderWidth = 2.0
            self.layer.borderColor = UIColor.blue.cgColor
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
