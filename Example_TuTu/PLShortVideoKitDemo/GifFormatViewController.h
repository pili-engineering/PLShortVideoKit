//
//  GifFormatViewController.h
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/7/31.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GifFormatViewController : UIViewController
    
@property (strong, nonatomic) AVAsset *asset;

@property (strong, nonatomic) NSURL *videoURL;
@end
