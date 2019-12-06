//
//  QNSampleScrollView.h
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/26.
//  Copyright © 2019 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNSampleScrollView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *selectedAssets;

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images;

- (void)addImage:(UIImage *)image;

- (void)addAsset:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
