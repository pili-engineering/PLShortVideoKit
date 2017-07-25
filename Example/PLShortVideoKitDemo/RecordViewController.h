//
//  RecordViewController.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWSDK_UI.h"

@interface RecordViewController : UIViewController
@property (nonatomic, strong) KWSDK_UI *kwSdkUI;
@property (nonatomic,copy)NSString *modelPath;

@end
