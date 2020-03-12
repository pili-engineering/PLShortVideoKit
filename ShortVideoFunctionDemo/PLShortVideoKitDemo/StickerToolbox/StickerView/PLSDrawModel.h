//
//  PLSDrawModel.h
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/7/24.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PLSDrawView;
@interface PLSDrawModel : NSObject

@property (nonatomic, assign) CMTime startPositionTime;
@property (nonatomic, assign) CMTime endPositiontime;

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@end

NS_ASSUME_NONNULL_END
