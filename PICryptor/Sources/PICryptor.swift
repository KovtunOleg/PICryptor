//
//  PICryptor.swift
//  PICryptor
//
//  Created by Eugene Dorfman on 8/6/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation
import CommonCrypto

fileprivate enum PICryptorError: Error {
    case unknownError
    case emptyKeyError
}

/**
 PICryptor is a convinient tool to encrypt and decrypt your data using RC4 encryption API for iOS.
 */
@objc open class PICryptor : NSObject {

    fileprivate var ref: CCCryptorRef
    
    deinit {
        CCCryptorRelease(ref)
    }

    fileprivate init(for operation: CCOperation) throws {
        guard !PICryptorKey.isEmpty else {
            throw PICryptorError.emptyKeyError
        }
        
        let cryptorRefPointer = UnsafeMutablePointer<CCCryptorRef?>.allocate(capacity: 1)
        PICryptorKey.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            let _ = CCCryptorCreate(operation,
                                    CCAlgorithm(kCCAlgorithmRC4),
                                    CCOptions(kCCOptionECBMode),
                                    bytes,
                                    PICryptorKey.count,
                                    nil,
                                    cryptorRefPointer
            )
        }
        
        ref = cryptorRefPointer.pointee!
    }
    
    fileprivate func update(with data: Data) -> Data? {
        let dataOut = data.withUnsafeBytes { (body: UnsafePointer<UInt8>) -> Data? in
            let dataOutMovedPointer = UnsafeMutablePointer<Int>.allocate(capacity: 1)
            let dataOutPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
            CCCryptorUpdate(ref, body, data.count, dataOutPointer, data.count, dataOutMovedPointer)
            let dataOut = Data(bytes: dataOutPointer, count: dataOutMovedPointer.pointee)
            return dataOut
        }
        return dataOut
    }
}

/**
 * This is a public RC4 encryption API
 * openssl encryption of a file content:
 * openssl rc4 -in <infile> -nosalt -K E86A53E1E6B5E1321615FD9FB90A7CAA  > <outfile>
 * 
 * encrypting a string and outputting a base64:
 * echo -n "mystring" | openssl rc4 -nosalt -K E86A53E1E6B5E1321615FD9FB90A7CAA | base64
 * 
 * decrypting contents of a file:
 * openssl rc4 -d -in <infile> -nosalt -K E86A53E1E6B5E1321615FD9FB90A7CAA  > <outfile>
 *
 * decyrpting a base64 filename:
 * echo -n "VQK2oAJKwFQSMTSJCJFYlKRE01L5Yn30r6w=" | base64 -D | openssl rc4 -d -nosalt -K E86A53E1E6B5E1321615FD9FB90A7CAA
 */
fileprivate enum RC4Cryptor {
    public static func decrypt(data: Data) -> Data? {
        do {
            let decryptor = try PICryptor(for: CCOperation(kCCDecrypt))
            return decryptor.update(with: data)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }

    public static func encrypt(data: Data) -> Data? {
        do {
            let encryptor = try PICryptor(for: CCOperation(kCCEncrypt))
            return encryptor.update(with: data)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
}

/*
 * Convenience extensions
 */

public extension NSData {
    /**
     Get RC4 encrypted data representation.
     */
    public func rc4Encrypted() -> NSData? {
        return RC4Cryptor.encrypt(data: self as Data)! as NSData
    }
    
    /**
     Get RC4 decrypted data representation.
     */
    public func rc4Decrypted() -> NSData? {
       return RC4Cryptor.decrypt(data: self as Data)! as NSData
    }
}

public extension Data {
    /**
     Get RC4 encrypted data representation.
     */
    public func rc4Encrypted() -> Data? {
        return RC4Cryptor.encrypt(data: self)
    }
    
    /**
     Get RC4 decrypted data representation.
     */
    public func rc4Decrypted() -> Data? {
        return RC4Cryptor.decrypt(data: self)
    }
}

public extension NSString {
    /**
     Get Rc4+Base64 string representation.
     */
    public func rc4Base64Encrypted() -> NSString? {
        if let data = self.data(using: String.Encoding.utf8.rawValue),
            let encrypted = RC4Cryptor.encrypt(data: data) {
            return encrypted.base64EncodedString() as NSString
        }
        return nil
    }
}

public extension String {
    /**
     Get Rc4+Base64 string representation.
     */
    public func rc4Base64Encrypted() -> String? {
        if let data = self.data(using: .utf8),
            let encrypted = RC4Cryptor.encrypt(data: data) {
            return encrypted.base64EncodedString()
        }
        return nil
    }
}

