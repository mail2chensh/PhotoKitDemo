//
//  YTPhotoPickerView.swift
//  PhotoKitDemo
//
//  Created by Chensh on 2017/5/14.
//  Copyright © 2017年 Chensh. All rights reserved.
//

import UIKit


@objc protocol YTPhotoPickerViewDelegate: NSObjectProtocol {
    
    // 返回最大可选择数
    @objc optional func maxCountOfItemsInPhotoPickerView(_ photoPickerView: YTPhotoPickerView) -> Int
    
    // 返回每行的个数
    @objc optional func itemsCountInOneLineOfPhotoPickerView(_ photoPickerView: YTPhotoPickerView) -> Int
    
    // 返回当前图片数据的个数
    @objc func numberOfItemsInPhotoPickerView(_ photoPickerView: YTPhotoPickerView) -> Int
    
    // 返回索引对应的具体图片
    @objc func imageForItemInPhotoPickerView(_ photoPickerView: YTPhotoPickerView, index: Int) -> UIImage
    
    // 点击了新增按钮
    @objc optional func photoPickerViewDidTouchAddButton(_ photoPickerView: YTPhotoPickerView)
    
    // 点击了删除按钮
    @objc optional func photoPickerViewDidTouchDeleteButton(_ photoPickerView: YTPhotoPickerView, index: Int)
    
    // 点击了图片
    @objc optional func photoPickerViewDidTouchImage(_ photoPickerView: YTPhotoPickerView, index: Int)
}



class YTPhotoPickerView: UIView {

    var delegate: YTPhotoPickerViewDelegate? = nil
    
    // 每行的个数
    var itemCountInLine: Int = 4
    
    var itemSize: CGFloat = 0
    
    var itemLineSpace: CGFloat = 0
    
    var itemInterSpace: CGFloat = 0
    
    var itemEdgeInsets: UIEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5)
    
    fileprivate var maxCountOfItems: Int = 1
    
    fileprivate var currentCountOfItems: Int = 0
    
    fileprivate var currentItemsArray: [YTPhotoPickerItem] = []
    
    fileprivate var itemsPool: [YTPhotoPickerItem] = []
    
    // ==========================
    // MARK: 初始化视图
    // ==========================
    
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
        
        // 获取最大个数
        if self.delegate != nil && (self.delegate?.responds(to: #selector(YTPhotoPickerViewDelegate.maxCountOfItemsInPhotoPickerView(_:))))! {
            self.maxCountOfItems = (self.delegate?.maxCountOfItemsInPhotoPickerView!(self))!
        } else {
            self.maxCountOfItems = 1
        }
        
        // 获取每行的个数
        if self.delegate != nil && (self.delegate?.responds(to: #selector(YTPhotoPickerViewDelegate.itemsCountInOneLineOfPhotoPickerView(_:))))! {
            self.maxCountOfItems = (self.delegate?.itemsCountInOneLineOfPhotoPickerView!(self))!
        } else {
            self.maxCountOfItems = 4
        }
        
        // 根据每行的个数计算出item的大小
        itemSize = UIScreen.main.bounds.width / CGFloat(self.maxCountOfItems)
        
        // 获取当前图片数据的数量
        if self.delegate != nil && (self.delegate?.responds(to: #selector(YTPhotoPickerViewDelegate.numberOfItemsInPhotoPickerView(_:))))! {
            self.currentCountOfItems = (self.delegate?.numberOfItemsInPhotoPickerView(self))!
        } else {
            self.currentCountOfItems = 0
        }
        
        
        
        
        
    }
    
    func reloadData() {
        
    }
    
    
    // 移除所有项目
    func removeAllItems() {
        for item in self.currentItemsArray {
//            item.delegate = nil
            item.removeFromSuperview()
            self.itemsPool.append(item)
        }
        self.currentItemsArray.removeAll()
    }
    
    
    //
    func createItem() -> YTPhotoPickerItem {
        if self.itemsPool.isEmpty {
            let item: YTPhotoPickerItem = YTPhotoPickerItem.init(frame: CGRect(x: 0, y: 0, width: self.itemSize, height: self.itemSize))
            return item
        } else {
            let item: YTPhotoPickerItem = self.itemsPool.popLast()!
            return item
        }
    }
    
    

}
