// this is an auto generated file

 
import Foundation
 
// for openssl you use: -K E86A53E1E6B5E1321615FD9FB90A7CAA 
let PICryptorSecretKey = Data(bytes: [0xE8, 0x6A, 0x53, 0xE1, 0xE6, 0xB5, 0xE1, 0x32, 0x16, 0x15, 0xFD, 0x9F, 0xB9, 0x0A, 0x7C, 0xAA])

public extension NSData {
    public static func piCryptorSecretKey() -> NSData {
        return PICryptorSecretKey as NSData
    }
}
