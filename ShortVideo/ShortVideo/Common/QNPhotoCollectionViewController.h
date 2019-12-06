//
//  QNPhotoCollectionViewController.h
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/26.
//  Copyright © 2019 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNSampleScrollView.h"
#import "QNAssetCollectionViewCell.h"
#import "QNSelectButtonView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QNPhotoCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, assign) NSInteger maxSelectCount;
@property (nonatomic, assign) PHAssetMediaType mediaType;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) QNSelectButtonView *buttonView;
@property (nonatomic, strong) QNSampleScrollView *dynamicScrollView;
@property (nonatomic, assign) NSInteger typeIndex; // 0 拼接 1 拼图

- (void)nextButtonClick:(UIButton *)sender;

- (void)fetchAssetsWithMediaType:(PHAssetMediaType)mediaType;

@end

NS_ASSUME_NONNULL_END
