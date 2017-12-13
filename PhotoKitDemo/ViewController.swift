//
//  ViewController.swift
//  PhotoKitDemo
//
//  Created by dev on 2017/12/12.
//  Copyright © 2017年 iAskDoc Technology. All rights reserved.
//

import UIKit
import Photos


class ViewController: UIViewController, XPhotoPickerViewControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.test()
        XPhotoPickerManger.shared.getLastPhotoInCameraRoll { (image) in
            self.imageView.image = image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // =================================
    // MARK:
    // =================================
    
//    func test() {
//        // 列出所有相册智能相册
//        let smartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
//
//        for index in 0..<smartAlbums.count {
//            // 获取一个相册（PHAssetCollection）
//            let assetCollection: PHAssetCollection = smartAlbums[index]
//
//
//            if let title: String = assetCollection.localizedTitle, title == "Camera Roll" {
//                // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset
//                let options: PHFetchOptions = PHFetchOptions.init()
//                options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//                let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: options)
//                //
//                for jndex in 0..<fetchResult.count {
//                    let asset: PHAsset = fetchResult[jndex]
//                    if asset.mediaType != .image {
//                        continue
//                    }
//                    let requestOptions: PHImageRequestOptions = PHImageRequestOptions.init()
//                    requestOptions.isNetworkAccessAllowed = false
//                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 80, height: 80), contentMode: .aspectFill, options: requestOptions, resultHandler: {
//                        [weak self] (image, info) in
//                        if image != nil, info != nil, let dict = info as? [String : Any] {
//                            let cancel = dict[PHImageCancelledKey] as? Bool
//                            let errorKey = dict[PHImageErrorKey] as? Bool
//                            let degrade = dict[PHImageResultIsDegradedKey] as? Bool
//                            if (cancel == nil || !cancel!) && (errorKey == nil || !errorKey!) && (degrade == nil || !degrade!) {
//                                self?.imageView.image = image
//                            }
//                        }
//                    })
//                    break
//                }
//            }
//
//        }
//    }
    
    
    
    @IBAction func buttonDidTouch(_ sender: Any) {
        
        let photoPickerVC = XPhotoPickerViewController(maxCount: 9)
        photoPickerVC.pickerDelegate = self
        self.present(photoPickerVC, animated: true, completion: nil)
        
    }
    
    func photoPickerViewControllerDidFinished(images: [UIImage]) {
        debugPrint("images: \(images.count)")
    }

}

