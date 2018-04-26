//
//  TuSDKICGuideRegionView.h
//  TuSDK
//
//  Created by Yanlin on 10/15/15.
//  Copyright © 2015 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuSDKICGuideRegionView : UIView
{
    // 选区信息
    CGRect _regionRect;
    
    // 是否显示辅助线
    BOOL _displayGuideLine;
}

/**
 *  辅助线颜色 (默认:lsqRGBA(255, 255, 255, 0.6))
 */
@property (nonatomic, retain) UIColor *guideLineColor;

/**
 *  辅助线宽度 (默认:1)
 */
@property (nonatomic) CGFloat guideLineWidth;

/**
 *  是否显示辅助线
 */
@property (nonatomic) BOOL displayGuideLine;


/**
 *  显示区域
 */
@property (nonatomic) CGRect displayRect;

@end
