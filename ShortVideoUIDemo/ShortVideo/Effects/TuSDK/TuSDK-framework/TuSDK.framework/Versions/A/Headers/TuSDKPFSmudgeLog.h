//
//  TuSDKPFSmudgeLog.h
//  TuSDK
//
//  Created by gh.li on 16/11/14.
//  Copyright © 2016年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
  * 涂抹记录对象
 */
@interface TuSDKPFSmudgeLog : NSObject

/**
 * 根据图片初始化Log
 */
-(id) initWithImage:(UIImage *) image;


// 图片信息
@property (nonatomic,strong,readonly) UIImage *image;

// 是否为缓存文件
@property (nonatomic,assign,readonly) Boolean cached;

/*
 * 缓存日志信息
 */
-(void) runCacheJob;

/*
 * 释放日志信息
 */
-(void) destroy;


@end
