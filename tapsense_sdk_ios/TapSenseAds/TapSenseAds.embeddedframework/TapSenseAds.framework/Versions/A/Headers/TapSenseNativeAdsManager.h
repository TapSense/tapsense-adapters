//
//  TapSenseNativeAdsManager.h
//  Copyright (c) 2014 TapSense Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TapSenseNativeAdsWorker.h"
#import "TapSenseNativeAdsCell.h"
#import "TapSenseNativeAdsData.h"

/**
 * TapSenseNativeAdsManager creates TapSenseNativeAdsWorkers. StartWith... method
 * must be called before the manager can create workers. Additionally, the manager
 * provides user targeting capability.
 */

@interface TapSenseNativeAdsManager : NSObject

+ (void)startInTestMode:(BOOL) testMode
              withPubId:(NSString *) publisherId
                  appId:(NSString *) applicationId
                 secret:(NSString *) secretKey;

+ (TapSenseNativeAdsWorker *) getWorkerWithPlacementId : (NSString *) placementId;

+ (void) setHouseholdIncome: (NSString *) income;
+ (void) setGender: (NSString *) gender;
+ (void) setZipCode: (NSString *) zipCode;
+ (void) setEducation: (NSString *) education;

+ (void) enableDebugLog: (BOOL) value;
+ (NSString *) getSDKVersion;

@end
