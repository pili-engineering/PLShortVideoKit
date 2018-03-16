//
//  TransitionViewController.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/1/23.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TransitionViewController;
@protocol TransitionViewControllerDelegate
<
NSObject
>

- (void)transitionViewController:(TransitionViewController *)transitionController transitionMedia:(NSURL *)transitionURL;

@end

@interface TransitionViewController : UIViewController

@property (nonatomic, weak) id<TransitionViewControllerDelegate> delegate;

@property (nonatomic, strong) NSURL *backgroundVideoURL;

@end
