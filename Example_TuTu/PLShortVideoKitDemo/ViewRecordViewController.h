//
//  ViewRecordViewController.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2018/4/28.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ViewRecordViewController : UIViewController

@property (strong, nonatomic) NSArray<PHAsset *> *selectedAssets;

@end
