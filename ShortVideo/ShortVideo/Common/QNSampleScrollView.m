//
//  QNSampleScrollView.m
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/26.
//  Copyright © 2019 ahx. All rights reserved.
//

#import "QNSampleScrollView.h"

@implementation QNSampleScrollView
{
    float singleWidth;
    CGPoint startPoint;
    CGPoint originPoint;
    BOOL isContain;
}

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageViews = [NSMutableArray arrayWithCapacity:images.count];
        self.images = images;
        singleWidth = ([UIScreen mainScreen].bounds.size.width / 5);
        
        self.selectedAssets = [[NSMutableArray alloc] init];
        
        // 创建底部滑动视图
        [self initScrollView];
        [self initViews];
    }
    return self;
}

- (void)initScrollView {
    if (self.scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
    }
}

- (void)initViews {
    for (int i = 0; i < self.images.count; i++) {
        UIImage *image = self.images[i];
        [self createImageViews:i image:image];
    }
    self.scrollView.contentSize = CGSizeMake(self.images.count * singleWidth, self.scrollView.frame.size.height);
}

- (void)createImageViews:(NSUInteger)i image:(UIImage *)image {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.frame = CGRectMake(singleWidth*i + singleWidth * 0.1, singleWidth * 0.1, singleWidth * 0.8, self.scrollView.frame.size.height * 0.8);
    imgView.userInteractionEnabled = YES;
    [self.scrollView addSubview:imgView];
    [self.imageViews addObject:imgView];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"qn_btn_delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.frame = CGRectMake(- 20, - 20, 60, 60);
    deleteButton.backgroundColor = [UIColor clearColor];
    [imgView addSubview:deleteButton];
}

// 获取view在imageViews中的位置
- (NSInteger)indexOfPoint:(CGPoint)point withView:(UIView *)view {
    UIImageView *originImageView = (UIImageView *)view;
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *otherImageView = self.imageViews[i];
        if (otherImageView != originImageView) {
            if (CGRectContainsPoint(otherImageView.frame, point)) {
                return i;
            }
        }
    }
    return -1;
}

- (void)deleteAction:(UIButton *)button {
    UIImageView *imageView = (UIImageView *)button.superview;
    __block NSUInteger index = [self.imageViews indexOfObject:imageView];
    __block CGRect rect = imageView.frame;
    __weak UIScrollView *weakScroll = self.scrollView;
    
    [self.selectedAssets removeObjectAtIndex:index];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            for (NSUInteger i = index + 1; i < self.imageViews.count; i++) {
                UIImageView *otherImageView = self.imageViews[i];
                CGRect originRect = otherImageView.frame;
                otherImageView.frame = rect;
                rect = originRect;
            }
        } completion:^(BOOL finished) {
            [self.imageViews removeObject:imageView];
            if (self.imageViews.count > 5) {
                weakScroll.contentSize = CGSizeMake(singleWidth * self.imageViews.count, _scrollView.frame.size.height);
            }
        }];
    }];
}

- (void)addAsset:(PHAsset *)asset {
    [self.selectedAssets addObject:asset];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    CGFloat width = ([UIScreen mainScreen].bounds.size.width / 5);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(width * scale, width * scale);
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:size
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                // 设置的 options 可能会导致该回调调用两次，第一次返回你指定尺寸的图片，第二次将会返回原尺寸图片
                                                if ([[info valueForKey:@"PHImageResultIsDegradedKey"] integerValue] == 0){
                                                    // Do something with the FULL SIZED image
                                                    
                                                    [self addImage:result];
                                                    
                                                } else {
                                                    // Do something with the regraded image
                                                    
                                                }
                                            }];
}

- (void)addImage:(UIImage *)image {
    [self createImageViews:self.imageViews.count image:image];
    
    self.scrollView.contentSize = CGSizeMake(singleWidth*self.imageViews.count, self.scrollView.frame.size.height);
    if (self.imageViews.count > 5) {
        [self.scrollView setContentOffset:CGPointMake((self.imageViews.count-5)*singleWidth, 0) animated:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
