//
//  PlayViewController.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PLSActionType) {
    PLSActionTypePlayer = 0,
    PLSActionTypeGif,
};

@interface PlayViewController : UIViewController

@property (assign, nonatomic) PLSActionType actionType;
@property (strong, nonatomic) NSURL *url;

@end
