//
//  YTAlbumListTableViewController.swift
//  PhotoKitDemo
//
//  Created by Chensh on 2017/5/8.
//  Copyright © 2017年 Chensh. All rights reserved.
//

import UIKit
import Photos

class YTAlbumListTableViewController: UITableViewController {
    
    
    var dataArray: [(PHCollection, Int)] = []
    
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var topLevelUserConllections: PHFetchResult<PHCollection>!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "相簿"
        
        self.tableView.register(UINib.init(nibName: "YTAlbumListTableViewCell", bundle: nil), forCellReuseIdentifier: "YTAlbumListTableViewCell")
        self.tableView.estimatedRowHeight = 80
        self.tableView.separatorStyle = .none
        
        //
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        // 列出所有相册智能相册
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        // 列出所有用户创建的相册
        topLevelUserConllections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        for index in 0..<smartAlbums.count {
            let collection = smartAlbums.object(at: index)
            let result: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection, options: nil)
            if result.count > 0 {
                self.dataArray.append((collection, result.count))
            }
        }
        for index in 0..<topLevelUserConllections.count {
            let collection = topLevelUserConllections.object(at: index)
            let result: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection as! PHAssetCollection, options: nil)
            if result.count > 0 {
                self.dataArray.append((collection, result.count))
            }
        }
        
        self.tableView.reloadData()
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: YTAlbumListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YTAlbumListTableViewCell", for: indexPath) as! YTAlbumListTableViewCell

        let (collection, count) = self.dataArray[indexPath.row]
        cell.nameLabel.text = self.transformAlbumTitle(collection.localizedTitle!)
        cell.countLabel.text = String(count)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    // MARK: 
    
    func transformAlbumTitle(_ title: String) -> String {
        switch title {
        case "Slo-mo":
            return "慢动作"
        case "Recently Added":
            return "最近添加"
        case "Favorites":
            return "收藏"
        case "Recently Deleted":
            return "最近删除"
        case "Videos":
            return "视频"
        case "All Photos":
            return "所有照片"
        case "Selfies":
            return "自拍"
        case "Screenshots":
            return "屏幕快照"
        case "Camera Roll":
            return "相机胶卷"
        case "Hidden":
            return "隐藏"
        case "Time-lapse":
            return "时刻"
        case "Bursts":
            return "精选"
        case "Panoramas":
            return "全景"
        default:
            return title
        }
    }
    
}
