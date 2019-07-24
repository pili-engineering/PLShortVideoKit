//
//  PLSDrawModel.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/7/24.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSDrawModel.h"

@implementation PLSDrawModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.lineColor = [UIColor whiteColor];
        self.lineWidth = 3;
    }
    return self;
}
@end
