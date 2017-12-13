//
//  XPAlbumCollectionViewCell.swift
//  PhotoKitDemo
//
//  Created by dev on 2017/12/13.
//  Copyright © 2017年 iAskDoc Technology. All rights reserved.
//

import UIKit

@objc protocol XPAlbumCollectionViewCellDelegate: NSObjectProtocol {
    
    @objc func albumCollectionViewCell(cell: XPAlbumCollectionViewCell, didSelectedAtIndexPath indexPath: IndexPath, selectedStatus status: Bool)
    
}

class XPAlbumCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var tickButton: UIButton!
    
    var indexPath: IndexPath!
    
    var cellDelegate: XPAlbumCollectionViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func buttonDidSelected(_ sender: Any) {
        tickButton.isSelected = !tickButton.isSelected
        //
        if self.cellDelegate != nil && self.cellDelegate.responds(to: #selector(XPAlbumCollectionViewCellDelegate.albumCollectionViewCell(cell:didSelectedAtIndexPath:selectedStatus:))) {
            self.cellDelegate.albumCollectionViewCell(cell: self, didSelectedAtIndexPath: self.indexPath, selectedStatus: tickButton.isSelected)
        }
    }
    
}
