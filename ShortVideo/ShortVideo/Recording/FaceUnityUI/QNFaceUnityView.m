//
//  QNFaceUnityView.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/29.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNFaceUnityView.h"
#import "QNFaceUnityBeautyView.h"
#import "QNFaceUnityMakeUpView.h"
#import "FULiveModel.h"
#import "FUMakeupModel.h"

@interface QNFaceUnityView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
QNFaceUnityBeautyViewDelegate,
QNFaceUnityMakeUpViewDelegate
>

@property (nonatomic, strong) UIButton *noneButton;
@property (nonatomic, strong) UIScrollView *barScrollView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) QNFaceUnityBeautyView *beautyView;// 美颜
@property (nonatomic, strong) QNFaceUnityMakeUpView *makeupView;// 美妆
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *currentValueLabel;

@property (nonatomic, strong) FULiveModel *currentModel;
@property (nonatomic, strong) UIView *highlightedLine;

@property (nonatomic, strong) UIView *sliderView;

@end

@implementation QNFaceUnityView

+ (void)setDefaultBeautyParams {
    // 重置默认参数
    [[FUManager shareManager] setBeautyDefaultParameters];
    
    // 这里的滤镜设置为原始,即就是不做滤镜处理。否则画面太美不敢看
    [FUManager shareManager].selectedFilter = @"origin";
    
    // 七牛短视频 SDK 中自带的美颜已经关闭，这里打开相芯科技的美白、红润等参数
    [FUManager shareManager].skinDetectEnable = YES;
    [FUManager shareManager].whiteLevel = 0.6;
    [FUManager shareManager].blurShape = 0;
    [FUManager shareManager].redLevel = 0.6;
    [FUManager shareManager].blurLevel = 0.6;
}

+ (void)setDefaultMakeupParams {
    
}

- (CGFloat)minViewHeight {
    return 226;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *dataSource = [[FUManager shareManager] dataSource];
        self.currentModel = [dataSource objectAtIndex:0];
        
        self.sliderView = [[UIView alloc] init];
        [self addSubview:_sliderView];
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(56);
        }];
        
        self.slider = [[UISlider alloc] init];
        [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:(UIControlEventValueChanged)];
        self.slider.continuous = YES;
        self.slider.maximumValue = 1;
        self.slider.minimumValue = 0;
        self.slider.minimumTrackTintColor = UIColor.whiteColor;
        self.slider.maximumTrackTintColor = UIColor.grayColor;
        self.slider.value = [FUManager shareManager].enlargingLevel;
        [self.sliderView addSubview:_slider];
        
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.sliderView).offset(40);
            make.right.equalTo(self.sliderView).offset(-40);
            make.bottom.equalTo(self.sliderView).offset(-10);
        }];
        
        self.currentValueLabel = [[UILabel alloc] init];
        self.currentValueLabel.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightRegular)];
        self.currentValueLabel.textColor = [UIColor lightTextColor];
        self.currentValueLabel.textAlignment = NSTextAlignmentCenter;
        [self.sliderView addSubview:self.currentValueLabel];
        
        [self updateLabel];
        
        UIView *unityView = [[UIView alloc] init];
        unityView.backgroundColor = QN_COMMON_BACKGROUND_COLOR;
        [self addSubview:unityView];
        [unityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.sliderView.mas_bottom);
            make.bottom.equalTo(self);
        }];
        
        UIView *barView = [[UIView alloc] init];
        barView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:.2];
        [unityView addSubview:barView];
        [barView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(unityView);
            make.height.equalTo(44);
        }];
        
        self.highlightedLine = [[UIView alloc] init];
        self.highlightedLine.backgroundColor = [UIColor whiteColor];
        
        self.noneButton = [[UIButton alloc] init];
        [self.noneButton setImage:[UIImage imageNamed:@"qn_none_filter"] forState:(UIControlStateNormal)];
        [self.noneButton addTarget:self action:@selector(clickNoneButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [unityView addSubview:self.noneButton];
        
        self.barScrollView = [[UIScrollView alloc] init];
        self.barScrollView.showsHorizontalScrollIndicator = NO;
        [self.barScrollView addSubview:self.highlightedLine];
        
        NSInteger originX = 20;
        for (int i = 0; i < dataSource.count; i ++) {
            FULiveModel *model = [dataSource objectAtIndex:i];
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [button setTitle:model.title forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:(UIControlStateSelected)];
            [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:.5] forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(clickModelTypeButton:) forControlEvents:(UIControlEventTouchUpInside)];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button sizeToFit];
            button.tag = model.type;
            
            CGFloat width = MAX(44, button.bounds.size.width);
            CGRect rc = CGRectMake(originX, 0, width, 44);
            originX += rc.size.width + 20;
            button.frame = rc;
            [self.barScrollView addSubview:button];
            
            if (model.type == self.currentModel.type) {
                button.selected = YES;
                self.highlightedLine.frame = CGRectMake(rc.origin.x, rc.origin.y + rc.size.height - 2, rc.size.width, 2);
            }
        }
        [unityView addSubview:self.barScrollView];
        [self.barScrollView setContentSize:CGSizeMake(originX, 44)];
        
        UIView *spaceLine = [[UIView alloc] init];
        spaceLine.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.5];
        [self.noneButton addSubview:spaceLine];
        [spaceLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.noneButton);
            make.centerY.equalTo(self.noneButton);
            make.width.equalTo(1);
            make.height.equalTo(self.noneButton).offset(-10);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(60, 60);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        CGRect rc = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 60);
        self.collectionView = [[UICollectionView alloc] initWithFrame:rc collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.alwaysBounceVertical = YES;
        [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"Cell"];
        [unityView addSubview:self.collectionView];
        
        [self.noneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(unityView);
            make.size.equalTo(CGSizeMake(60, 44));
        }];
        
        [self.barScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.noneButton.mas_right);
            make.top.right.equalTo(unityView);
            make.height.equalTo(self.noneButton);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(unityView);
            make.top.equalTo(self.barScrollView.mas_bottom);
        }];
        
        self.beautyView = [[QNFaceUnityBeautyView alloc] init];
        self.beautyView.delegate = self;
        
        self.makeupView = [[QNFaceUnityMakeUpView alloc] init];
        self.makeupView.delegate = self;
        
        [unityView addSubview:self.makeupView];
        [unityView addSubview:self.beautyView];
        self.makeupView.hidden = YES;
        [self.beautyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.collectionView);
        }];
        [self.makeupView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.collectionView);
        }];
        self.collectionView.hidden = YES;
    }
    return self;
}

- (void)beautyView:(QNFaceUnityBeautyView *)beautyView didSelectedIndex:(NSInteger)selectedIndex {
    switch (selectedIndex) {
        case 0:
            self.slider.value = [FUManager shareManager].enlargingLevel_new;
            break;
        case 1:
            self.slider.value = [FUManager shareManager].thinningLevel_new;
            break;
        case 2:
            self.slider.value = [FUManager shareManager].jewLevel;
            break;
        case 3:
            self.slider.value = [FUManager shareManager].foreheadLevel;
            break;
        case 4:
            self.slider.value = [FUManager shareManager].noseLevel;
            break;
        case 5:
            self.slider.value = [FUManager shareManager].mouthLevel;
            break;
        case 6:
            self.slider.value = [FUManager shareManager].blurLevel;
            break;
        case 7:
            self.slider.value = [FUManager shareManager].whiteLevel;
            break;
        case 8:
            self.slider.value = [FUManager shareManager].redLevel;
            break;
        case 9:
            self.slider.value = [FUManager shareManager].eyelightingLevel;
            break;
        case 10:
            self.slider.value = [FUManager shareManager].beautyToothLevel;
            break;
        default:
            break;
    }
    [self updateLabel];
}

- (void)makeUpView:(QNFaceUnityMakeUpView *)makeUpView didSelectedIndex:(NSInteger)selectedIndex {
    FUMakeupSupModel *model = makeUpView.itemArray[selectedIndex];
    [self.slider setValue:model.value animated:YES];
    [makeUpView modelChange:model];
    [self updateLabel];
    self.slider.hidden = 0 == selectedIndex;
    self.currentValueLabel.hidden = 0 == selectedIndex;
}

- (void)sliderValueChange:(UISlider *)slider {
    if (FULiveModelTypeBeautifyFace == self.currentModel.type) {
        NSArray *paths = [self.beautyView.collectionView indexPathsForSelectedItems];
        if (paths.count) {
            [self updateLabel];
            NSIndexPath *indexPath = paths.firstObject;
            switch (indexPath.row) {
                case 0:
                    [FUManager shareManager].enlargingLevel_new = slider.value;
                    return;
                case 1:
                    [FUManager shareManager].thinningLevel_new = slider.value;
                    return;
                case 2:
                    [FUManager shareManager].jewLevel = slider.value;
                    return;
                case 3:
                    [FUManager shareManager].foreheadLevel = slider.value;
                    return;
                case 4:
                    [FUManager shareManager].noseLevel = slider.value;
                    return;
                case 5:
                    [FUManager shareManager].mouthLevel = slider.value;
                    return;
                case 6:
                    [FUManager shareManager].blurLevel = slider.value;
                    return;
                case 7:
                    [FUManager shareManager].whiteLevel = slider.value;
                    return;
                case 8:
                    [FUManager shareManager].redLevel = slider.value;
                    return;
                case 9:
                    [FUManager shareManager].eyelightingLevel = slider.value;
                    return;
                case 10:
                    [FUManager shareManager].beautyToothLevel = slider.value;
                    return;
                default:
                    break;
            }
        }
    } else if (FULiveModelTypeMakeUp == self.currentModel.type) {
        NSArray *paths = [self.makeupView.collectionView indexPathsForSelectedItems];
        if (paths.count) {
            NSIndexPath *indexPath = paths.firstObject;
            FUMakeupSupModel *model = self.makeupView.itemArray[indexPath.row];
            model.value = slider.value;
            [self.makeupView modelChange:model];
            [self updateLabel];
        }
    }
}

- (void)updateLabel {
    CGRect trackRect = [self.slider trackRectForBounds:self.slider.bounds];
    CGRect thumbRect = [self.slider thumbRectForBounds:self.slider.bounds
                                             trackRect:trackRect
                                                 value:self.slider.value];
    NSInteger value = self.slider.value * 100;
    self.currentValueLabel.text = [NSString stringWithFormat:@"%ld", (long)value];
    [self.currentValueLabel sizeToFit];
    
    CGRect rc = thumbRect;
    rc.origin.x += self.slider.frame.origin.x;
    rc.origin.y = self.slider.frame.origin.y - self.currentValueLabel.bounds.size.height - 10;
    rc.size.width = self.currentValueLabel.bounds.size.width;
    rc.origin.x += (thumbRect.size.width - rc.size.width) / 2;
    self.currentValueLabel.frame = rc;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(10, 10) viewRect:self.bounds];
}

- (void)clickNoneButton:(UIButton *)button {
    if (FULiveModelTypeBeautifyFace == self.currentModel.type) {
        [self.class setDefaultBeautyParams];
        [self.beautyView reset];
        [self.delegate faceUnityView:self showTipString:@"所有美颜效果恢复默认"];
    } else if (FULiveModelTypeMakeUp == self.currentModel.type) {
        [self.class setDefaultMakeupParams];
        [self.makeupView reset];
    } else {
        
        if (FULiveModelTypeHair == self.currentModel.type) {
            [[FUManager shareManager] setHairColor:0];
            [[FUManager shareManager] setHairStrength:0.0];
        } else if (FULiveModelTypeAnimoji == self.currentModel.type ) {
            [[FUManager shareManager] loadFilterAnimoji:@"noitem" style:0];
            [[FUManager shareManager] destoryAnimojiFaxxBundle];
        }
        [[FUManager shareManager] loadItem:nil];
        
        NSArray *arr = self.collectionView.indexPathsForSelectedItems;
        
        if (arr.count) {
            [self.collectionView deselectItemAtIndexPath:arr[0] animated:YES];
        }
    }
}

- (void)clickModelTypeButton:(UIButton *)button {
    if (button.tag == self.currentModel.type) return;
    
    for (UIView *subView in self.barScrollView.subviews) {
        if ([subView isKindOfClass:UIButton.class]) {
            UIButton *b = (UIButton *)subView;
            if (b.isSelected) {
                b.selected = NO;
                break;
            }
        }
    }

    button.selected = YES;

    if (FULiveModelTypeAnimoji == self.currentModel.type) {
        [[FUManager shareManager] destoryAnimojiFaxxBundle];
    }
    
    for (FULiveModel *model in [FUManager shareManager].dataSource) {
        if ((model.type == button.tag)) {
            self.currentModel = model;
            break;
        }
    }
    
    [FUManager shareManager].currentModel = self.currentModel;
    
    if (FULiveModelTypeBeautifyFace == self.currentModel.type) {
        self.beautyView.hidden = NO;
        self.collectionView.hidden = YES;
        self.makeupView.hidden = YES;
        self.sliderView.hidden = NO;
    } else if (FULiveModelTypeMakeUp == self.currentModel.type) {
        self.makeupView.hidden = NO;
        self.beautyView.hidden = YES;
        self.collectionView.hidden = YES;
        self.sliderView.hidden = NO;
    } else {
        self.collectionView.hidden = NO;
        self.beautyView.hidden = YES;
        self.makeupView.hidden = YES;
        self.sliderView.hidden = YES;
    }
    
    if (FULiveModelTypeAnimoji == self.currentModel.type) {
        [[FUManager shareManager] loadAnimojiFaxxBundle];
        [[FUManager shareManager] set3DFlipH];
    }
    
    if (FULiveModelTypeHair == self.currentModel.type) {
        [[FUManager shareManager] loadItem:@"hair_gradient"];
        [[FUManager shareManager] setHairColor:0];
        [[FUManager shareManager] setHairStrength:0.5];
    }
    
    [self reloadItem];
    
    CGRect rc = button.frame;
    CGFloat x = CGRectGetMidX(rc);
    x = x - self.barScrollView.frame.size.width / 2;
    x = MAX(0, x);
    x = MIN(self.barScrollView.contentSize.width - self.barScrollView.frame.size.width, x);
    CGPoint contentOffset = CGPointMake(x, 0);
    [UIView animateWithDuration:.3 animations:^{
        self.highlightedLine.frame = CGRectMake(rc.origin.x, rc.origin.y + rc.size.height - 2, rc.size.width, 2);
        [self.barScrollView setContentOffset:contentOffset];
    }];
}

- (void)reloadItem {
    [self.collectionView reloadData];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
    static NSInteger imageViewTag = 0x1234;
    
    UIImageView *imageView = [cell.contentView viewWithTag:imageViewTag];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        imageView.tag = imageViewTag;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 5;
        [cell.contentView addSubview:imageView];
        
        int boardWidth = 3;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(boardWidth, boardWidth, boardWidth, boardWidth));
        }];
        
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.frame = cell.bounds;
        cell.selectedBackgroundView.layer.borderWidth = boardWidth;
        cell.selectedBackgroundView.layer.borderColor = QN_MAIN_COLOR.CGColor;
        cell.selectedBackgroundView.layer.cornerRadius = 5;
    }
    
    imageView.image = [UIImage imageNamed:self.currentModel.items[indexPath.row]];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentModel.items.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    int index = (int)indexPath.row;
    if (FULiveModelTypeHair == self.currentModel.type) {
        
        if(index < 5) {//渐变色
            [[FUManager shareManager] loadItem:@"hair_gradient"];
            [[FUManager shareManager] setHairColor:index];
            [[FUManager shareManager] setHairStrength:.5];
        } else {
            [[FUManager shareManager] loadItem:@"hair_color"];
            [[FUManager shareManager] setHairColor:index - 5];
            [[FUManager shareManager] setHairStrength:.5];
        }
        
    } else if (FULiveModelTypeAnimoji == self.currentModel.type) {
        
        // animoji 分普通和动漫模式，详细使用方式请查看相芯科技的官方 Demo：FULiveDemo
        NSString *item = [self.currentModel.items objectAtIndex:index];
//        [[FUManager shareManager] loadItem:item];
        
        // 此处使用了动漫滤镜，因为 animoji 会被 AppStore 拒绝
        NSArray *array = [item componentsSeparatedByString:@"toonfilter"];
        int type = [array.lastObject intValue];
        [[FUManager shareManager] loadFilterAnimoji:item style:[self comicStyleIndex:type]];
    } else {
        //道具贴纸, AR 面具, 手势识别, 哈哈镜, 人像驱动, 背景分隔, 表情识别, 换脸
        NSString *item = [self.currentModel.items objectAtIndex:index];
        [[FUManager shareManager] loadItem:item];
        
        /* 普通道具中手势道具，触发位置根据j情况调节 */
        if (self.currentModel.type == FULiveModelTypeGestureRecognition) {
            [[FUManager shareManager] setLoc_xy_flip];
        }
        
        NSString *tipString = [[FUManager shareManager] hintForItem:item];
        if (tipString.length > 0) {
            [self.delegate faceUnityView:self showTipString:tipString];
        }
    }
}

#pragma  mark -  动漫滤镜顺序

- (int)comicStyleIndex:(NSInteger)index{
    switch (index) {
        case 1:
            return 0;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        default:
            return (int)index - 1;
            break;
    }
    return 0;
}

@end
