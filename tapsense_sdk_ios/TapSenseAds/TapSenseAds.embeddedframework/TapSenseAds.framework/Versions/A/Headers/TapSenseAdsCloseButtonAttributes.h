//
//  TapSenseAdsCloseButtonAttributes.h
//  Copyright (c) 2014 TapSense Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TapSenseAdsCloseButtonAttributes : NSObject

@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) int waitTime;
@property (nonatomic) int x;
@property (nonatomic) int y;
@property (nonatomic, strong) NSString *imageUrl;

- (id)initWithWidth: (int) width
             height: (int) height
           waitTime: (int) waitTime
                  x: (int) x
                  y: (int) y
           imageUrl: (NSString*) imageUrl;

@end
