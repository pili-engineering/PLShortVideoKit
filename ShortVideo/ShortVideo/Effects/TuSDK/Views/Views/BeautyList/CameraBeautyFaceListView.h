//
//  CameraBeautyFaceListView.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/9/17.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "HorizontalListView.h"

@interface CameraBeautyFaceListView : HorizontalListView

@property (nonatomic, strong, readonly) NSArray<NSString *> *faceFeatures;

@property (nonatomic, copy) NSString *selectedFaceFeature;

@property (nonatomic, copy) void (^itemViewTapActionHandler)(CameraBeautyFaceListView *listView, HorizontalListItemView *selectedItemView, NSString *faceFeature);

@end
