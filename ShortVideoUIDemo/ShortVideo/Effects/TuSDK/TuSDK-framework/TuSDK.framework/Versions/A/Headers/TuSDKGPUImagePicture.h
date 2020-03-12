//
//  TuSDKGPUImagePicture.h
//  TuSDK
//
//  Created by Yanlin Qiu on 13/04/2017.
//  Copyright © 2017 tusdk.com. All rights reserved.
//


#import "SLGPUImage.h"

@interface TuSDKGPUImagePicture : SLGPUImagePicture

/**
 init single channal texture
 
 @param channalData image data
 @param imageSize size
 */
- (instancetype)initWithChannel:(uint8_t *)channalData
                           size:(CGSize)imageSize;

@end
