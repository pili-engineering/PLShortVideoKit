//
//  SceneEffectTools.h
//  TuSDKVideoDemo
//
//  Created by wen on 27/12/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TuSDK/TuSDK.h>
#import <TuSDKVideo/TuSDKVideo.h>


/**
 场景特效工具类
 注：本Demo中的场景特效逻辑只对应一种，接口本身可扩展多种交互逻辑，用户可自行修改，具体实现可参考Demo中的逻辑。
    且Demo中的事件叠加覆盖逻辑，在 SceneEffectTools 类中进行了展示，可直接复用。
 */
@interface SceneEffectTools : NSObject

// 视频时长   注：使用 SceneEffectTools 时，需确保 videoDuration 赋值
@property (nonatomic, assign) CGFloat videoDuration;
// 每一次添加的记录数组 (未进行叠加时间覆盖)
@property (nonatomic, strong) NSMutableArray<TuSDKMediaSceneEffectData *> *historyArr;


/**
 开始添加一个场景特效

 @param effectCode 特效code
 @param startProgress 特效开始的progress
 */
- (void)addEffectBegin:(NSString *)effectCode withProgress:(CGFloat)startProgress;

/**
 结束当前正在添加的一个场景特效 - begin与end 成对出现

 @param effectCode 特效code - 需与begin 中的code 一致
 @param endProgress 特效结束的progress
 */
- (void)addEffectEnd:(NSString *)effectCode withProgress:(CGFloat)endProgress;

/**
 移除上一个添加的特效
 */
- (void)removeLastEffect;

/**
 根据传入的progress判断是否需要切换特效

 @param currentProgress 当前的progress
 @return 是否需要进行切换 YES：需要进行切换
 */
- (BOOL)needSwitchEffectWithProgress:(CGFloat)currentProgress;

/**
 获取当前应该展示的特效code  -  调用前应使用 needSwitchEffectWithProgress 判断是否需要进行切换

 @return 应该展示的特效code
 */
- (NSString *)currentEffectCode;

/**
 获取最终已完成时间叠加覆盖的有效数组
 */
- (NSArray<TuSDKMediaSceneEffectData *> *)getResultArr;

@end
