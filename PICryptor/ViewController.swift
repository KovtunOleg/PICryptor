//
//  ViewController.swift
//  PICryptor
//
//  Created by Oleg Kovtun on 12.06.17.
//  Copyright © 2017 Oleg Kovtun. All rights reserved.
//

import UIKit
import PICryptor
import SkyS3Sync

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView?
    @objc weak var s3SyncManager: SkyS3SyncManager?
    
    @objc lazy var encryptedFilename: String? = {
        let unencryptedFilename = "test.json"
        
        // encrypt the filename, to search it on disk
        guard let encryptedFilename = unencryptedFilename.rc4base16Encrypted() else {
            print("failed to encrypt filename")
            return nil
        }
        print("we requested an unencrypted filename: \(unencryptedFilename), but we store files with encrypted filenames, so here is an encrypted form: \(encryptedFilename)\n\n")
        
        return encryptedFilename
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didChangeResource(notification:)), name: NSNotification.Name.SkyS3SyncDidUpdateResource, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didChangeResource(notification:)), name: NSNotification.Name.SkyS3SyncDidRemoveResource, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didChangeResource(notification:)), name: NSNotification.Name.SkyS3SyncDidCopyOriginalResource, object: nil)
        
        // load data from the bundle
        refresh(encryptedFilename: encryptedFilename!)
    }
    
    // MARK: - Actions
    
    @objc func refresh(encryptedFilename: String) {
        
        // form resource file URL
        guard let URL = s3SyncManager?.url(forResource: encryptedFilename, withExtension: nil) else {
            print("failed to form resource file URL")
            return
        }
        
        // load the data from file
        guard let dataIn = try? Data(contentsOf: URL) else {
            print("failed to load data from URL: \(URL)")
            return
        }
        
        // decrypt it
        guard let dataOut = dataIn.rc4Decrypted() else {
            print("failed to decrypt data")
            return
        }
        
        // form a string to output (finally), in reality we would decode json instead of forming a string
        guard let stringOut = String(data: dataOut, encoding: .utf8) else {
            print("shit happens, could not form a string out of data :(")
            return
        }
        
        textView?.text = stringOut
    }
    
    // MARK: - Notifications
    
    @objc func didChangeResource(notification: Notification) {
        let fileName = notification.userInfo?[SkyS3ResourceFileName] as! String

        if (encryptedFilename?.contains(fileName))! {
            self.refresh(encryptedFilename: fileName)
        }
    }
}

