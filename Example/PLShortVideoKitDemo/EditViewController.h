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

@property (strong, nonatomic) NSDictionary *settings;

@property (strong, nonatomic) NSArray *filesURLArray;

@property (strong, nonatomic) AVPlayerItem *playerItem;

@end
