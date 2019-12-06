//
//  CameraBeautySkinListView.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/9/17.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "HorizontalListView.h"

static const int kBeautyLevelCount = 5;

@interface CameraBeautySkinListView : HorizontalListView

@property (nonatomic, copy) void (^itemViewTapActionHandler)(CameraBeautySkinListView *listView, HorizontalListItemView *selectedItemView, int level);

@property (nonatomic, assign) int level;

@end
