//
//  QNMVPickerView.m
//  ShortVideo
//
//  Created by hxiongan on 2019/5/14.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNMVPickerView.h"

@interface QNMVPickerView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <QNMVModel *> *mvModelArray;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation QNMVPickerView

- (void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadData];
        
        self.backgroundColor = QN_COMMON_BACKGROUND_COLOR;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
        self.titleLabel.textColor = [UIColor lightTextColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"MV";
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(13);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(80, 100);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.allowsSelection = YES;
        self.collectionView.allowsMultipleSelection = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
        
        [self addSubview:self.collectionView];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.height.equalTo(100);
        }];
    }
    return self;
}

- (void)loadData {
    self.mvModelArray = [[NSMutableArray alloc] init];
    
    NSString *bundlePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"mv.bundle"];
    NSString *jsonPath = [bundlePath stringByAppendingPathComponent:@"mv.json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    NSDictionary *dicFromJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"load internal filters json error: %@", error);
    
    NSArray *array = [dicFromJson objectForKey:@"MVs"];
    
    for (int i = 0; i < array.count; i++) {
        QNMVModel *model = [[QNMVModel alloc] init];
        
        NSDictionary *dic = array[i];
        
        model.name = [dic objectForKey:@"name"];
        model.coverDir = [[bundlePath stringByAppendingPathComponent:[dic objectForKey:@"coverDir"]] stringByAppendingString:@".png"];
        model.colorDir = [[bundlePath stringByAppendingPathComponent:[dic objectForKey:@"colorDir"]] stringByAppendingString:@".mp4"];
        model.alphaDir = [[bundlePath stringByAppendingPathComponent:[dic objectForKey:@"alphaDir"]] stringByAppendingString:@".mp4"];
        
        [self.mvModelArray addObject:model];
    }

    // add none modle
    QNMVModel *model = [[QNMVModel alloc] init];
    model.name = @"无";
    model.colorDir = nil;
    model.alphaDir = nil;
    model.coverDir = [bundlePath stringByAppendingPathComponent:@"mv.png"];
    
    [self.mvModelArray insertObject:model atIndex:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(10, 10) viewRect:self.bounds];
}

#pragma mark - UICollectionView delegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    static NSInteger imageViewTag = 0x1234;
    static NSInteger labelTag = 0x1235;
    
    if (nil == cell.selectedBackgroundView) {
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    UIImageView *imageView = [cell.contentView viewWithTag:imageViewTag];
    if (!imageView) {
        CGRect rc = CGRectMake((cell.bounds.size.width - 60)/2, 10, 60, 60);
        imageView = [[UIImageView alloc] initWithFrame:rc];
        imageView.tag = imageViewTag;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 60/2;
        [cell.contentView addSubview:imageView];
        int boardWidth = 3;
        rc =  CGRectMake(rc.origin.x - boardWidth, rc.origin.y - boardWidth, rc.size.width + 2 * boardWidth, rc.size.height + 2 * boardWidth);
        cell.selectedBackgroundView.frame = rc;
        cell.selectedBackgroundView.layer.borderWidth = boardWidth;
        cell.selectedBackgroundView.layer.borderColor = QN_MAIN_COLOR.CGColor;
        cell.selectedBackgroundView.layer.cornerRadius = 5;
    }
    UILabel *label = [cell.contentView viewWithTag:labelTag];
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor lightTextColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = labelTag;
        label.frame = CGRectMake(0, 75, cell.bounds.size.width, 25);
        [cell.contentView addSubview:label];
    }
    QNMVModel *mvModel = self.mvModelArray[indexPath.item];
    
    label.text =  mvModel.name;
    imageView.image = [UIImage imageWithContentsOfFile:mvModel.coverDir];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.mvModelArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    QNMVModel *model = [self.mvModelArray objectAtIndex:indexPath.row];
    [self.delegate mvPickerView:self didSelectColorDir:model.colorDir alphaDir:model.alphaDir];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)minViewHeight {
    return 150;
}

@end
