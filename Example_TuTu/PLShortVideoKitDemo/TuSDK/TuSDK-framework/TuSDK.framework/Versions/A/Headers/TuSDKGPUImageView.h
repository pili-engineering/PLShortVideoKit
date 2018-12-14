//
//  TuSDKGPUImageView.h
//  TuSDK
//
//  Created by wen on 10/11/2017.
//  Copyright © 2017 tusdk.com. All rights reserved.
//

#import "TuSDKGPUBaseView.h"

/**
 UIView subclass to use as an endpoint for displaying GPUImage outputs
 */
@interface TuSDKGPUImageView : TuSDKGPUBaseView

/** The fill mode dictates how images are fit in the view, with the default being kGPUImageFillModePreserveAspectRatio
 */
@property(readwrite, nonatomic) LSQGPUImageFillModeType fillMode;
@end

