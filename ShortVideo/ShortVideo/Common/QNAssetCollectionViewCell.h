//
//  QNAssetCollectionViewCell.h
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/26.
//  Copyright © 2019 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNAssetCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset *phAsset;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) PHImageRequestID imageRequestID;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) NSString *localIdentifier;

@end

NS_ASSUME_NONNULL_END
