//
//  KWUIManager.h
//  KiwiFace
//
//  Created by jacoy on 2017/8/2.
//  Copyright © 2017年 jacoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KWRenderManager.h"

@protocol KWUIManagerDelegate <NSObject>

- (void)didClickOffPhoneButton;

- (void)didBeginLongPressOffPhoneButton;

- (void)didEndLongPressOffPhoneButton;

- (void)didClickSwitchCameraButton;

- (void)didClickCloseVideoButton;

@end

@interface KWUIManager : NSObject

/**
 Taking photos of the button
 */
typedef void(^TakePhotoBtnTapBlock)(UIButton *sender);

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
@property(nonatomic, strong) KWRenderManager *renderManager;

/**
 When you use the SDK built-in UI, you must pass in a ViewController that references the page
 */
//@property(nonatomic, weak) UIViewController *actionViewController;

/**
 Whether to clear the original page controller UI
 */
@property(nonatomic, assign) BOOL isClearOldUI;

@property(nonatomic, weak) id <KWUIManagerDelegate> delegate;

@property(nonatomic, strong) UIButton *btnIsEnableGrabCut;

/**
 Video preview layer
 */
@property(nonatomic, weak) GPUImageView *previewView;


/**
 Initialize UIManager
 
 @param renderManager renderManager Object
 @param delegate KWUIManagerDelegate
 @param superView kiwiFaceUI's superView
 */
- (instancetype)initWithRenderManager:(KWRenderManager *)renderManager delegate:(id <KWUIManagerDelegate>)delegate superView:(UIView *)superView;

/**
 Sets the  container of sdk UI
 
 @param delegate the viewController
 */
//- (void)setViewDelegate:(UIViewController *)delegate;

/**
 Creates built-in UI
 */
- (void)createUI;

- (void)releaseManager;

- (void)setCloseBtnEnable:(BOOL)enable;

/**
 Sets whether or not to hide the middle main action button below the home screen's built-in UI
 
 @param isHidden isHidden main button
 */
- (void)setOffPhoneBtnHidden:(BOOL)isHidden;

/**
 Sets whether to hide the middle-center video button on the main UI built-in UI
 
 @param isHidden isHidden toggle button
 */
- (void)setToggleBtnHidden:(BOOL)isHidden;

/**
 Sets whether to hide Close the video window button
 
 @param isHidden isHidden  the video window button
 */
- (void)setCloseVideoBtnHidden:(BOOL)isHidden;

/**
 Set whether to hide the left button below the home screen's built-in UI
 
 @param isHidden isHidden left button
 */
- (void)setLeftBtHidden:(BOOL)isHidden;

/**
 Set whether to hide the home screen below the built-in UI right button
 
 @param isHidden isHidden right button
 */
- (void)setRightBtnHidden:(BOOL)isHidden;

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
