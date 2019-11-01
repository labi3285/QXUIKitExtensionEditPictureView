//
//  AppDelegate.swift
//  Project
//
//  Created by labi3285 on 2019/11/1.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXUIKitExtension

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let vc = ViewController()
        let nav = QXNavigationController(rootViewController: vc)
        let win = UIWindow.qxInitKeyWindow(nav, &window)
        win.backgroundColor = UIColor.white

        return true
    }

}

