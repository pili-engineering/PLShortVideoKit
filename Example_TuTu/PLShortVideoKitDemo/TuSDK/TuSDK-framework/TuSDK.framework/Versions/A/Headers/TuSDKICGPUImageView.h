//
//  TuSDKGPUImageView.h
//  TuSDK
//
//  Created by wen on 2017/5/10.
//  Copyright © 2017年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLGPUImage.h"


typedef NS_ENUM(NSUInteger, TuSDKICGPUImageFillModeType) {
    kTuSDKICGPUImageFillModeStretch,                       // Stretch to fill the full view, which may distort the image outside of its normal aspect ratio
    kTuSDKICGPUImageFillModePreserveAspectRatio,           // Maintains the aspect ratio of the source image, adding bars of the specified background color
    kTuSDKICGPUImageFillModePreserveAspectRatioAndFill     // Maintains the aspect ratio of the source image, zooming in on its center to fill the view
};

@interface TuSDKICGPUImageView : UIView <SLGPUImageInput>{
    LSQGPUImageRotationMode inputRotation;
}


/** The fill mode dictates how images are fit in the view, with the default being kGPUImageFillModePreserveAspectRatio
 */
@property(readwrite, nonatomic) LSQGPUImageFillModeType fillMode;

/** This calculates the current display size, in pixels, taking into account Retina scaling factors
 */
@property(readonly, nonatomic) CGSize sizeInPixels;

@property(nonatomic) BOOL enabled;

/**
 *  裁剪区域范围，均以比例表示：{{offsetX/allWidth,offsetY/allHeight}，{sizeWidth/allWidth,sizeHeight/allHeight}}
 */
@property (nonatomic, assign) CGRect cropRect;

/** Handling fill mode
 
 @param redComponent Red component for background color
 @param greenComponent Green component for background color
 @param blueComponent Blue component for background color
 @param alphaComponent Alpha component for background color
 */
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;

- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;

@end
