#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AFAmazonS3Manager.h"
#import "AFAmazonS3RequestSerializer.h"
#import "AFAmazonS3ResponseSerializer.h"

FOUNDATION_EXPORT double AFAmazonS3ManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char AFAmazonS3ManagerVersionString[];

