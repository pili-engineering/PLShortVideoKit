//
//  EffectsView.m
//  TuSDKVideoDemo
//
//  Created by wen on 13/12/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import "EffectsView.h"
#import "EffectsItemView.h"
#import <TuSDK/TuSDK.h>

// 场景特效code
#define kSceneEffectCodeArray @[@"LiveShake01",@"LiveMegrim01",@"EdgeMagic01",@"LiveFancy01_1",@"LiveSoulOut01",@"LiveSignal01",@"LiveLightning01",@"LiveXRay01",@"LiveHeartbeat01", @"LiveMirrorImage01", @"LiveSlosh01", @"LiveOldTV01"]

@interface EffectsView()
<
EffectsItemViewEventDelegate,
// ahx add
UICollectionViewDelegate,
UICollectionViewDataSource
// ahx add end
> {
    // 视图布局
    // 滤镜滑动scroll
    UIScrollView *_effectsScroll;
    // 参数栏背景view
    UIView *_paramBackView;
    
    // 美颜按钮
    UIButton *_clearFilterBtn;
    // 美颜的边框view
    UIView *_clearFilterBorderView;
    
    // ahx add
    NSMutableArray *_thumbArray;
    UICollectionView *_collectionView;
    // ahx add end
}
@end

@implementation EffectsView

- (void)setProgress:(CGFloat)progress;
{
    _progress = progress;
    _displayView.currentLocation = _progress;
}
- (void)setEffectsCode:(NSArray<NSString *> *)effectsCode;
{
    _effectsCode = effectsCode;
    [self createCustomView];
}

// ahx add
- (instancetype)initWithFrame:(CGRect)frame thumbImageArray:(NSArray<UIImage *> *)thumbImageArray {
    self = [super initWithFrame:frame];
    if (self) {
        if (thumbImageArray.count) {
            if (thumbImageArray.count <= 10) {
                _thumbArray = [thumbImageArray mutableCopy];
            } else {
                _thumbArray = [[NSMutableArray alloc] init];
                float step = ((CGFloat)thumbImageArray.count) / 9.0;
                for (int i = 0; i < 10; i ++) {
                    int index = round(i * step);
                    if (index < thumbImageArray.count) {
                        [_thumbArray addObject:thumbImageArray[index]];
                    }
                }
            }
        }
    }
    return self;
}
// ahx add end

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame thumbImageArray:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(10, 10) viewRect:self.bounds];
}

- (void)clickDoneButton:(UIButton *)button {
    [self.effectEventDelegate effectsViewEndEditing:self];
}

- (void)createCustomView
{
    CGFloat doneButtonHeight = 50;
    
    _displayView = [[EffectsDisplayView alloc]initWithFrame:CGRectMake(10, doneButtonHeight, self.lsqGetSizeWidth - 70, 60)];
    [self addSubview:_displayView];

    CGFloat effectItemHeight = 60;
    CGFloat effectItemWidth = 60;
    CGFloat bottom = self.lsqGetSizeHeight/15;
    CGRect effectsScrollFrame = CGRectMake(10, self.lsqGetSizeHeight - effectItemHeight - bottom, self.bounds.size.width - 20, effectItemHeight);
    
    // 创建滤镜scroll
    _effectsScroll = [[UIScrollView alloc]initWithFrame:effectsScrollFrame];
    _effectsScroll.showsHorizontalScrollIndicator = false;
    _effectsScroll.bounces = false;
    [self addSubview:_effectsScroll];
    
    // 滤镜view配置参数
    CGFloat centerX = effectItemWidth/2;
    CGFloat centerY = _effectsScroll.lsqGetSizeHeight/2;
    
    NSArray *sceneEffectCodes = kSceneEffectCodeArray;
    _effectsCode = sceneEffectCodes;
    
    // 创建滤镜view
    CGFloat itemInterval = 7;
    for (int i = 0; i < _effectsCode.count; i++) {
        EffectsItemView *basicView = [EffectsItemView new];
        basicView.frame = CGRectMake(0, 0, effectItemWidth, effectItemHeight);
        basicView.center = CGPointMake(centerX, centerY);
        NSString *title = [NSString stringWithFormat:@"lsq_filter_%@", _effectsCode[i]];
        NSString *imageName = [NSString stringWithFormat:@"lsq_effect_thumb_%@",_effectsCode[i]];
        
        [basicView setViewInfoWith:imageName title:NSLocalizedStringFromTable(title,@"TuSDKConstants",@"特效") titleFontSize:12];
        basicView.eventDelegate = self;
        basicView.effectCode = _effectsCode[i];
        [_effectsScroll addSubview:basicView];

        centerX += effectItemWidth + itemInterval;
    }
    _effectsScroll.contentSize = CGSizeMake(centerX - effectItemWidth/2, _effectsScroll.bounds.size.height);
    
    // ahx flag
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightTextColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"特效 - 长按特效按钮添加";
    [self addSubview:label];
    
    UIButton *doneButton = [[UIButton alloc] init];
    [doneButton setImage:[UIImage imageNamed:@"qn_done"] forState:(UIControlStateNormal)];
    [doneButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:doneButton];

    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.size.equalTo(CGSizeMake(60, doneButtonHeight));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.centerY.equalTo(doneButton);
    }];
    if (_thumbArray.count) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(_displayView.backView.frame.size.width / _thumbArray.count, _displayView.backView.frame.size.height);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect rc = CGRectMake(0, 0, _displayView.backView.frame.size.width, _displayView.backView.frame.size.height);
        _collectionView = [[UICollectionView alloc] initWithFrame:rc collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"timelinwCell"];
        [_displayView insertSubview:_collectionView belowSubview:_displayView.backView];

        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self->_displayView.backView);
        }];
    }
    // ahx modify end
}

#pragma mark - EffectsItemViewEventDelegate

- (void)touchBeginWithSelectCode:(NSString *)effectCode;
{
    if ([self.effectEventDelegate respondsToSelector:@selector(effectsView:didSelectMediaEffectCode:)]) {
        [self.effectEventDelegate effectsView:self didSelectMediaEffectCode:effectCode];
    }
}

- (void)touchEndWithSelectCode:(NSString *)effectCode;
{
    if ([self.effectEventDelegate respondsToSelector:@selector(effectsView:didDeSelectMediaEffectCode:)]) {
        [self.effectEventDelegate effectsView:self didDeSelectMediaEffectCode:effectCode];
    }
}

// ahx add
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"timelinwCell" forIndexPath:indexPath];
    
    static NSInteger imageViewTag = 0x1234;
    
    UIImageView *imageView = [cell.contentView viewWithTag:imageViewTag];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        imageView.tag = imageViewTag;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];
    }
    
    if (_thumbArray.count > indexPath.item) {
        imageView.image = _thumbArray[indexPath.item];
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _thumbArray.count;
}
// ahx add end
@end


