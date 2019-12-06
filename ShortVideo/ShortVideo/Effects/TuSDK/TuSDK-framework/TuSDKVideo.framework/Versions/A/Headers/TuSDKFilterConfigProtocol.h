//
//  TuSDKFilterConfigProtocol.h
//  TuSDKVideo
//
//  Created by Yanlin on 4/20/16.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"

/**
 *  滤镜参数配置视图接口
 */
@protocol TuSDKFilterConfigProtocol <NSObject>

// 滤镜包装对象
@property (nonatomic, assign) TuSDKFilterWrap *filterWrap;

// 请求渲染
- (void)requestRender;

@end
