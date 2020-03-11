//
//  QNTranscodeViewController.h
//  ShortVideo
//
//  Created by hxiongan on 2019/4/15.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNBaseViewController.h"

#import <Photos/Photos.h>


@interface QNTranscodeViewController : QNBaseViewController

@property (nonatomic, strong) PHAsset *phAsset;
@property (nonatomic, strong) NSURL *sourceURL;

@end
