//
//  XPAlbumViewController.swift
//  PhotoKitDemo
//
//  Created by dev on 2017/12/13.
//  Copyright © 2017年 iAskDoc Technology. All rights reserved.
//

import UIKit
import Photos


class XPAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, XPAlbumCollectionViewCellDelegate {
    
    var collectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout!
    var selectedButton: UIBarButtonItem!
    
    
    private var lineOfItem: Int = 4
    private let ScreenWidth5_5: CGFloat = 1080
    private var itemSize: CGSize!

    private var cacheImages: [Int: UIImage] = [:] // 本页缓存
    private var originImages: [Int: UIImage] = [:] // 原图缓存
    
    private var waitLoadingCount: Int = 0 // 等待数目
    
    var selectedArray: [IndexPath] = []

    

    
    
    // =================================
    // MARK:
    // =================================
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        let title = XPhotoPickerManger.shared.currentSelectedAlbumTitle()
        if let type: XPhotoAlbumType = XPhotoAlbumType(rawValue: title) {
            self.navigationItem.title = type.locolTitle()
        } else {
            self.navigationItem.title = title
        }
        //
        self.addNavigationBarRightButton()
        //
        self.initCollectionView()
        //
        self.addConstraints()
        //
        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCollectionView() {
        //
        let windowWidth = UIScreen.main.bounds.size.width
        if windowWidth > ScreenWidth5_5 {
            lineOfItem = 5
        }
        let itemWidth: CGFloat = windowWidth / CGFloat(lineOfItem)
        itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        
        //
        flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        //
        self.collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: windowWidth, height: UIScreen.main.bounds.size.height), collectionViewLayout: self.flowLayout)
        self.collectionView.backgroundColor = .white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "XPAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "XPAlbumCollectionViewCell")
        self.view.addSubview(self.collectionView)
        
    }
    
    func addConstraints() {
        let topConstraint = NSLayoutConstraint.init(item: self.collectionView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint.init(item: self.collectionView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint.init(item: self.collectionView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint.init(item: self.collectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
    }
    
    // =================================
    // MARK:
    // =================================
    
    func addNavigationBarRightButton() {
        selectedButton = UIBarButtonItem.init(title: "选择", style: .plain, target: self, action: #selector(navigationBarRightButtonDidTouch(_:)))
        self.navigationItem.rightBarButtonItem = selectedButton
        self.updateRightButton()
    }
    
    func updateRightButton() {
        if self.selectedArray.count == 0 {
            selectedButton.title = "选择"
            selectedButton.isEnabled = false
        } else {
            selectedButton.title = "选择(\(self.selectedArray.count))"
            selectedButton.isEnabled = true
        }
    }
    
    @objc func navigationBarRightButtonDidTouch(_ sender: Any) {
        if self.waitLoadingCount != 0 {
            debugPrint("wait……")
            self.perform(#selector(navigationBarRightButtonDidTouch(_:)), with: nil, afterDelay: 0.1)
        } else {
            if let navController: XPhotoPickerViewController = self.navigationController as? XPhotoPickerViewController {
                let result = self.getOriginImagesOfSelected()
                navController.pickerViewControllerFinish(images: result)
            }
        }
    }
    
    
    
    // =================================
    // MARK:
    // =================================
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return XPhotoPickerManger.shared.currentSelectedAssetsInAlbum().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: XPAlbumCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "XPAlbumCollectionViewCell", for: indexPath) as! XPAlbumCollectionViewCell
        cell.indexPath = indexPath
        cell.cellDelegate = self
        
        //
        if let image = self.cacheImages[indexPath.row] {
            cell.thumbnailImageView.image = image
        } else {
            let asset: PHAsset = XPhotoPickerManger.shared.currentSelectedAssetsInAlbum()[indexPath.row]
            XPhotoPickerManger.shared.getPhoto(asset: asset, targetSize: XPhotoPickerManger.shared.PreviewImageSize) {
                (image) in
                if image != nil {
                    self.cacheImages[indexPath.row] = image
                }
                cell.thumbnailImageView.image = image
            }
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // =================================
    // MARK:
    // =================================
    
    func albumCollectionViewCell(cell: XPAlbumCollectionViewCell, didSelectedAtIndexPath indexPath: IndexPath, selectedStatus status: Bool) {
        //
        if status {
            // maxCount
            if self.selectedArray.count == XPhotoPickerManger.shared.maxSelectedCount {
                //
                cell.tickButton.isSelected = false
                //
                self.showAlertView(title: "图片数量限制", message: "您最多只能选择\(XPhotoPickerManger.shared.maxSelectedCount)张图片")
                return
            }
            
            // add
            self.selectedArray.append(indexPath)
            
            // request image
            self.waitLoadingCount += 1
            let asset: PHAsset = XPhotoPickerManger.shared.currentSelectedAssetsInAlbum()[indexPath.row]
            XPhotoPickerManger.shared.getPhoto(asset: asset, targetSize: XPhotoPickerManger.shared.ScreenImageSize) {
                (image) in
                if image != nil {
                    self.originImages[indexPath.row] = image
                    self.waitLoadingCount -= 1
                }
            }
            
        } else {
            // remove
            for i in 0..<self.selectedArray.count {
                let item = self.selectedArray[i]
                if item == indexPath {
                    self.selectedArray.remove(at: i)
                    break
                }
            }
        }
        //
        self.updateRightButton()
    }
    
    func showAlertView(title: String, message: String) {
        let alertView: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    // =================================
    // MARK:
    // =================================
    
    func getOriginImagesOfSelected() -> [UIImage] {
        //
        var result: [UIImage] = []
        //
        for indexPath in self.selectedArray {
            if let image = self.originImages[indexPath.row] {
                result.append(image)
            } else {
                //
                debugPrint("get image fail: \(indexPath.row)")
            }
        }
        //
        return result
    }
    
    deinit {
        self.cacheImages = [:]
        self.originImages = [:]
    }
    
    

}
