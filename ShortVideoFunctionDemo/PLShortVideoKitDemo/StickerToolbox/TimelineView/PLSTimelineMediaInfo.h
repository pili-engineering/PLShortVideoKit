//
//  PLSTimelineMediaInfo.h
//  PLVideoEditor
//
//  Created by suntongmian on 2018/5/24.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define UIColorFromRGB(R,G,B)  [UIColor colorWithRed:(R * 1.0) / 255.0 green:(G * 1.0) / 255.0 blue:(B * 1.0) / 255.0 alpha:1.0]
#define rgba(R,G,B,A)  [UIColor colorWithRed:(R * 1.0) / 255.0 green:(G * 1.0) / 255.0 blue:(B * 1.0) / 255.0 alpha:A]


@interface PLSTimelineMediaInfo : NSObject

@property (nonatomic, strong) AVAsset *asset;   //媒体资源
@property (nonatomic, copy)   NSString *path;     //媒体资源路径
@property (nonatomic, assign) CGFloat duration; //媒体持续时长
@property (nonatomic, assign) CGFloat startTime; //媒体开始时间
@property (nonatomic, assign) int rotate;//旋转角度

@end
