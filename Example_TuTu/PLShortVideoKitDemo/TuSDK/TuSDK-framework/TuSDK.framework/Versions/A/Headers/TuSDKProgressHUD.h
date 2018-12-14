//
//  TuSDKProgressHUD.h
//  TuSDK
//
//  Copyright 2011-2014 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVProgressHUD
//
//  修改：SVProgressHUD 修改为 TuSDKProgressHUD
//       SVProgressHUD.bundle 修改为 TuSDKUI.bundle/style_default_hud_*
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

extern NSString * const TuSDKProgressHUDDidReceiveTouchEventNotification;
extern NSString * const TuSDKProgressHUDDidTouchDownInsideNotification;
extern NSString * const TuSDKProgressHUDWillDisappearNotification;
extern NSString * const TuSDKProgressHUDDidDisappearNotification;
extern NSString * const TuSDKProgressHUDWillAppearNotification;
extern NSString * const TuSDKProgressHUDDidAppearNotification;

extern NSString * const TuSDKProgressHUDStatusUserInfoKey;

typedef NS_ENUM(NSUInteger, TuSDKProgressHUDMaskType) {
    TuSDKProgressHUDMaskTypeNone = 1,  // allow user interactions while HUD is displayed
    TuSDKProgressHUDMaskTypeClear,     // don't allow user interactions
    TuSDKProgressHUDMaskTypeBlack,     // don't allow user interactions and dim the UI in the back of the HUD
    TuSDKProgressHUDMaskTypeGradient   // don't allow user interactions and dim the UI with a a-la-alert-view background gradient
};

@interface TuSDKProgressHUD : UIView

#pragma mark - Customization

+ (void)setBackgroundColor:(UIColor*)color;                 // default is [UIColor whiteColor]
+ (void)setForegroundColor:(UIColor*)color;                 // default is [UIColor blackColor]
+ (void)setRingThickness:(CGFloat)width;                    // default is 4 pt
+ (void)setFont:(UIFont*)font;                              // default is [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
+ (void)setSuccessImage:(UIImage*)image;                    // default is the bundled success image provided by Freepik
+ (void)setErrorImage:(UIImage*)image;                      // default is the bundled error image provided by Freepik
+ (void)setDefaultMaskType:(TuSDKProgressHUDMaskType)maskType; // default is TuSDKProgressHUDMaskTypeNone

#pragma mark - Show Methods

+ (void)show;
+ (void)showWithMaskType:(TuSDKProgressHUDMaskType)maskType;
+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status maskType:(TuSDKProgressHUDMaskType)maskType;

+ (void)showProgress:(float)progress;
+ (void)showProgress:(float)progress maskType:(TuSDKProgressHUDMaskType)maskType;
+ (void)showProgress:(float)progress status:(NSString*)status;
+ (void)showProgress:(float)progress status:(NSString*)status maskType:(TuSDKProgressHUDMaskType)maskType;

+ (void)setStatus:(NSString*)string; // change the HUD loading status while it's showing

// stops the activity indicator, shows a glyph + status, and dismisses HUD a little bit later
+ (void)showSuccessWithStatus:(NSString*)string;
+ (void)showSuccessWithStatus:(NSString*)string maskType:(TuSDKProgressHUDMaskType)maskType;

+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showErrorWithStatus:(NSString *)string maskType:(TuSDKProgressHUDMaskType)maskType;

// use 28x28 white pngs
+ (void)showImage:(UIImage*)image status:(NSString*)status;
+ (void)showImage:(UIImage*)image status:(NSString*)status maskType:(TuSDKProgressHUDMaskType)maskType;

+ (void)setOffsetFromCenter:(UIOffset)offset;
+ (void)resetOffsetFromCenter;

+ (void)popActivity; // decrease activity count, if activity count == 0 the HUD is dismissed
+ (void)dismiss;

+ (BOOL)isVisible;

@end

/**
 *  TuSDK 扩展
 */
@interface TuSDKProgressHUD(TuSDKExtend)
/**
 *  在主线程中显示信息
 *
 *  @param status 信息
 */
+ (void)showMainThreadWithStatus:(NSString*)status;

/**
 *  在主线程中显示信息
 *
 *  @param message 信息
 */
+ (void)showMainThreadWithMessage:(NSString*)message;

/**
 *  在主线程中显示进度和信息
 *
 *  @param progress
 *             进度
 *  @param status
 *             信息
 */
+ (void)showMainThreadProgress:(float)progress withStatus:(NSString *)status;

/**
 *  在主线程中显示成功信息
 *
 *  @param string 信息
 */
+ (void)showMainThreadSuccessWithStatus:(NSString*)string;

/**
 *  在主线程中显示错误信息
 *
 *  @param string 信息
 */
+ (void)showMainThreadErrorWithStatus:(NSString *)string;
@end
