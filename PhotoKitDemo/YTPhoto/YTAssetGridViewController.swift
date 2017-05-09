//
//  YTAssetGridViewController.swift
//  PhotoKitDemo
//
//  Created by dev on 2017/5/9.
//  Copyright © 2017年 Chensh. All rights reserved.
//

import UIKit
import Photos


class YTAssetGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let itemSize: CGFloat = UIScreen.main.bounds.width / 4
    
    @IBOutlet weak var collectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout!
    
    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        collectionView.collectionViewLayout = flowLayout
        
        //
        collectionView .register(UINib.init(nibName: "YTAssetGridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "YTAssetGridCollectionViewCell")
        
        //
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollection Delegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YTAssetGridCollectionViewCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }

}
