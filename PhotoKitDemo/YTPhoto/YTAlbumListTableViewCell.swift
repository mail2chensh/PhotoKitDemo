//
//  YTAlbumListTableViewCell.swift
//  PhotoKitDemo
//
//  Created by Chensh on 2017/5/8.
//  Copyright © 2017年 Chensh. All rights reserved.
//

import UIKit

class YTAlbumListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
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
