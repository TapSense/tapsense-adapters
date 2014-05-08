//
//  TSAdView.h
//  Copyright (c) 2014 TapSense. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TS_BANNER_SIZE           CGSizeMake(320, 50)
#define TS_MEDIUM_RECT_SIZE      CGSizeMake(300, 250)
#define TS_LEADERBOARD_SIZE      CGSizeMake(728, 90)

@protocol TSAdViewDelegate;

@interface TSAdView : UIView

// Required reference to the current root view controller.
// This is used when TSAdView attempts to present new modal view.
@property (nonatomic, strong) UIViewController *rootViewController;

// Ad unit shoudl be set in initWithAdUnitId:...
@property (nonatomic, strong) NSString *adUnitId;

// Set to false to allow manual refreshing by calling -(void) refreshAd
@property (nonatomic)  BOOL shouldAutoRefresh;

/* NOTE: Make sure to set to nil before releasing the ad view */
@property (nonatomic, weak) id<TSAdViewDelegate> delegate;

// Initializes a TSAdView and sets the ad unit id with specified size.
// The ad unit id here should be the same as shown on the dashboard.
- (id) initWithAdUnitId:(NSString *)adUnitId size:(CGSize)size;

// Sends an ad request to the ad server and loads the ad. Ad unit id
// must be set in order to receive a valid ad. Once loadAd is called,
// the ad view will start refreshing if shouldAutoRefresh is true.
- (void) loadAd;

// Call to manually refresh the ad.
- (void) refreshAd;

@end

@protocol TSAdViewDelegate <NSObject>

@optional

- (void) adViewDidLoadAd:(TSAdView *)view;
- (void) adViewDidFailToLoad:(TSAdView *)view;
- (void) adViewWillPresentModalView:(TSAdView *)view;
- (void) adViewDidDismissModalView:(TSAdView *)view;
- (void) adViewWillLeaveApplication:(TSAdView *)view;

@end



