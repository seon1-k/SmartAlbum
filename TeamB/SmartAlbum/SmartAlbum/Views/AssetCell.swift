//
//  AssetCell.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 20..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit

private let highlightedColor = UIColor(red:0.12, green:0.77, blue:0.27, alpha:1.00)

class AssetCell: UICollectionViewCell {
    
    // MARK:- Outlets
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var playIcon: UIImageView!
    @IBOutlet weak var specialHighlightedArea: UIView!
    @IBOutlet weak var checkedImg: UIImageView!
    
    // MARK:- Properties
    
    var shouldTintBackgroundWhenSelected = true

    // MARK:- Init
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isHighlighted && !isSelected {
            self.checkedImg.isHidden = true
        }
    }
    
    override var isHighlighted: Bool {
        willSet {
            self.onSelected(newValue)
        }
    }
    
    override var isSelected: Bool {
        willSet {
            self.onSelected(newValue)
        }
    }
    
    // MARK:- Help Fucntion to change UI
    
    func onSelected(_ newValue: Bool) {
        if shouldTintBackgroundWhenSelected {
            self.layer.borderWidth = 3.0
            self.checkedImg.isHidden = newValue ? false : true
            self.layer.borderColor = newValue ? highlightedColor.cgColor : UIColor.clear.cgColor
        }
        if let sa = self.specialHighlightedArea {
            sa.backgroundColor = newValue ? UIColor.black.withAlphaComponent(0.4) : UIColor.clear
        }
    }

}
