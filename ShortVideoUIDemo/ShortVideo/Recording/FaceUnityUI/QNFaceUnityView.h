//
//  QNFaceUnityView.h
//  ShortVideo
//
//  Created by hxiongan on 2019/4/29.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUManager.h"

@class QNFaceUnityView;
@protocol QNFaceUnityViewDelegate <NSObject>

- (void)faceUnityView:(QNFaceUnityView *)faceUnityView showTipString:(NSString *)tipString;

@end

@interface QNFaceUnityView : UIView

@property (nonatomic, weak) id<QNFaceUnityViewDelegate> delegate;
@property (nonatomic, readonly) CGFloat minViewHeight;

+ (void)setDefaultBeautyParams;

@end

