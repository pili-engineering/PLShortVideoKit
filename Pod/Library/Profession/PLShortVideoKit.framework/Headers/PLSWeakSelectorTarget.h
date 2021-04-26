//
//  PLSWeakSelectorTarget.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/4/13.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class PLSWeakSelectorTarget
 @brief selector 工具类
 */
@interface PLSWeakSelectorTarget : NSObject

@property (readonly, nonatomic, weak) id target;
@property (readonly, nonatomic) SEL targetSelector;
@property (readonly, nonatomic) SEL handleSelector;

- (instancetype)initWithTarget:(id)target targetSelector:(SEL)targetSelector;

- (BOOL)sendMessageToTarget:(id)param;

@end
