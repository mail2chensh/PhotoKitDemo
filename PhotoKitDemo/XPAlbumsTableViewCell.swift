//
//  XPAlbumsTableViewCell.swift
//  PhotoKitDemo
//
//  Created by dev on 2017/12/12.
//  Copyright © 2017年 iAskDoc Technology. All rights reserved.
//

import UIKit

class XPAlbumsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
