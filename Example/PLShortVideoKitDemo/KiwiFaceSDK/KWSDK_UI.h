//
//  KWSDK_UI.h
//  KWKitDemo
//
//  Created by zhaoyichao on 2017/1/22.
//  Copyright © 2017年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KWSDK.h"

@protocol KWSDKUIDelegate <NSObject>

- (void)didClickOffPhoneButton;

- (void)didBeginLongPressOffPhoneButton;

- (void)didEndLongPressOffPhoneButton;

@end

@interface KWSDK_UI : NSObject

/**
 the block can witch the front and back position of camera
 */
typedef void(^ToggleBtnTapBlock)(void);

/**
 Taking photos of the button
 */
typedef void(^TakePhotoBtnTapBlock)(UIButton *sender);

/**
 the block can witch the close videowindow button
 */
typedef void(^CloseVideoWindowBtnTapBlock)(void);

/**
 The execution of the main button
 
 @param sender action button
 */
typedef void(^OffPhoneBtnTapBlock)(UIButton *sender);

/**
 Update the push log block
 
 @param log log string
 */
typedef void(^UpdateLogBlock)(NSString *log);

/**
 sdk main action class
 */
@property (nonatomic, strong)KWSDK *kwSdk;

/**
 When you use the SDK built-in UI, you must pass in a ViewController that references the page
 */
@property (nonatomic, weak) UIViewController *actionViewController;

/**
 Whether to clear the original page controller UI
 */
@property (nonatomic, assign) BOOL isClearOldUI;

@property (nonatomic,copy) ToggleBtnTapBlock toggleBtnBlock;

@property (nonatomic,copy) CloseVideoWindowBtnTapBlock closeVideoBtnBlock;

@property (nonatomic,weak)id<KWSDKUIDelegate>delegate;

/**
 Video preview layer
 */
@property (nonatomic, weak) GPUImageView *previewView;

/**
 Get a singleton class of sdk ui operations
 
 @return a singleton class of sdk ui operations
 */
+ (KWSDK_UI *)shareManagerUI;

/**
 Sets the  container of sdk UI
 
 @param delegate the viewController
 */
- (void)setViewDelegate:(UIViewController *)delegate;

/**
 Creates built-in UI
 */
- (void)initSDKUI;

+ (void)releaseManager;

- (void)setCloseBtnEnable:(BOOL) enable;

/**
 Sets whether or not to hide the middle main action button below the home screen's built-in UI
 
 @param isHidden isHidden main button
 */
- (void) setOffPhoneBtnHidden:(BOOL)isHidden;

/**
 Sets whether to hide the middle-center video button on the main UI built-in UI
 
 @param isHidden isHidden toggle button
 */
- (void) setToggleBtnHidden:(BOOL)isHidden;

/**
 Sets whether to hide Close the video window button
 
 @param isHidden isHidden  the video window button
 */
- (void) setCloseVideoBtnHidden:(BOOL)isHidden;

/**
 Set whether to hide the left button below the home screen's built-in UI
 
 @param isHidden isHidden left button
 */
- (void) setLeftBtHidden:(BOOL)isHidden;

/**
 Set whether to hide the home screen below the built-in UI right button
 
 @param isHidden isHidden right button
 */
- (void) setRightBtnHidden:(BOOL)isHidden;

/**
 Sets the coordinate offset of the left button below the built-in UI
 @param point pointValue
 */
- (void)setLeftBtn:(CGPoint)point;

/**
 Sets the offset of the right-hand button below the built-in UI
 
 @param point pointValue
 */
- (void)setRightBtn:(CGPoint)point;

/**
 Determine the vertical and horizontal screen
 */
- (void)resetScreemMode;


/**
 pop all Views
 */
- (void)popAllView;


@end
