//
//  TuSDKCPError.h
//  TuSDK
//
//  Created by Clear Hu on 14/12/11.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  组件错误类型
 */
typedef NS_ENUM(NSInteger, lsqCPErrorType)
{
    /**
     *  未知
     */
    lsqCPErrorUnknow = 0,
    /**
     *  没有找到输入的图片
     */
    lsqCPErrorInputImageEmpty = 1001,
    /**
     *  写入临时文件失败
     */
    lsqCPErrorSaveTempFailed = 1011,
    /**
     *  不支持摄像头
     */
    lsqCPErrorUnsupportCamera = 2001,
};

/**
 *  组件错误信息
 */
@interface TuSDKCPError : NSError

/**
 *  创建一个错误信息
 *
 *  @param type   组件错误类型
 *  @param object 来源对象
 *
 *  @return error 错误信息
 */
+ (TuSDKCPError *)errorWithType:(lsqCPErrorType)type from:(id)object;
@end
