//
//  TuSDKMediaSceneEffectData.h
//  TuSDKVideo
//
//  Created by wen on 27/12/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import "TuSDKMediaEffectData.h"

/**
 场景特效
 */
@interface TuSDKMediaSceneEffectData : TuSDKMediaEffectData

/**
 特效code
 */
@property (nonatomic, copy) NSString * effectsCode;
/**
 特效设置是否有效  YES:有效    -   结束时间 <= 开始时间 或 特效code不存在 则被认为是无效设置
*/
@property (nonatomic, assign, readonly) BOOL isValid;

/**
 克隆一个新的场景特效对象
 
 @return 返回新的相同内容的场景特效对象
 */
- (TuSDKMediaSceneEffectData *)clone;

@end
