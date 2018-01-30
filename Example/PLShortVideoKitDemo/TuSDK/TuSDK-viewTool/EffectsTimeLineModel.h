//
//  EffectsTimeLineModel.h
//  PLShortVideoKitDemo
//
//  Created by wen on 21/12/2017.
//  Copyright © 2017 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EffectsTimeLineModel : NSObject

// 特效code
@property (nonatomic, copy) NSString * effectsCode;
// 特效开始节点  0~1
@property (nonatomic, assign) CGFloat startProgress;
// 特效结束节点  0~1
@property (nonatomic, assign) CGFloat endProgress;
// 特效设置是否有效  YES:有效    - 在使用model进行舍之前，需使用isValid判断是否为有效设置
@property (nonatomic, assign) BOOL isValid;


@end
