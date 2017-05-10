//
//  YTAssetGridCollectionViewCell.swift
//  PhotoKitDemo
//
//  Created by dev on 2017/5/9.
//  Copyright © 2017年 Chensh. All rights reserved.
//

import UIKit


@objc protocol YTAssetGridCollectionViewCellDelegate: NSObjectProtocol {
    @objc optional func assetGridCollectionViewCellDidSelected(_ cell: YTAssetGridCollectionViewCell, isSelected: Bool)
}

class YTAssetGridCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    var representedAssetIdentifier: String!
    var indexPath: IndexPath!
    
    var cellDelegate: YTAssetGridCollectionViewCellDelegate!
    
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
    
    
    @IBAction func selectButtonDidTouch(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if (cellDelegate != nil && cellDelegate.responds(to: #selector(YTAssetGridCollectionViewCellDelegate.assetGridCollectionViewCellDidSelected(_:isSelected:)))) {
            cellDelegate.assetGridCollectionViewCellDidSelected!(self, isSelected: sender.isSelected)
        }
        
    }

}
