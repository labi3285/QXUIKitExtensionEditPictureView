//
//  ViewController.swift
//  Project
//
//  Created by labi3285 on 2019/11/1.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXUIKitExtension

class ViewController: QXTableViewController<Any> {
    
    lazy var pictureCell: QXSettingTitlePictureCell = {
        let e = QXSettingTitlePictureCell()
        e.titleLabel.text = "选择图片"
        return e
    }()
    lazy var picturesCell: QXSettingPicturesCell = {
        let e = QXSettingPicturesCell()
        return e
    }()
   
    lazy var section: QXTableViewSection = {
        let e = QXTableViewSection([
            self.pictureCell,
            self.picturesCell,
        ], QXSettingSeparateHeaderView(), QXSettingSeparateFooterView())
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        contentView.backColor = QXColor.dynamicBackgroundGray
        tableView.sections = [section]
        
        /* Info.plist
        <key>NSMicrophoneUsageDescription</key>
        <string>$(PRODUCT_NAME)请求访问话筒。</string>
        <key>NSCameraUsageDescription</key>
        <string>$(PRODUCT_NAME)请求访问摄像头。</string>
        <key>NSPhotoLibraryUsageDescription</key>
        <string>$(PRODUCT_NAME)请求访问媒体库。</string>
         */
    }

}

