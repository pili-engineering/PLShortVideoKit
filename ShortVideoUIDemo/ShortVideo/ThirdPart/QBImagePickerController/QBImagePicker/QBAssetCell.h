//
//  QBAssetCell.h
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QBVideoIndicatorView;

@interface QBAssetCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet QBVideoIndicatorView *videoIndicatorView;

@property (nonatomic, assign) BOOL showsOverlayViewWhenSelected;

@property (nonatomic, strong) NSString *infoString;
@property (nonatomic, assign) BOOL isICloudAsset;

@end
