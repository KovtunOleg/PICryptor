//
//  PICryptorTests.swift
//  PICryptorTests
//
//  Created by Oleg Kovtun on 12.06.17.
//  Copyright © 2017 Oleg Kovtun. All rights reserved.
//

import Foundation
import XCTest

class PICryptorTest: XCTestCase {
    
    func testCryptor() {
        
        // set PICryptor secret key
        PICryptor.secretKey = PICryptorSecretKey
        
        // encrypt the filename, to search it on disk
        let encryptedFilename = "test.json".rc4base16Encrypted()
        XCTAssertEqual(encryptedFilename, "4d0ea3b14049d85e1d", "failed to encrypt filename")
        
        // check backwards decryption
        let decryptedFilename = encryptedFilename?.rc4base16Decrypted()
        XCTAssertEqual(decryptedFilename, "test.json", "failed to encrypt filename")
        
        // form resource file URL
        let URL = Bundle(for: PICryptorTest.self).url(forResource: encryptedFilename, withExtension: nil)
        XCTAssertNotNil(URL, "failed to form resource file URL")
        
        // load the data from file
        let dataIn = try? Data(contentsOf: URL!)
        XCTAssertNotNil(dataIn, "failed to load data from URL \(URL!)")
        
        // decrypt it
        let dataOut = dataIn?.rc4Decrypted()
        XCTAssertNotNil(dataOut, "failed to decrypt data")
        
        // form a JSON from decrypted data
        let JSON = try? JSONSerialization.jsonObject(with: dataOut!, options: []) as! [AnyHashable : Any]
        XCTAssertEqual(JSON?["A"] as! String, "test")
        XCTAssertEqual(JSON?["B"] as! Bool, true)
        XCTAssertEqual(JSON?["C"] as! Int, 5)
        
        // check data encryption
        let encData = dataOut?.rc4Encrypted()
        XCTAssertEqual(encData, dataIn, "failed to encrypt data")
    }
}
