//
//  TransitionModelSelectView.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/1/24.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "TransitionModelSelectView.h"
#import <Masonry.h>


@implementation TextModeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] init];
        self.label.textColor = [UIColor darkGrayColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.numberOfLines = 0;
        self.label.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(2, 2, 2, 2));
        }];
    }
    return self;
}

- (void)setModel:(PLSTextModel)model {
    _model = model;
    static NSString *labelTexts[] = {
        @"标题",
        @"章节",
        @"简约",
        @"引用",
        @"标题与副标题",
        @"片尾",
    };
    self.label.text = labelTexts[model];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        
    } else {
        
    }
}

@end




static NSString *collectionCellIdentifier = @"collectionCellIdentifier";

@interface TransitionModelSelectView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation TransitionModelSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor darkGrayColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"过场字幕";
        label.textColor = [UIColor colorWithWhite:.8 alpha:1.0];
        
        UIButton *sureButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [sureButton setTintColor:[UIColor redColor]];
        [sureButton setTitle:@"确定" forState:(UIControlStateNormal)];
        [sureButton addTarget:self action:@selector(clickSureButton:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIButton *editButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [editButton setTintColor:[UIColor redColor]];
        [editButton setTitle:@"编辑" forState:(UIControlStateNormal)];
        [editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [label sizeToFit];
        [sureButton sizeToFit];
        [editButton sizeToFit];
        [self addSubview:label];
        [self addSubview:sureButton];
        [self addSubview:editButton];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(15);
            make.size.equalTo(@(label.bounds.size));
        }];
        
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(label);
            make.size.equalTo(@(sureButton.bounds.size));
        }];
        
        [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(sureButton.mas_left).offset(-20);
            make.centerY.equalTo(label);
            make.size.equalTo(@(editButton.bounds.size));
        }];
        
        CGFloat collectionViewHeight = 60;
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(collectionViewHeight, collectionViewHeight);
        layout.minimumLineSpacing = 4;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [self.collectionView registerClass:[TextModeCollectionViewCell class] forCellWithReuseIdentifier:collectionCellIdentifier];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        
        [self addSubview:self.collectionView];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(label.mas_bottom).offset(20);
            make.height.equalTo(@(collectionViewHeight));
        }];
    }
    return self;
}

- (void)clickSureButton:(UIButton *)button {
    [self.delegate modelSelectedViewSureButtonAction:self];
}

- (void)clickEditButton:(UIButton *)button {
    [self.delegate modelSelectedViewEditButtonAction:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return PLSTextModelTail - PLSTextModelBigTitle + 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TextModeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
    if (cell) {
        cell.model = PLSTextModelBigTitle + indexPath.row;
    }
    if (!cell.selectedBackgroundView) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.layer.borderWidth = 2;
        cell.selectedBackgroundView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TextModeCollectionViewCell *cell = (TextModeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.delegate modelSelectedView:self selectModel:cell.model];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.collectionView.indexPathsForSelectedItems.count) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:(UICollectionViewScrollPositionNone)];
    }
}

@end
