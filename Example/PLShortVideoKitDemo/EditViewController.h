//
//  EditViewController.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/4/11.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class PLSFileSection;

@interface EditViewController : UIViewController

@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) NSArray *filesURLArray;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end
