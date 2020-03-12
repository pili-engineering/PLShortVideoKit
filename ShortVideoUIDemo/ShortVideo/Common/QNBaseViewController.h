//
//  QNBaseViewController.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/1.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PLShortVideoKit/PLSTypeDefines.h>

#define iPhoneX_SERIES (QNDeviceTypeIPhoneXR == [QNBaseViewController deviceType] || QNDeviceTypeIPhoneX == [QNBaseViewController deviceType] || QNDeviceTypeIPhoneXS == [QNBaseViewController deviceType] || QNDeviceTypeIPhoneXSMax == [QNBaseViewController deviceType])


typedef enum : NSUInteger {
    //iPhone
    QNDeviceTypeIPhone4,
    QNDeviceTypeIPhone4s,
    QNDeviceTypeIPhone5,
    QNDeviceTypeIPhone5c,
    QNDeviceTypeIPhone5s,
    QNDeviceTypeIPhone6,
    QNDeviceTypeIPhone6Plus,
    QNDeviceTypeIPhone6s,
    QNDeviceTypeIPhone6sPlus,
    QNDeviceTypeIPhoneSE,
    QNDeviceTypeIPhone7,
    QNDeviceTypeIPhone7Plus,
    QNDeviceTypeIPhone8,
    QNDeviceTypeIPhone8Plus,
    QNDeviceTypeIPhoneX,
    QNDeviceTypeIPhoneXS,
    QNDeviceTypeIPhoneXR,
    QNDeviceTypeIPhoneXSMax,
    
    //iPad
    //......
    
} QNDeviceType;

@import Photos;

@interface QNBaseViewController : UIViewController

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *progressLabel;

- (void)showWating;

- (void)hideWating;

- (void)setProgress:(CGFloat)progress;

+ (NSURL *)movieURL:(PHAsset *)phasset;

+ (QNDeviceType)deviceType;

+ (NSInteger)suitableVideoBitrateWithSize:(CGSize)videoSize;

+ (PLSAudioBitRate)suitableAudioBitrateWithSampleRate:(PLSAudioSampleRate)sampleRate channel:(NSInteger)channel;

- (void)showAlertMessage:(NSString *)title message:(NSString *)message;

- (void)requestMPMediaLibraryAuth:(void(^)(BOOL succeed))completeBlock;

- (void)requestCameraAuth:(void(^)(BOOL succeed))completeBlock;

- (void)requestMicrophoneAuth:(void(^)(BOOL succeed))completeBlock;

- (void)requestPhotoLibraryAuth:(void(^)(BOOL succeed))completeBlock;

- (NSString *)formatTimeString:(NSTimeInterval)time;

- (NSArray *)configureGlobalSettings;

- (NSArray *)getSettingInfos;

- (NSString *)getPreviewVideoSize;

- (NSInteger)getAudioChannels;

- (NSArray *)getEncodeVideoSize;

- (NSInteger)getEncodeBites;
@end
