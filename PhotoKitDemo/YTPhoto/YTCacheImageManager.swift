//
//  YTCacheImageManager.swift
//  PhotoKitDemo
//
//  Created by Chensh on 2017/5/9.
//  Copyright © 2017年 Chensh. All rights reserved.
//

import UIKit
import Photos

class YTCachingImageManager: NSObject {
    
    static var sharedInstance: YTCachingImageManager = YTCachingImageManager()
    
    var cacheImageManager: PHCachingImageManager!
    
    var maxSelectedCount: Int = 1 // 选择照片数量
    
    var selectedArray: [UIImage] = []
    
    override init() {
        cacheImageManager = PHCachingImageManager()
    }
    

}
