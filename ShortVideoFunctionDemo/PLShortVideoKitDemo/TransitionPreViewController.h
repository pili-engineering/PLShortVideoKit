//
//  TransitionPreViewController.h
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/11/4.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PLShortVideoKit/PLShortVideoKit.h>
#import "PLSTransitionScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransitionPreViewController : UIViewController

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) PLSImageVideoComposer *imageVideoComposer;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *types;
@property (nonatomic, strong) PLSTransitionScrollView *transitionScrollView;

@end

NS_ASSUME_NONNULL_END
