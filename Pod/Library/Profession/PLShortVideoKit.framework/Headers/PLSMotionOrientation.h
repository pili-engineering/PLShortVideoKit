//
//  PLSMotionOrientation.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/10/23.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreGraphics/CoreGraphics.h>

extern NSString *const PLSMotionOrientationChangedNotification;
extern NSString *const PLSMotionOrientationInterfaceOrientationChangedNotification;
extern NSString *const PLSMotionOrientationAccelerometerUpdatedNotification; // this notification will be notified when the DEBUG flag is YES

extern NSString *const kPLSMotionOrientationKey;
extern NSString *const kPLSMotionOrientationDebugDataKey;

@interface PLSMotionOrientation : NSObject

@property (readonly) UIInterfaceOrientation interfaceOrientation;
@property (readonly) UIDeviceOrientation deviceOrientation;
@property (readonly) CGAffineTransform affineTransform;

+ (void)initialize;
+ (PLSMotionOrientation *)sharedInstance;

- (void)startAccelerometerUpdates;
- (void)stopAccelerometerUpdates;

@end
