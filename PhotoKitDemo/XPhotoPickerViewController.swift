//
//  XPhotoPickerViewController.swift
//  PhotoKitDemo
//
//  Created by dev on 2017/12/12.
//  Copyright © 2017年 iAskDoc Technology. All rights reserved.
//

import UIKit

@objc protocol XPhotoPickerViewControllerDelegate: NSObjectProtocol {
    
    @objc optional func photoPickerViewControllerDidCancelSelected()
    
    @objc optional func photoPickerViewControllerDidFinished(images: [UIImage])
    
}



class XPhotoPickerViewController: UINavigationController {
    
    
    var pickerDelegate: XPhotoPickerViewControllerDelegate!
    
    
    // =================================
    // MARK:
    // =================================
    
    convenience init(maxCount: Int = 1) {
        self.init()
        //
        if maxCount > 0 {
            XPhotoPickerManger.shared.maxSelectedCount = maxCount
        }
    }
    
    
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
    
    
    // =================================
    // MARK:
    // =================================
    
    func pickerViewControllerDismiss() {
        if pickerDelegate != nil && pickerDelegate.responds(to: #selector(XPhotoPickerViewControllerDelegate.photoPickerViewControllerDidCancelSelected)) {
            self.pickerDelegate.photoPickerViewControllerDidCancelSelected!()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func pickerViewControllerFinish(images: [UIImage]) {
        if pickerDelegate != nil && pickerDelegate.responds(to: #selector(XPhotoPickerViewControllerDelegate.photoPickerViewControllerDidFinished(images:))) {
            self.pickerDelegate.photoPickerViewControllerDidFinished!(images: images)
        }
        self.dismiss(animated: true, completion: nil)
    }
    


}
