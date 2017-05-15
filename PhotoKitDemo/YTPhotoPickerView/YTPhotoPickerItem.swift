//
//  YTPhotoPickerItem.swift
//  PhotoKitDemo
//
//  Created by Chensh on 2017/5/14.
//  Copyright © 2017年 Chensh. All rights reserved.
//

import UIKit


@objc protocol YTPhotoPickerItemDelegate: NSObjectProtocol {
    
     @objc func photoPickerItemDidTouch(_ item: YTPhotoPickerItem, _ index: Int)
    
     @objc func photoPickerItemDidDelete(_ item: YTPhotoPickerItem, _ index: Int)
}

class YTPhotoPickerItem: UIView {

    var delegate: YTPhotoPickerItemDelegate? = nil
    
    var index: Int = 0
    
    var isAddButton: Bool = false {
        didSet {
            self.deleteButton.isHidden = isAddButton
            if isAddButton {
                self.imageView.image = UIImage.init(named: "")
            } else {
                self.imageView.image = self.image
            }
        }
    }
    
    var image: UIImage! {
        didSet {
            self.imageView.image = image
        }
    }
    
    override var frame: CGRect {
        didSet {
            self.imageView.frame = CGRect(x: imageInsets.left, y: imageInsets.top, width: self.frame.size.width - imageInsets.left - imageInsets.right, height: self.frame.size.height - imageInsets.top - imageInsets.bottom)
        }
    }
    
    var imageInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0) {
        didSet {
            self.imageView.frame = CGRect(x: imageInsets.left, y: imageInsets.top, width: self.frame.size.width - imageInsets.left - imageInsets.right, height: self.frame.size.height - imageInsets.top - imageInsets.bottom)
        }
    }
    
    var deleteButton: UIButton!
    
    fileprivate var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func initSubviews() {
        //
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(imageDidTouch(_:))))
        
        //
        self.imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.addSubview(self.imageView)
        
        //
        self.deleteButton = UIButton(type: .custom)
        self.deleteButton.setImage(UIImage.init(named: ""), for: .normal)
        self.deleteButton.addTarget(self, action: #selector(imageDidDelete(_:)), for: .touchUpInside)
        self.addSubview(self.deleteButton)
        
        //
        
    }
    
    func imageDidTouch(_ sender: UITapGestureRecognizer) {
        if self.delegate != nil && (self.delegate?.responds(to: #selector(YTPhotoPickerItemDelegate.photoPickerItemDidTouch(_:_:))))! {
            self.delegate?.photoPickerItemDidTouch(self, self.index)
        }
    }
    
    
    func imageDidDelete(_ sender: UIButton) {
        if self.delegate != nil && (self.delegate?.responds(to: #selector(YTPhotoPickerItemDelegate.photoPickerItemDidDelete(_:_:))))! {
            self.delegate?.photoPickerItemDidDelete(self, self.index)
        }
    }
    

    

}
