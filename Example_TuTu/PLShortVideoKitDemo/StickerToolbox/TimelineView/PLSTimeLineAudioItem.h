//
//  PLSTimeLineAudioItem.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2018/5/29.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

@interface PLSTimeLineAudioItem : NSObject

@property (strong, nonatomic) NSURL *url;
@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat endTime;
@property (assign, nonatomic) CGFloat volume;
@property (strong, nonatomic) UIColor *displayColor;

@end
