//
//  VideoSelectViewController.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/5/19.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PhotoAlbumViewController.h"

typedef enum : NSUInteger {
    enumVideoNextActionRecording,
    enumVideoNextActionPingtu,
} EnumVideoNextAction;

@interface VideoSelectViewController : PhotoAlbumViewController

@property (nonatomic, assign) NSInteger needVideoCount;

@property (nonatomic, assign) EnumVideoNextAction actionType;

@end
