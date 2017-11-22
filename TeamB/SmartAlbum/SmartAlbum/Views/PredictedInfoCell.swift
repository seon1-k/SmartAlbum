//
//  PredictedInfoCell.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 22..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit

class PredictedInfoCell: UITableViewCell {
    
    @IBOutlet weak var predictedImgView: UIImageView!
    @IBOutlet weak var dimmedLayerView: UIView!
    @IBOutlet weak var predictedKeywordLabel: UILabel!
    @IBOutlet weak var predictedPrbLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
