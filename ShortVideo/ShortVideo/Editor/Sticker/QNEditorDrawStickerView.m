//
//  QNEditorDrawStickerView.m
//  ShortVideo
//
//  Created by 冯文秀 on 2019/7/18.
//  Copyright © 2019 ahx. All rights reserved.
//

#import "QNEditorDrawStickerView.h"
#import "QNPanImageView.h"

@interface QNEditorDrawStickerView()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, assign) CMTime videoDuration;

@property (nonatomic, strong) UILabel *colorLabel;
@property (nonatomic, strong) UICollectionView *colorCollectionView;
@property (nonatomic, strong) NSMutableArray <UIColor *>* colorSource;
@property (nonatomic, strong) UIColor *currentColor;

@property (nonatomic, strong) UILabel *widthLabel;
@property (nonatomic, strong) UIView *widthView;
@property (nonatomic, strong) UISlider *widthSlider;

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong, readwrite) NSMutableArray <QNStickerModel *> *addedStickerModelArray;

@property (nonatomic, weak) QNStickerModel *currentEditingSticker;

@property (nonatomic, strong) UIImpactFeedbackGenerator *feedback;

@end

@implementation QNEditorDrawStickerView

- (instancetype)initWithVideoDuration:(CMTime)duration {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.videoDuration = duration;
        self.addedStickerModelArray = [[NSMutableArray alloc] init];
        
        self.backgroundColor = QN_COMMON_BACKGROUND_COLOR;
        
        self.doneButton = [[UIButton alloc] init];
        [self.doneButton setImage:[UIImage imageNamed:@"qn_done"] forState:(UIControlStateNormal)];
        [self.doneButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.doneButton];
        
        [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(60, 50));
            make.right.top.equalTo(self);
        }];
        
        self.clearButton = [[UIButton alloc] init];
        [self.clearButton setImage:[UIImage imageNamed:@"qn_edit_delete"] forState:(UIControlStateNormal)];
        [self.clearButton addTarget:self action:@selector(clearButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.clearButton];
        
        [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(60, 50));
            make.left.top.equalTo(self);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
        self.titleLabel.textColor = [UIColor lightTextColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"涂鸦";
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.doneButton);
        }];
        
        self.cancelButton = [[UIButton alloc] init];
        [self.cancelButton setImage:[UIImage imageNamed:@"qn_revocation"] forState:(UIControlStateNormal)];
        [self.cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.cancelButton];
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(56, 44));
            make.top.equalTo(self).offset(3.0);
            make.left.equalTo(self.clearButton.right).offset(12);
        }];
        
        self.widthLabel = [[UILabel alloc] init];
        self.widthLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
        self.widthLabel.textColor = [UIColor lightTextColor];
        self.widthLabel.textAlignment = NSTextAlignmentCenter;
        self.widthLabel.text = @"画笔大小";
        [self addSubview:self.widthLabel];
        
        self.widthView = [[UIView alloc] init];
        self.widthView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.widthView];
        
        self.widthSlider = [[UISlider alloc] init];
        self.widthSlider.minimumValue = 3.0;
        self.widthSlider.maximumValue = 30.0;
        self.widthSlider.value = 5.0;
        [self.widthSlider addTarget:self action:@selector(widthChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.widthSlider];
        
        self.colorLabel = [[UILabel alloc] init];
        self.colorLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
        self.colorLabel.textColor = [UIColor lightTextColor];
        self.colorLabel.textAlignment = NSTextAlignmentCenter;
        self.colorLabel.text = @"画笔颜色";
        [self addSubview:self.colorLabel];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(40, 40);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        CGRect frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 50);
        self.colorCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        self.colorCollectionView.delegate = self;
        self.colorCollectionView.dataSource = self;
        self.colorCollectionView.allowsMultipleSelection = NO;
        self.colorCollectionView.backgroundColor = [UIColor clearColor];
        self.colorCollectionView.showsHorizontalScrollIndicator = NO;
        [self.colorCollectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"colorCell"];
        [self addSubview:self.colorCollectionView];
        
        [self.widthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(6.0);
            make.top.equalTo(self.doneButton.mas_bottom);
            make.height.equalTo(50.f);
            make.width.equalTo(70.f);
        }];
        
        [self.widthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.widthLabel.mas_right).offset(12);
            make.centerY.equalTo(self.widthLabel);
            make.width.height.equalTo(5.f);
        }];
        
        [self.widthSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10.0);
            make.right.equalTo(self).offset(-10.0);
            make.height.equalTo(28.f);
            make.top.equalTo(self.widthLabel.mas_bottom);
        }];
        
        [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(6.0);
            make.top.equalTo(self.widthSlider.mas_bottom).offset(6);
            make.height.equalTo(26.f);
            make.width.equalTo(70.f);
        }];
        
        [self.colorCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self).offset(10);
            make.top.equalTo(self.colorLabel.mas_bottom);
            make.height.equalTo(50);
        }];
        
        self.widthView.layer.cornerRadius = 2.5f;
        [self loadColorSource];
        
        self.currentColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(10, 10) viewRect:self.bounds];
}

- (void)loadColorSource {
    self.colorSource = [[NSMutableArray alloc] init];
    NSArray *colorArray = @[QN_RGBCOLOR(255,255,255), // #FFFFFF
                            QN_RGBCOLOR(0,0,0),       // #000000
                            QN_RGBCOLOR(255,239,168), // #ffefa8
                            QN_RGBCOLOR(252,202,255), // #fccaff
                            QN_RGBCOLOR(97,220,255),  // #ffc502
                            QN_RGBCOLOR(255,197,2),   // #61dcff
                            QN_RGBCOLOR(255,134,33),  // #ff8621
                            QN_RGBCOLOR(119,119,255), // #7777ff
                            QN_RGBCOLOR(0,255,0),     // #00ff00
                            QN_RGBCOLOR(0,0,255)];    // #0000ff
    for (UIColor *color in colorArray) {
        [self.colorSource addObject:color];
    }
}

- (void)widthChange:(UISlider *)slider {
    CGFloat value = CGRectGetHeight(self.widthLabel.frame) - slider.value;
    CGFloat originY = self.widthLabel.frame.origin.y;
    if (value > 0) {
        originY = value /2 + originY;
    }
    self.widthView.frame = CGRectMake(self.widthView.frame.origin.x, originY, slider.value, slider.value);
    self.widthView.layer.cornerRadius = slider.value/2;
    
    QNStickerModel *stickerModel = [[QNStickerModel alloc] init];
    stickerModel.startPositionTime = kCMTimeZero;
    stickerModel.endPositiontime =  self.videoDuration;
    stickerModel.lineWidth = self.widthSlider.value;
    stickerModel.lineColor = self.currentColor;
    [self.delegate editorDrawStickerView:self addDrawSticker:stickerModel];
}

- (void)clickDoneButton:(UIButton *)button {
    [self.delegate editorDrawStickerViewDone:self];
}

- (void)cancelButton:(UIButton *)button {
    [self.delegate editorDrawStickerViewCancel:self];
}

- (void)clearButton:(UIButton *)button {
    [self.delegate editorDrawStickerViewClear:self];
}

- (void)alertViewAnimation:(UIView *)view {
    [UIView animateWithDuration:.2 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            view.alpha = 1;
        }];
    }];
}

#pragma mark - UICollectionView delegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colorCell" forIndexPath:indexPath];
    if (self.colorSource.count > indexPath.item) {
        static NSInteger viewTag = 0x1234;
        UIView *colorView = [cell.contentView viewWithTag:viewTag];
        if (!colorView) {
            colorView = [[UIView alloc] initWithFrame:cell.bounds];
            colorView.tag = viewTag;
            [cell.contentView addSubview:colorView];
            colorView.layer.cornerRadius = 20;
        }
        UIColor *cellColor = self.colorSource[indexPath.row];

        colorView.backgroundColor = cellColor;
        if (self.currentColor == cellColor) {
            colorView.layer.borderWidth = 2.0;
            colorView.layer.borderColor = QN_MAIN_COLOR.CGColor;
        } else {
            colorView.layer.borderWidth = 0;
        }
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colorSource.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.3 animations: ^{
            cell.transform = CGAffineTransformMakeScale(.8, .8);
        }];
    } completion:^(BOOL finished) {
        
    }];
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentColor = self.colorSource[indexPath.row];
    [collectionView reloadData];
    self.widthView.backgroundColor = self.currentColor;
    
    QNStickerModel *stickerModel = [[QNStickerModel alloc] init];
    stickerModel.startPositionTime = kCMTimeZero;
    stickerModel.endPositiontime =  self.videoDuration;
    stickerModel.lineWidth = self.widthSlider.value;
    stickerModel.lineColor = self.colorSource[indexPath.row];
    
    [self.delegate editorDrawStickerView:self addDrawSticker:stickerModel];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.3 animations: ^{
            cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

- (void)deleteSticker:(QNStickerModel *)model {
    [self.addedStickerModelArray removeObject:model];
}

- (CGFloat)minViewHeight {
    return 218;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
