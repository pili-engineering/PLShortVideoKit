//
//  QNFaceUnityMakeUpView.h
//  ShortVideo
//
//  Created by hxiongan on 2019/5/4.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUMakeupSupModel.h"

NS_ASSUME_NONNULL_BEGIN

@class QNFaceUnityMakeUpView;

@protocol QNFaceUnityMakeUpViewDelegate <NSObject>

- (void)makeUpView:(QNFaceUnityMakeUpView *)makeUpView didSelectedIndex:(NSInteger)selectedIndex;

@end

@interface QNFaceUnityMakeUpView : UIView

@property (nonatomic, assign) id<QNFaceUnityMakeUpViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *itemArray;

- (void)modelChange:(FUMakeupSupModel *)model;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
