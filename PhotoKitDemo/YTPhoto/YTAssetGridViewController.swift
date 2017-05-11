//
//  YTAssetGridViewController.swift
//  PhotoKitDemo
//
//  Created by dev on 2017/5/9.
//  Copyright © 2017年 Chensh. All rights reserved.
//

import UIKit
import Photos


class YTAssetGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, YTAssetGridCollectionViewCellDelegate {

    let itemSize: CGFloat = UIScreen.main.bounds.width / 4
    
    @IBOutlet weak var collectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout!
    
    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!
    
    fileprivate var thumbnailSize: CGSize!
    
    
    
    init(paramCollection: PHAssetCollection) {
        super.init(nibName: "YTAssetGridViewController", bundle: nil)
        self.assetCollection = paramCollection
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //
        flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = flowLayout
        
        //
        collectionView .register(UINib.init(nibName: "YTAssetGridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "YTAssetGridCollectionViewCell")
        
        //
        let scale = UIScreen.main.scale
        thumbnailSize = CGSize(width: itemSize * scale, height: itemSize * scale)
        
        //
        fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
        self.navigationController?.isToolbarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // =====================================
    // MARK: UICollection Delegate
    // =====================================
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: YTAssetGridCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "YTAssetGridCollectionViewCell", for: indexPath) as! YTAssetGridCollectionViewCell
        cell.indexPath = indexPath
        cell.cellDelegate = self
        
        let asset = fetchResult.object(at: indexPath.item)
        
        cell.representedAssetIdentifier = asset.localIdentifier
        YTCachingImageManager.sharedInstance.cacheImageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil) { (image, _) in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image    
            }
            
        }
        
        return cell
    }
    
    
    // =====================================
    // MARK: Cell Delegate
    // =====================================

    func assetGridCollectionViewCellDidSelected(_ cell: YTAssetGridCollectionViewCell, isSelected: Bool) {
        
        if !isSelected {
            YTCachingImageManager.sharedInstance.removeImage(cell.representedAssetIdentifier)
            return
        }
        
        let asset = fetchResult.object(at: cell.indexPath.item)
        
        let options: PHImageRequestOptions = PHImageRequestOptions.init()
        options.isNetworkAccessAllowed = false
        
        YTCachingImageManager.sharedInstance.cacheImageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (image, infoDict) in
            // 排除取消，错误，低清图三种情况，即已经获取到了高清图时，把这张高清图缓存到 _originImage 中
            let downloadFinished: Bool = infoDict![PHImageCancelledKey] == nil && infoDict![PHImageErrorKey] == nil
            if downloadFinished {
                if image != nil {
                    YTCachingImageManager.sharedInstance.selectedArray.append((cell.representedAssetIdentifier, image!))
                }
            }
        }
        
    }
    
    
}
