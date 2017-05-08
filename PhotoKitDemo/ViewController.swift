//
//  ViewController.swift
//  PhotoKitDemo
//
//  Created by Chensh on 2017/5/8.
//  Copyright © 2017年 Chensh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonDidTouch(_ sender: UIButton) {
        
        let albumListVC : YTAlbumListTableViewController = YTAlbumListTableViewController()
        self.navigationController?.pushViewController(albumListVC, animated: true)
        
    }

}

