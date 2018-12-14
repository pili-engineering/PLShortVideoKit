//
//  DubViewController.h
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/9/5.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol DubViewControllerDelegate <NSObject>

- (void)didOutputAsset:(AVAsset *)asset;

@end

@interface DubViewController : UIViewController

@property (assign, nonatomic) id<DubViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary *movieSettings;

@end
