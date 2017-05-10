//
//  YTAssetGridCollectionViewCell.swift
//  PhotoKitDemo
//
//  Created by dev on 2017/5/9.
//  Copyright © 2017年 Chensh. All rights reserved.
//

import UIKit

class YTAssetGridCollectionViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

}
