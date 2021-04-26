//
//  PLSError.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/4/28.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PLShortVideoKitErrorDomain @"com.PLShortVideoKit.ErrorDomain"

// 错误码
typedef enum : NSInteger {
    PLSErrorUnknown = -4000,
    PLSErrorCancelled = -4001,
    PLSErrorFailed = -4002,
} PLSErrorCode;

