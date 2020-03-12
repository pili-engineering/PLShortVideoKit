//
//  QNMusicModel.h
//  ShortVideo
//
//  Created by hxiongan on 2019/4/22.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@interface QNMusicModel : NSObject

@property (nonatomic, strong) NSString *musicName;
@property (nonatomic, strong) NSURL *musicURL;
@property (nonatomic, strong, readonly) UIColor *randomColor;

// 音乐的起止时间
@property (nonatomic, assign) CMTime duration;
@property (nonatomic, assign) CMTime startTime;
@property (nonatomic, assign) CMTime endTime;

// 音乐在视频中的位置
@property (nonatomic, assign) CMTime startPositionTime;
@property (nonatomic, assign) CMTime endPositiontime;

@property (nonatomic, weak) UIView *colorView;

@end

