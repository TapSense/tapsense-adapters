//
//  TapSenseNativeAdsWorker.h
//  Copyright (c) 2014 TapSense Inc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

/**
 * A worker handles ad requests and inserts native ads into a given UITableView.
 * A cell class and UITableView must be registered to display ads correctly.
 */

@interface TapSenseNativeAdsWorker : UITableViewController

-(void) registerWithTableView: (UITableView *) tableView cellClass:(Class) cellClass;

- (id)initWithPubId:(NSString *) pubId
              appId:(NSString *) appId
             secret:(NSString *) secret
           testMode:(BOOL) testMode
        placementId:(NSString *) placement
          targeting:(NSDictionary *) targetingParameters;

@end

