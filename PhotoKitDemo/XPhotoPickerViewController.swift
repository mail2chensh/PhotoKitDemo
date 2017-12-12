//
//  XPhotoPickerViewController.swift
//  PhotoKitDemo
//
//  Created by dev on 2017/12/12.
//  Copyright © 2017年 iAskDoc Technology. All rights reserved.
//

import UIKit

class XPhotoPickerViewController: UINavigationController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        let albumsList = XPAlbumsListViewController()
        self.pushViewController(albumsList, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
