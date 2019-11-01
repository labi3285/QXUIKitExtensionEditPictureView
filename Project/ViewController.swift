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
        let one = QXSettingTitlePictureCell()
        one.titleLabel.text = "选择图片"
        return one
    }()
    lazy var picturesCell: QXSettingPicturesCell = {
        let one = QXSettingPicturesCell()
        return one
    }()
   
    lazy var section: QXTableViewSection = {
        let one = QXTableViewSection([
            self.pictureCell,
            self.picturesCell,
        ], QXSettingSeparateHeaderView(), QXSettingSeparateFooterView())
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        view.qxBackgroundColor = QXColor.backgroundGray
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

