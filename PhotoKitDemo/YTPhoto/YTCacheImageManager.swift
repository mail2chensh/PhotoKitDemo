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
    
    override init() {
        cacheImageManager = PHCachingImageManager()
    }
    

}
