//
//  TuSDKMediaMutableCompositionSampleBufferProducer.h
//  TuSDKVideo
//
//  Created by sprint on 2019/5/6.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TuSDKMediaComposition.h"

NS_ASSUME_NONNULL_BEGIN

/**
 支持多个 Composition 组合使用
 
 @since v3.4.1
 */
@interface TuSDKMediaMutableComposition : NSObject <TuSDKMediaComposition>
{
    // 所有已添加的合成物
    NSMutableArray<id<TuSDKMediaComposition>> *_compositions;
    
    // 当前正在读取的合成项
    id<TuSDKMediaComposition> _readingComposition;

}

/**
 已添加的 Composition 合成项集合
 @since v3.4.1
 */
@property (nonatomic,readonly)NSArray<id<TuSDKMediaComposition>> *compositions;

/**
 准备读取数据
 @since v3.4.1
 */
-(void)prepareForReading;

/**
 追加一个新的 Composition 合成项

 @param composition 合成项
 @since v3.4.1
 */
- (BOOL)appendComposition:(id<TuSDKMediaComposition>)composition;

/**
 移除指定的 Composition 合成项
 
 @param composition 合成项
 @since v3.4.1
 */
- (BOOL)removeComposition:(id<TuSDKMediaComposition>)composition;


@end

NS_ASSUME_NONNULL_END
