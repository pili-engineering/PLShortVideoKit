//
//  StickerScrollView.h
//  TuSDKVideoDemo
//
//  Created by tutu on 2017/3/10.
//  Copyright © 2017年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TuSDKVideo/TuSDKVideo.h>

typedef enum : NSUInteger {
    lsqCameraStickersTypeSquare,
    lsqCameraStickersTypeFullScreen,
    lsqCameraStickersTypeAll,
} lsqCameraStickersType;


/**
 贴纸组相关代理方法
 
 @param stickGroup 贴纸组对象
 */

@protocol StickerViewClickDelegate <NSObject>

/**
点击新的贴纸组对应视图

 @param stickGroup 贴纸组
 */
- (void)clickStickerViewWith:(TuSDKPFStickerGroup *)stickGroup;

@end

/**
 贴纸栏视图 (仅包含UI相关，交互逻辑通过代理抛出)
 */
@interface StickerScrollView : UIView

// 贴纸组的数组
@property (nonatomic, strong) NSArray *stickerGroups;

// 贴纸展示的类型 全屏贴纸、正方形相机贴纸、全部贴纸
@property (nonatomic, assign) lsqCameraStickersType cameraStickerType;

// 当前选中的贴纸（注意：第一个清除所有贴纸的index为0）
@property (nonatomic, assign) NSInteger currentStickesIndex;

// 贴纸栏事件代理
@property (nonatomic, assign) id<StickerViewClickDelegate> stickerDelegate;

@end
