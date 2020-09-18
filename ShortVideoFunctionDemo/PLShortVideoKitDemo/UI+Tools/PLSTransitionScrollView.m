//
//  PLSTransitionScrollView.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/11/25.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSTransitionScrollView.h"

@interface PLSTransitionScrollView()

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *types;
@end

@implementation PLSTransitionScrollView
{
    float singleWidth;
    float buttonWidth;
    CGPoint startPoint;
    CGPoint originPoint;
    BOOL isContain;
}

- (void)dealloc {
    NSLog(@"dealloc: %@", [[self class] description]);
}

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images types:(NSMutableArray *)types{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.imageViews = [NSMutableArray array];
        
        self.images = images;
        self.types = types;
        
        singleWidth = ([UIScreen mainScreen].bounds.size.width / 5);
        buttonWidth = 28;
                
        self.selectedTypes = [NSMutableArray array];
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
        [self addSubview:_scrollView];
    }
}

- (void)initViews {
    for (int i = 0; i < self.images.count; i++) {
        UIImage *image = self.images[i];
        NSNumber *type;
        if (i != self.images.count - 1) {
            type = self.types[i];
        } else{
            type = nil;
        }
        
        [self createImageViews:i image:image type:type];
    }
    self.scrollView.contentSize = CGSizeMake(self.images.count * (singleWidth + buttonWidth) - buttonWidth, self.scrollView.frame.size.height);
}

- (void)createImageViews:(NSUInteger)i image:(UIImage *)image type:(NSNumber *)type {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.frame = CGRectMake((singleWidth + buttonWidth) * i + singleWidth * 0.1, singleWidth * 0.1, singleWidth * 0.8, self.scrollView.frame.size.height * 0.8);
    imgView.userInteractionEnabled = YES;
    [self.scrollView addSubview:imgView];
    [self.imageViews addObject:imgView];
    
    if (type) {
        NSInteger index = [type integerValue];
        NSArray *titleArray = @[@"淡入淡出", @"闪黑", @"闪白", @"圆形", @"从上飞入", @"从下飞入", @"从左飞入", @"从右飞入", @"从上擦除", @"从下擦除", @"从左擦除", @"从右擦除", @"苍眼", @"交叉缩放", @"交换", @"开门", @"百叶窗", @"闪光", @"渐隐", @"分解", @"擦除", @"飞出", @"扫描", @"波纹", @"翻页", @"立体翻页", @"无"];
        NSString *title = titleArray[index];
        
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.tag = 1000 + i;
        [selectButton setTitle:title forState:UIControlStateNormal];
        selectButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        selectButton.titleLabel.numberOfLines = 0;
        [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        selectButton.frame = CGRectMake(singleWidth * (i + 1) + buttonWidth * i, singleWidth * 0.1, buttonWidth, self.scrollView.frame.size.height * 0.8);
        selectButton.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:selectButton];
        [self.selectedTypes addObject:type];
    }
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

- (void)selectAction:(UIButton *)button {
    NSUInteger index = button.tag - 1000;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(transitionScrollView:didClickIndex:button:)]) {
        [self.delegate transitionScrollView:self didClickIndex:index button:button];
    }
}

- (void)clear {
    self.selectedTypes = [NSMutableArray array];
    self.images = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
