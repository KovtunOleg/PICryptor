//
//  PICryptor.swift
//  PICryptor
//
//  Created by Eugene Dorfman on 8/6/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation
import CommonCrypto
import SwiftBase58

fileprivate enum PICryptorError: Error {
    case unknownError
    case nilSecretKeyError
    case emptySecretKeyError
}

/**
 PICryptor is a convinient tool to encrypt and decrypt your data using RC4 encryption API for iOS.
 */
@objc open class PICryptor : NSObject {

    /**
     Raw key material used for RC4 encryption algorithm.
     */
    public static var secretKey: Data?
    
    fileprivate var ref: CCCryptorRef
    
    deinit {
        CCCryptorRelease(ref)
    }

    fileprivate init(for operation: CCOperation) throws {
        guard let secretKey = PICryptor.secretKey else {
            throw PICryptorError.nilSecretKeyError
        }
        
        guard !secretKey.isEmpty else {
            throw PICryptorError.emptySecretKeyError
        }
        
        let cryptorRefPointer = UnsafeMutablePointer<CCCryptorRef?>.allocate(capacity: 1)
        secretKey.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            let _ = CCCryptorCreate(operation,
                                    CCAlgorithm(kCCAlgorithmRC4),
                                    CCOptions(kCCOptionECBMode),
                                    bytes,
                                    secretKey.count,
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
 * encrypting a string and outputting a base58:
 * echo -n <infilename> | openssl rc4 -nosalt -K E86A53E1E6B5E1321615FD9FB90A7CAA | base58
 * 
 * decrypting contents of a file:
 * openssl rc4 -d -in <infile> -nosalt -K E86A53E1E6B5E1321615FD9FB90A7CAA  > <outfile>
 *
 * decyrpting a base58 filename:
 * echo -n <infilename> | base58 -d | openssl rc4 -d -nosalt -K E86A53E1E6B5E1321615FD9FB90A7CAA
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
     Get RC4+Base58 encrypted string representation.
     */
    public func rc4Base58Encrypted() -> NSString? {
        if let data = data(using: String.Encoding.utf8.rawValue),
            let encrypted = RC4Cryptor.encrypt(data: data) {
            let base58 = SwiftBase58.encode([UInt8](encrypted))
            return base58 as NSString
        }
        return nil
    }
    
    /**
     Get RC4+Base58 decrypted string representation.
     */
    public func rc4Base58Decrypted() -> NSString? {
        let base58 = Data(bytes: SwiftBase58.decode(self as String))
        if let decrypted = RC4Cryptor.decrypt(data: base58) {
            return String(data: decrypted, encoding: .utf8) as NSString?
        }
        return nil
    }
}

public extension String {
    
    /**
     Get RC4+Base58 encrypted string representation.
     */
    public func rc4Base58Encrypted() -> String? {
        if let data = data(using: .utf8),
            let encrypted = RC4Cryptor.encrypt(data: data) {
            let base58 = SwiftBase58.encode([UInt8](encrypted))
            return base58
        }
        return nil
    }
    
    /**
     Get RC4+Base58 decrypted string representation.
     */
    public func rc4Base58Decrypted() -> String? {
        let base58 = Data(bytes: SwiftBase58.decode(self))
        if let decrypted = RC4Cryptor.decrypt(data: base58) {
            return String(data: decrypted, encoding: .utf8)
        }
        return nil
    }
}

