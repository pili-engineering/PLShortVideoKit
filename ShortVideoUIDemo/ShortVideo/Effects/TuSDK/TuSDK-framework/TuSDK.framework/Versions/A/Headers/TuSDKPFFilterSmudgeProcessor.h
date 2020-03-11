//
//  TuSDKPFFilterSmudgeProcessor.h
//  TuSDK
//
//  Created by Yanlin on 12/2/15.
//  Copyright © 2015 tusdk.com. All rights reserved.
//

#import "TuSDKPFSimpleProcessor.h"
#import "TuSDKFilterWrap.h"

#pragma mark - TuSDKPFFilterSmudgeProcessor
/**
 *  基于滤镜的涂抹处理
 */
@interface TuSDKPFFilterSmudgeProcessor : TuSDKPFSimpleProcessor
{
    // 滤镜对象
    TuSDKFilterWrap *_filterWrap;
}

@property (nonatomic, retain) TuSDKFilterWrap *filterWrap;

@end
