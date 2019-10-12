//
//  MixRecordViewController.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/4/18.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    enumMixTypeLeftRight,// 左右分屏
    enumMixTypeUpdown, // 画中画，素材在上
    enumMixTypeDownup, // 画中画，素材在下
} EnumMixType;


@interface MixRecordViewController : UIViewController

// 合拍视频地址
@property (nonatomic, strong) NSURL *mixURL;

@property (nonatomic, assign) EnumMixType mixType;

@end
