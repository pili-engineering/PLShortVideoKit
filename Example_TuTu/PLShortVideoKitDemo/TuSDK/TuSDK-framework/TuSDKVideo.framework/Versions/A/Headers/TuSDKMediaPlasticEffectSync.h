//
//  TuSDKMediaPlasticEffectSync.h
//  TuSDKVideo
//
//  Created by sprint on 18/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKMediaEffectSync.h"
#import "TuSDKVideoImport.h"

/**
 大眼瘦脸特效同步器
 
 @since v3.0.1
 */
@protocol TuSDKMediaPlasticEffectSync <NSObject,TuSDKMediaEffectSync,TuSDKFilterFacePositionProtocol>

@required

/**
 设置是否开启大眼瘦脸 默认：NO
 @since v2.2.0
 */
@property (nonatomic) BOOL enablePlastic;


@end
