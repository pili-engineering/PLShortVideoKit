//
//  TuSDKFilterConfigViewBase.h
//  TuSDKVideo
//
//  Created by Yanlin on 4/22/16.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKFilterConfigProtocol.h"

@interface TuSDKFilterConfigViewBase : UIView <TuSDKFilterConfigProtocol>

// 滤镜包装对象
@property (nonatomic, assign) TuSDKFilterWrap *filterWrap;

// 请求渲染
- (void)requestRender;

@end
