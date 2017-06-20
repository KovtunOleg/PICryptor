# PICryptor

[![Version](https://img.shields.io/github/tag/KovtunOleg/PICryptor.svg)](https://github.com/KovtunOleg/PICryptor/tags)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

PICryptor is a convinient tool to encrypt and decrypt your data using RC4 encryption API for iOS with [Carthage](https://github.com/carthage/carthage) support. RC4 is the fastest cipher, although insecure, but well suitable for many purposes. It works well for openssl.

Released under the [MIT license](LICENSE). Enjoy.


## Installation

1.  [Carthage](https://github.com/carthage/carthage) is the recommended way to install PICryptor. Add the following to your Cartfile:

	``` ruby
	git "git@gitlab.postindustria.com:ios/PICryptor.git"
	```

2.  Run in terminal:
	``` bash
	carthage update --platform iOS
	```

3. Then add `PICryptor` and `CommonCrypto` frameworks to *Link Binary with libraries* and *Embed Frameworks* build phases.
![Alt text](https://monosnap.com/file/nGhqirq3NAgt8rr6KghJ4Ye8UQ3ZMY.png)

4. Enable embedded Swift content (for Objective C apps) in the project settings.
![Alt text](https://monosnap.com/file/Rmyn6j1mxcrrI2QgVDCOqyWeZShftQ.png)

5. For UnitTests/UITests targets Look for the *Runpath Search Paths* build setting and add to it `"$(PROJECT_DIR)/Carthage/Build/iOS"`
![Alt text](https://monosnap.com/file/3JI8lY8Bj6xjiIRHiTCUtY71Z3csi4.png)

6. Run `install.sh` script provided with PICryptor framework with your own secret key as a parameter, it will generate all needed symlinks and `picryptor_key.swift` which you need to add into your project:
![Alt text](https://monosnap.com/file/3tuWaXoHxt5ZQA8lYbNeANTZa9Djaw.png)
	``` bash
	cd <path_to_your_project>/Carthage/Build/iOS/PICryptor.framework
	sh install.sh E86A53E1E6B5E1321615FD9FB90A7CAA
	```

## Usage
1.  First of all you need to set PICryptor secret key from the generated `picryptor_key.swift` file in the `application(:didFinishLaunchingWithOptions:)` method.

    ``` swift
    // Swift
    
    import PICryptor
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        PICryptor.secretKey = PICryptorSecretKey
        return true
    }
    ```

    ``` objc
    // Objective-c
    
    #import <PICryptor/PICryptor-Swift.h>
    
    - (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        PICryptor.secretKey = NSData.piCryptorSecretKey;
        return YES;
    }
    ```

2.  And now, all you need is just to use several convenience methods which extends `NSData`/`Data` and `NSString`/`String` foundation classes.

    ``` swift
    // Swift
    
    import PICryptor
    
    let encryptedString = unencryptedString.rc4Base64Encrypted()
    
    let decryptedString = encryptedString.rc4Base64Decrypted()

    let unencryptedData = encryptedData.rc4Decrypted()

    let encryptedData = unencryptedData.rc4Encrypted()
    ```
    
    ``` objc
    // Objective-c
    
    #import <PICryptor/PICryptor-Swift.h>
    
    NSString *encryptedString = [unencryptedString rc4Base64Encrypted];
    
    NSString *decryptedString = [encryptedString rc4Base64Decrypted];

    NSData *unencryptedData = [encryptedData rc4Decrypted];

    NSData *encryptedData = [unencryptedData rc4Encrypted];
    ```

3. If you want to encrypt your bundle files, you should add a new run script phase in your project. And locate it before `Copy Bundle Resources` phase, so your created encrypted files will be added to the bundle successfully.
    * The script (please, don't forget to change `UNENCRYPTED_DIR_PATH`, `ENCRYPTED_DIR_PATH` and `SECRET_KEY` with yours)

    ``` bash
	#!/bin/bash
	
	export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
	
	UNENCRYPTED_DIR_PATH="${SRCROOT}/${PROJECT_NAME}/s3_bucket_unencrypted" # your own path to unencrypted folder
	ENCRYPTED_DIR_PATH="${SRCROOT}/${PROJECT_NAME}/s3_bucket" # your own path to encrypted folder
	SECRET_KEY=E86A53E1E6B5E1321615FD9FB90A7CAA # your own secret key for openssl (can be found in picryptor_key.swift file)
	
	# create encrypted dyrectory if needed
	mkdir -p $ENCRYPTED_DIR_PATH
	
	# encrypt all files in unencrypted directory
	cd $UNENCRYPTED_DIR_PATH
	for FILE_NAME in *
		do
		enc_file.sh $PWD/$FILE_NAME $ENCRYPTED_DIR_PATH $SECRET_KEY
	done
	
	```
    &#8291;
    * Put all the files which you want to encrypt in one folder and add it as a reference folder into your project (notice don't add it to any project targets!).

    ![Alt text](https://monosnap.com/file/RDftKTsOvlDcElTLsapm5F4IchzvEU.png)
    * Create an empty folder for encrypted files and also add it as a reference folder into your project (notice add it to the app target!).

    ![Alt text](https://monosnap.com/file/4JarRmRgeK47dKaGs5OsNm7ahTwOjm.png)
    * So when you are done, everything should look like this.

    ![Alt text](https://monosnap.com/file/Ovi5MPI94YJAdV216m9O3EqNfqjbDe.png)

4. If you want to upload your unecrypted files to Amazon S3 as encrypted in one action in the terminal: 

    ``` bash
    s3cmd_put_enc.sh test.json s3://bucket E86A53E1E6B5E1321615FD9FB90A7CAA
    ```

For more information see our PICryptor test app (please, don't forget to change `SkyS3SyncManager` configuration with yours).

Good luck! )