//
//  AppDelegate.swift
//  PICryptor
//
//  Created by Oleg Kovtun on 12.06.17.
//  Copyright © 2017 Oleg Kovtun. All rights reserved.
//

import UIKit
import PICryptor
import SkyS3Sync

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var s3SyncManager: SkyS3SyncManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // configure your sky S3 manager
        s3SyncManager = SkyS3SyncManager.init(s3AccessKey: #(Amazon S3 Access Key),
                                              secretKey: #(Amazon S3 Secret Key),
                                              bucketName: #(Amazon S3 Bucket Name),
                                              originalResourcesDirectory: (Bundle.main.resourceURL?.appendingPathComponent("s3_bucket"))!)
        
        // set s3SyncManager to ViewController using dependency injection
        let viewController = self.window!.rootViewController as! ViewController
        viewController.s3SyncManager = s3SyncManager
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // sync down any updated files from S3
        s3SyncManager?.sync()
    }
}

