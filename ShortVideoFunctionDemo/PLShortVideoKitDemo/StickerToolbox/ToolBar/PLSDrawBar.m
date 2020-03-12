//
//  PLSDrawBar.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/7/24.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSDrawBar.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBCOLOR_ALPHA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface PLSDrawBar()
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

@property (nonatomic, strong, readwrite) NSMutableArray <PLSDrawModel *> *addedStickerModelArray;

@property (nonatomic, weak) PLSDrawModel *currentEditingSticker;
@property (nonatomic, strong) UIImpactFeedbackGenerator *feedback;

@end

@implementation PLSDrawBar

- (instancetype)initWithFrame:(CGRect)frame videoDuration:(CMTime)duration {
    self = [super initWithFrame:frame];
    if (self) {
        self.videoDuration = duration;
        
        CGFloat width = CGRectGetWidth(frame);

        self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(width - 66, 5, 50, 40)];
        [self.doneButton setImage:[UIImage imageNamed:@"qn_done"] forState:(UIControlStateNormal)];
        [self.doneButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.doneButton];
        
        self.clearButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 5, 50, 40)];
        [self.clearButton setImage:[UIImage imageNamed:@"qn_edit_delete"] forState:(UIControlStateNormal)];
        [self.clearButton addTarget:self action:@selector(clearButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.clearButton];
        
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(96, 5, 50, 40)];
        [self.cancelButton setImage:[UIImage imageNamed:@"qn_revocation"] forState:(UIControlStateNormal)];
        [self.cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.cancelButton];
        
        self.widthLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 50, 100, 50)];
        self.widthLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
        self.widthLabel.textColor = [UIColor lightTextColor];
        self.widthLabel.textAlignment = NSTextAlignmentLeft;
        self.widthLabel.text = @"画笔大小";
        [self addSubview:self.widthLabel];
        
        self.widthView = [[UIView alloc] initWithFrame:CGRectMake(120, 73, 3, 3)];
        self.widthView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.widthView];
        
        self.widthSlider = [[UISlider alloc] initWithFrame:CGRectMake(16, 106, width - 32, 20)];
        self.widthSlider.minimumValue = 3.0;
        self.widthSlider.maximumValue = 30.0;
        self.widthSlider.value = 5.0;
        [self.widthSlider addTarget:self action:@selector(widthChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.widthSlider];
        
        self.colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 130, 100, 30)];
        self.colorLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
        self.colorLabel.textColor = [UIColor lightTextColor];
        self.colorLabel.textAlignment = NSTextAlignmentLeft;
        self.colorLabel.text = @"画笔颜色";
        [self addSubview:self.colorLabel];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(30, 30);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect frame = CGRectMake(16, 168, width - 32, 40);
        self.colorCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        self.colorCollectionView.delegate = self;
        self.colorCollectionView.dataSource = self;
        self.colorCollectionView.allowsMultipleSelection = NO;
        self.colorCollectionView.backgroundColor = [UIColor clearColor];
        self.colorCollectionView.showsHorizontalScrollIndicator = NO;
        [self.colorCollectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"colorCell"];
        [self addSubview:self.colorCollectionView];
        
        self.widthView.layer.cornerRadius = 2.5f;
        [self loadColorSource];
        
        self.currentColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)loadColorSource {
    self.colorSource = [[NSMutableArray alloc] init];
    NSArray *colorArray = @[RGBCOLOR(255,255,255), // #FFFFFF
                            RGBCOLOR(0,0,0),       // #000000
                            RGBCOLOR(255,239,168), // #ffefa8
                            RGBCOLOR(252,202,255), // #fccaff
                            RGBCOLOR(97,220,255),  // #ffc502
                            RGBCOLOR(255,197,2),   // #61dcff
                            RGBCOLOR(255,134,33),  // #ff8621
                            RGBCOLOR(119,119,255), // #7777ff
                            RGBCOLOR(0,255,0),     // #00ff00
                            RGBCOLOR(0,0,255)];    // #0000ff
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
    
    PLSDrawModel *drawModel = [[PLSDrawModel alloc] init];
    drawModel.startPositionTime = kCMTimeZero;
    drawModel.endPositiontime =  self.videoDuration;
    drawModel.lineWidth = self.widthSlider.value;
    drawModel.lineColor = self.currentColor;
    if (self.delegate && [self.delegate respondsToSelector:@selector(editorDrawView:addDrawModel:)]) {
        [self.delegate editorDrawView:self addDrawModel:drawModel];
    }
}

- (void)clickDoneButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editorDrawViewDone:)]) {
        [self.delegate editorDrawViewDone:self];
    }
}

- (void)cancelButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editorDrawViewCancel:)]) {
        [self.delegate editorDrawViewCancel:self];
    }
}

- (void)clearButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editorDrawViewClear:)]) {
        [self.delegate editorDrawViewClear:self];
    }
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

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colorCell" forIndexPath:indexPath];
    if (self.colorSource.count > indexPath.item) {
        static NSInteger viewTag = 0x1234;
        UIView *colorView = [cell.contentView viewWithTag:viewTag];
        if (!colorView) {
            colorView = [[UIView alloc] initWithFrame:cell.bounds];
            colorView.tag = viewTag;
            [cell.contentView addSubview:colorView];
            colorView.layer.cornerRadius = 15;
        }
        UIColor *cellColor = self.colorSource[indexPath.row];
        
        colorView.backgroundColor = cellColor;
        if (self.currentColor == cellColor) {
            colorView.layer.borderWidth = 2.0;
            colorView.layer.borderColor = RGBCOLOR_ALPHA(65, 154, 208, 1).CGColor;;
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
    
    PLSDrawModel *drawModel = [[PLSDrawModel alloc] init];
    drawModel.startPositionTime = kCMTimeZero;
    drawModel.endPositiontime =  self.videoDuration;
    drawModel.lineWidth = self.widthSlider.value;
    drawModel.lineColor = self.colorSource[indexPath.row];

    if (self.delegate && [self.delegate respondsToSelector:@selector(editorDrawView:addDrawModel:)]) {
        [self.delegate editorDrawView:self addDrawModel:drawModel];
    }
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.3 animations: ^{
            cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

- (void)deleteDrawModel:(PLSDrawModel *)model {
    [self.addedStickerModelArray removeObject:model];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
