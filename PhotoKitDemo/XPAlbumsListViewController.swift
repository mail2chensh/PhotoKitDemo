//
//  XPAlbumsListViewController.swift
//  PhotoKitDemo
//
//  Created by dev on 2017/12/12.
//  Copyright © 2017年 iAskDoc Technology. All rights reserved.
//

import UIKit
import Photos


class XPAlbumsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var tableView: UITableView!
    

    
    // =================================
    // MARK:
    // =================================

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.navigationItem.title = "相册"
        //
        self.addNavigationBarButton()
        //
        self.initTableView()
        //
        self.addTableViewConstraints()
        //
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initTableView() {
        //
        self.tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), style: .plain)
        self.view.addSubview(self.tableView)
        //
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 100
        self.tableView.register(UINib.init(nibName: "XPAlbumsTableViewCell", bundle: nil), forCellReuseIdentifier: "XPAlbumsTableViewCell")
        
    }
    
    func addTableViewConstraints() {
        let topConstraint = NSLayoutConstraint.init(item: self.tableView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint.init(item: self.tableView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint.init(item: self.tableView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint.init(item: self.tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
    }
    
    
    // =================================
    // MARK:
    // =================================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return XPhotoPickerManger.shared.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XPAlbumsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "XPAlbumsTableViewCell", for: indexPath) as! XPAlbumsTableViewCell
        
        //
        let assetCollection: PHAssetCollection = XPhotoPickerManger.shared.albums[indexPath.row]
        if let title: String = assetCollection.localizedTitle {
            if let type: XPhotoAlbumType = XPhotoAlbumType(rawValue: title) {
                cell.titleLabel.text = type.locolTitle()
            } else {
                cell.titleLabel.text = title
            }
        }
        let albumAssets: [PHAsset] = XPhotoPickerManger.shared.assetsInAlbum[indexPath.row]
        cell.countLabel.text = "\(albumAssets.count)"
        //
        XPhotoPickerManger.shared.getLastPhoto(inAlbum: assetCollection, completion: {
            [weak cell] (image) in
            if image != nil {
                cell?.iconImageView.image = image
            }
        })
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //
        XPhotoPickerManger.shared.currentSelectedIndex = indexPath.row
        let albumVC = XPAlbumViewController()
        self.navigationController?.pushViewController(albumVC, animated: true)
    }

    
    // =================================
    // MARK:
    // =================================
    
    func addNavigationBarButton() {
        if self.navigationItem.leftBarButtonItem == nil {
            let cancelButton: UIBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(backButtonDidTouch(_:)))
            self.navigationItem.leftBarButtonItem = cancelButton
        }
    }
    
    @objc func backButtonDidTouch(_ sender: Any) {
        if let navController: XPhotoPickerViewController = self.navigationController as? XPhotoPickerViewController {
            navController.pickerViewControllerDismiss()
        }
    }
    
    
    

}
