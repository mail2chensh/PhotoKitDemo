//
//  XPhotoPickerManager.swift
//  PhotoKitDemo
//
//  Created by dev on 2017/12/12.
//  Copyright © 2017年 iAskDoc Technology. All rights reserved.
//

import Foundation
import Photos

typealias XPhotoPickerGetImageCompletion = (_ image: UIImage?) -> ()

enum XPhotoAlbumType: String {
    case videos = "Videos"
    case panorams = "Panoramas"
    case slo_mo = "Slo-mo"
    case favorites = "Favorites"
    case recentlyAdded = "Recently Added"
    case cameraRoll = "Camera Roll"
    case selfies = "Selfies"
    case screenshots = "Screenshots"
    
    func locolTitle() -> String {
        switch self {
        case .videos:
            return "视频"
        case .panorams:
            return "全景照片"
        case .slo_mo:
            return "慢动作"
        case .favorites:
            return "个人收藏"
        case .recentlyAdded:
            return "最近添加"
        case .cameraRoll:
            return "相机胶卷"
        case .selfies:
            return "自拍"
        case .screenshots:
            return "屏幕快照"
        }
    }
}





class XPhotoPickerManger {
    
    static let shared: XPhotoPickerManger = XPhotoPickerManger()
    
    // =================================
    // MARK:
    // =================================
    
    var CacheImageSize: CGSize = CGSize(width: 80, height: 80)
    var PreviewImageSize: CGSize = CGSize(width: 150, height: 150)
    var ScreenImageSize: CGSize = UIScreen.main.bounds.size
    
    
    private var allAlbums: [PHAssetCollection] = []
    private var allAssetsInAlbum: [[PHAsset]] = []
    var albums: [PHAssetCollection] = []
    var assetsInAlbum: [[PHAsset]] = []
    
    var hiddenZeroCountAlbums: Bool = true // 是否需要隐藏资源为0的相册
    var maxSelectedCount: Int = 1 // 最大的选择图片数
    var currentSelectedIndex: Int = 0 // 当前选中的图片资源
    
    // =================================
    // MARK:
    // =================================

    
    init() {
        //
        self.initAlbums()
        //
        self.resetShowAlbums()
    }
    
    func initAlbums() {
        
        // 列出所有相册
        let albums: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        var isCameraRoll: Bool = false
        for index in 0..<albums.count {
            //
            let assetCollection: PHAssetCollection = albums[index]
            if let title: String = assetCollection.localizedTitle, title == XPhotoAlbumType.cameraRoll.rawValue {
                isCameraRoll = true
                self.allAlbums.insert(assetCollection, at: 0)
            } else {
                isCameraRoll = false
                self.allAlbums.append(assetCollection)
            }
            
            
            // 加载每个相册的资源
            let options: PHFetchOptions = PHFetchOptions.init()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: options)
            //
            var albumAssets: [PHAsset] = []
            for jndex in 0..<fetchResult.count {
                let asset: PHAsset = fetchResult[jndex]
                albumAssets.append(asset)
            }
            if isCameraRoll {
                self.allAssetsInAlbum.insert(albumAssets, at: 0)
            } else {
                self.allAssetsInAlbum.append(albumAssets)
            }
        }
    }
    
    
    func resetShowAlbums() {
        if hiddenZeroCountAlbums {
            self.albums = []
            self.assetsInAlbum = []
            //
            for index in 0..<self.allAssetsInAlbum.count {
                let assets = self.allAssetsInAlbum[index]
                if assets.count != 0 {
                    self.albums.append(self.allAlbums[index])
                    self.assetsInAlbum.append(assets)
                }
            }
        } else {
            //
            self.albums = self.allAlbums
            self.assetsInAlbum = self.allAssetsInAlbum
        }
    }
    
    // =================================
    // MARK:
    // =================================
    
    // 获取最后一张图片
    func getLastPhoto(inAlbum album: PHAssetCollection, completion: @escaping XPhotoPickerGetImageCompletion) {
        
        let index = self.albums.index(of: album)
        if index == nil || index! < 0 || index! >= self.assetsInAlbum.count {
            completion(nil)
            return
        }
        
        //
        var isExist: Bool = false
        let assets = self.assetsInAlbum[index!]
        for asset in assets {
            //
            isExist = true
            //
            let requestOptions: PHImageRequestOptions = PHImageRequestOptions.init()
            requestOptions.isNetworkAccessAllowed = false
            PHImageManager.default().requestImage(for: asset, targetSize: self.CacheImageSize, contentMode: .aspectFill, options: requestOptions, resultHandler: {
                (image, info) in
                if image != nil, info != nil, let dict = info as? [String : Any] {
                    let cancel = dict[PHImageCancelledKey] as? Bool
                    let errorKey = dict[PHImageErrorKey] as? Bool
                    let degrade = dict[PHImageResultIsDegradedKey] as? Bool
                    if (cancel == nil || !cancel!) && (errorKey == nil || !errorKey!) && (degrade == nil || !degrade!) {
                        completion(image!)
                    }
                }
            })
            break
        }
        //
        if !isExist {
            completion(nil)
        }
    }
    
    // 获取相机胶卷的最后一张
    func getLastPhotoInCameraRoll(completion: @escaping XPhotoPickerGetImageCompletion) {
        var isExist = false
        for album in self.allAlbums {
            if let title: String = album.localizedTitle, title == XPhotoAlbumType.cameraRoll.rawValue {
                isExist = true
                self.getLastPhoto(inAlbum: album, completion: completion)
                break
            }
        }
        if !isExist {
            completion(nil)
        }
    }
    
    // =================================
    // MARK:
    // =================================
    
    // 返回当前选中的资源集合
    
    func currentSelectedAssetsInAlbum() -> [PHAsset] {
        if currentSelectedIndex < 0 || currentSelectedIndex >= self.assetsInAlbum.count {
            return []
        }
        return self.assetsInAlbum[self.currentSelectedIndex]
    }
    
    // 返回当前选中的相册名
    func currentSelectedAlbumTitle() -> String {
        if currentSelectedIndex < 0 || currentSelectedIndex >= self.albums.count {
            return ""
        }
        let album = self.albums[currentSelectedIndex]
        if let title: String = album.localizedTitle {
            return title
        }
        return ""
    }
    
    // =================================
    // MARK:
    // =================================
    
    
    // 获取资源的预览图片
    func getPhoto(asset: PHAsset, targetSize: CGSize, completion: @escaping XPhotoPickerGetImageCompletion) {
        //
        let requestOptions: PHImageRequestOptions = PHImageRequestOptions.init()
        requestOptions.isNetworkAccessAllowed = false
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions, resultHandler: {
            (image, info) in
            if image != nil, info != nil, let dict = info as? [String : Any] {
                let cancel = dict[PHImageCancelledKey] as? Bool
                let errorKey = dict[PHImageErrorKey] as? Bool
                let degrade = dict[PHImageResultIsDegradedKey] as? Bool
                if (cancel == nil || !cancel!) && (errorKey == nil || !errorKey!) && (degrade == nil || !degrade!) {
                    completion(image!)
                }
            }
        })
    }
    
    
}


