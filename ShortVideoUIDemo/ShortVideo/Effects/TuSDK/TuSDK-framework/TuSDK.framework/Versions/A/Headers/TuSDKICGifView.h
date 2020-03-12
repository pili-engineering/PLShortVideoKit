//
//  TuSDKICGifView.h
//  TuSDK
//
//  Created by Yanlin on 1/4/16.
//  Copyright © 2016 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPGifImage.h"

typedef NS_ENUM(NSUInteger, lasqueGifImageType)
{
    lasqueGifImageTypeNone = 0,
    
    lasqueGifImageTypeImage,
    
    lasqueGifImageTypeHighlightedImage,
    
    lasqueGifImageTypeImages,
    
    lasqueGifImageTypeHighlightedImages,
};

#pragma mark - TuSDKPFGifViewDelegate
@class TuSDKICGifView;
/**
 *  Gif组件委托
 */
@protocol TuSDKPFGifViewDelegate <NSObject>
/**
 *  每次Gif动画结束时调用
 *
 *  @param gifView   TuSDKICGifView对象
 *  @param currCount 当前已播放次数
 *  @param loopCount Gif文件指定的动画循环次数，0表示无限循环
 */
- (void)onGifAnimationComplete:(TuSDKICGifView *)gifView currentLoopCount:(NSUInteger)currCount totalLoopCount:(NSUInteger)loopCount;
@end

#pragma mark - TuSDKICGifView

/**
 *  Gif组件
 */
@interface TuSDKICGifView : UIImageView

/**
 *  动画播放事件委托
 */
@property (nonatomic, weak) id<TuSDKPFGifViewDelegate> delegate;

/**
 *  自动播放动画 (默认: true)
 */
@property (nonatomic, assign) BOOL autoPlay;

/**
 *  总帧数
 */
@property (nonatomic, readonly) NSUInteger frameCount;

/**
 *  动画默认使用的runloop 模式，默认: NSRunLoopCommonModes
 *
 *   Set this property to `NSDefaultRunLoopMode` will make the animation pause during UIScrollView scrolling.
 */
@property (nonatomic, copy) NSString *runloopMode;

/**
 *  当前帧
 */
@property (nonatomic, assign) NSUInteger currentFrameIndex;


#pragma mark - play control

/**
 *  停止动画并重置播放状态
 */
- (void)resetAnimation;

@end
