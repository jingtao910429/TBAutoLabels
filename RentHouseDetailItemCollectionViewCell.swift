//
//  RentHouseDetailItemCollectionViewCell.swift
//  rabbitDoctor
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 rabbitDoctor. All rights reserved.
//

import UIKit

class RentHouseDetailItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func bindData(_ obj: Any?) {
        if let data = obj as? RentHouseDetailInfoFacilitiesModel {
            if data.iconUrl != "" {
                self.iconImageView.kf.setImage(with: URL(string: data.iconUrl))
            }
            self.nameLabel.text = data.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
