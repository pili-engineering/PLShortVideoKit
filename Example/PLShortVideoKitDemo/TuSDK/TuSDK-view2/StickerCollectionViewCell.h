//
//  StickerCollectionViewCell.h
//  TuSDKVideoDemo
//
//  Created by wen on 21/08/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIColor *borderColor;

// 初始化cell 视图
- (void)initCellViewWith:(id)object;

// 展示下载动画
- (void)displayDownloadingView;

@end
