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

#import "SkyS3Directory.h"
#import "SkyS3ResourceData.h"
#import "SkyS3ResourceURLProvider.h"
#import "SkyS3Sync.h"
#import "SkyS3SyncManager.h"

FOUNDATION_EXPORT double SkyS3SyncVersionNumber;
FOUNDATION_EXPORT const unsigned char SkyS3SyncVersionString[];

