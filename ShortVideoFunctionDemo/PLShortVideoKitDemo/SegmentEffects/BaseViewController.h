//
//  BaseViewController.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/1.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//


#import <UIKit/UIKit.h>

BOOL hasNotch();

#define iPhoneX_SERIES hasNotch()


typedef enum : NSUInteger {
    //iPhone
    enumDeviceTypeIPhone4,
    enumDeviceTypeIPhone4s,
    enumDeviceTypeIPhone5,
    enumDeviceTypeIPhone5c,
    enumDeviceTypeIPhone5s,
    enumDeviceTypeIPhone6,
    enumDeviceTypeIPhone6Plus,
    enumDeviceTypeIPhone6s,
    enumDeviceTypeIPhone6sPlus,
    enumDeviceTypeIPhoneSE,
    enumDeviceTypeIPhone7,
    enumDeviceTypeIPhone7Plus,
    enumDeviceTypeIPhone8,
    enumDeviceTypeIPhone8Plus,
    enumDeviceTypeIPhoneX,
    enumDeviceTypeIPhoneXS,
    enumDeviceTypeIPhoneXR,
    enumDeviceTypeIPhoneXSMax,
    enumDeviceTypeIPhone11,
    enumDeviceTypeIPhone11Pro,
    enumDeviceTypeIPhone11ProMax,
    enumDeviceTypeIPhoneSE2,
    enumDeviceTypeIPhone12Mini,
    enumDeviceTypeIPhone12,
    enumDeviceTypeIPhone12Pro,
    enumDeviceTypeIPhone12ProMax,

    //iPad
    //......
    
} EnumDeviceType;

@import Photos;

@interface BaseViewController : UIViewController

@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIButton *backButton;

- (void)showWating;

- (void)hideWating;

- (void)backButtonClick;

- (void)nextButtonClick;

- (void)setProgress:(CGFloat)progress;

+ (NSURL *)movieURL:(PHAsset *)phasset;

+ (BOOL)checkForPortrait:(CGAffineTransform)transform;

+ (EnumDeviceType)deviceType;

@end
