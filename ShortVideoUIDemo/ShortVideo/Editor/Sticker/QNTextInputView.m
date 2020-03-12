//
//  QNTextInputView.m
//  ShortVideo
//
//  Created by hxiongan on 2019/5/16.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNTextInputView.h"
#import "QNBaseViewController.h"

@interface QNTextInputView  ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *colorBackgroundView;
@property (nonatomic, strong) UICollectionView *textSourceCollectionView;
@property (nonatomic, strong) NSMutableArray <NSString *>* fontSource;

@end

@implementation QNTextInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIVisualEffect *barEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *barView = [[UIVisualEffectView alloc] initWithEffect:barEffect];
        [self addSubview:barView];

        UIButton *cancelButton = [[UIButton alloc] init];
        UIButton *doneButton = [[UIButton alloc] init];
        [cancelButton setImage:[UIImage imageNamed:@"qn_icon_close"] forState:(UIControlStateNormal)];
        [cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:(UIControlEventTouchUpInside)];
        [doneButton setImage:[UIImage imageNamed:@"qn_done"] forState:(UIControlStateNormal)];
        [doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        [barView.contentView addSubview:cancelButton];
        [barView.contentView addSubview:doneButton];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(barView);
            make.size.equalTo(CGSizeMake(50, 50));
        }];
        
        [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(barView);
            make.size.equalTo(cancelButton);
        }];
        
        [barView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            if (iPhoneX_SERIES) {
                make.height.equalTo(100);
            } else {
                make.height.equalTo(70);
            }
        }];
        
        self.textView = [[UITextView alloc] init];
        self.textView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(barView.mas_bottom).offset(10);
            make.height.equalTo(100);
        }];
        
        UIColor *colors[] = {
            UIColor.blackColor,
            UIColor.blueColor,
            UIColor.redColor,
            UIColor.whiteColor,
            UIColor.greenColor,
            UIColor.cyanColor,
            UIColor.yellowColor,
            UIColor.brownColor,
            UIColor.magentaColor
        };
        
        self.colorBackgroundView = [[UIView alloc] init];
        [self addSubview:self.colorBackgroundView];
        [self.colorBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.textView.mas_bottom).offset(10);
            make.height.equalTo(44);
        }];
        
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (int i = 0; i < sizeof(colors)/sizeof(colors[0]); i ++) {
            UIButton *button = [[QNColorButton alloc] init];
            button.backgroundColor = colors[i];
            button.clipsToBounds = YES;
            [button addTarget:self action:@selector(clickColorButton:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [self.colorBackgroundView addSubview:button];
            [array addObject:button];
        }
        
        UIView *view = array.firstObject;
        [array mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:5 leadSpacing:20 tailSpacing:20];
        [array mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(view.mas_width);
            make.centerY.equalTo(self.colorBackgroundView);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightTextColor];
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.text = @"修改\n字体";
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightTextColor];
        line.layer.cornerRadius = .5;
        
        [self addSubview:label];
        [self addSubview:line];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(50, 50);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect rc = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 50);
        self.textSourceCollectionView = [[UICollectionView alloc] initWithFrame:rc collectionViewLayout:layout];
        self.textSourceCollectionView.delegate = self;
        self.textSourceCollectionView.dataSource = self;
        self.textSourceCollectionView.allowsMultipleSelection = NO;
        self.textSourceCollectionView.backgroundColor = [UIColor clearColor];
        self.textSourceCollectionView.showsHorizontalScrollIndicator = NO;
        [self.textSourceCollectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"sourceCell"];
        [self addSubview:self.textSourceCollectionView];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.size.equalTo(CGSizeMake(50, 50));
            make.top.equalTo(self.colorBackgroundView.mas_bottom).offset(10);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right);
            make.width.equalTo(1);
            make.centerY.equalTo(label);
            make.height.equalTo(label).offset(-20);
        }];
        
        [self.textSourceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right).offset(5);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(label);
            make.top.equalTo(label);
        }];
        
        [self loadTextSource];
    }
    return self;
}

- (void)loadTextSource {
    self.fontSource = [[NSMutableArray alloc] init];
    
    NSArray *familyNames = [UIFont familyNames];
    for (NSString* familyName in familyNames) {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        if (fontNames.count) {
            [self.fontSource addObjectsFromArray:fontNames];
        } else {
            [self.fontSource addObject:familyName];
        }
    }
}

- (void)setFont:(UIFont *)font textColor:(UIColor *)textColor {
    self.textView.font = font;
    self.textView.textColor = textColor;
}

- (void)startEditingWithText:(NSString *)text {
    self.textView.text = @"";
    [self.textView becomeFirstResponder];
    if (![text isEqualToString:@"点击输入文字"]) {
        self.textView.text = text;
    }
}

- (void)clickCancelButton {
    [self.delegate textInputCancelEditing:self];
    [self.textView resignFirstResponder];
}

- (void)clickDoneButton {
    [self.delegate textInputView:self finishEditingWithText:self.textView.text textColor:self.textView.textColor font:self.textView.font];
    [self.textView resignFirstResponder];
}

- (void)clickColorButton:(UIButton *)button {
    self.textView.textColor = button.backgroundColor;
}

#pragma mark - UICollectionView delegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sourceCell" forIndexPath:indexPath];
    
    if (self.fontSource.count > indexPath.item) {
        
        static NSInteger labelTag = 0x1234;
        
        UILabel *label = [cell.contentView viewWithTag:labelTag];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:cell.bounds];
            label.tag = labelTag;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"七牛\nQiNiu";
            label.adjustsFontSizeToFitWidth = YES;
            label.numberOfLines = 2;
            [cell.contentView addSubview:label];
            
            label.layer.borderColor = [UIColor colorWithWhite:.7 alpha:1].CGColor;
            label.layer.cornerRadius = 5;
            label.layer.borderWidth = 1;
            
        }
        label.font = [UIFont fontWithName:self.fontSource[indexPath.item] size:20];
        label.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fontSource.count;
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
    self.textView.font = [UIFont fontWithName:self.fontSource[indexPath.item] size:self.textView.font.pointSize];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.3 animations: ^{
            cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

@end




@implementation QNColorButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(touchDown:) forControlEvents:(UIControlEventTouchDown)];
        [self addTarget:self action:@selector(touchUp:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel)];
    }
    return self;
}

- (void)touchDown:(id)button {
    
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.3 animations: ^{
            self.transform = CGAffineTransformMakeScale(.8, .8);
        }];
    } completion:nil];
}

- (void)touchUp:(id)button {
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.3 animations: ^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.layer.cornerRadius = bounds.size.height / 2;
}

@end
