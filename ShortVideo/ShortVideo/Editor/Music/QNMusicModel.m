//
//  QNMusicModel.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/22.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNMusicModel.h"

@interface QNMusicModel ()

@property (nonatomic, strong, readwrite) UIColor *randomColor;

@end

@implementation QNMusicModel

- (instancetype)init {
    self = [super init];
    if (self) {
        uint32_t value = arc4random() % 9;
        if (0 == value) {
            self.randomColor = UIColor.redColor;
        } else if (1 == value) {
            self.randomColor = UIColor.grayColor;
        } else if (2 == value) {
            self.randomColor = UIColor.orangeColor;
        } else if (3 == value) {
            self.randomColor = UIColor.blueColor;
        } else if (4 == value) {
            self.randomColor = UIColor.greenColor;
        } else if (5 == value) {
            self.randomColor = UIColor.brownColor;
        } else if (6 == value) {
            self.randomColor = UIColor.cyanColor;
        } else if (7 == value) {
            self.randomColor = UIColor.yellowColor;
        } else if (8 == value) {
            self.randomColor = UIColor.magentaColor;
        }
        
        CGFloat r = 0;
        CGFloat g = 0;
        CGFloat b = 0;
        [self.randomColor getRed:&r green:&g blue:&b alpha:NULL];
        self.randomColor = [UIColor colorWithRed:r green:g blue:b alpha:.9];
    }
    return self;
}

@end
