//
//  TuSDKGPUImageSixthInputFilter.h
//  mgushi
//
//  Created by Clear Hu on 13-9-10.
//  Copyright (c) 2013年 Lasque. All rights reserved.
//

#import "TuSDKGPUImageFiveInputFilter.h"

extern NSString *const kTuSDKGPUImageSixInputTextureVertexShaderString;

@interface TuSDKGPUImageSixInputFilter : TuSDKGPUImageFiveInputFilter
{
    SLGPUImageFramebuffer *sixInputFramebuffer;

    GLint filterSixthTextureCoordinateAttribute;
    GLint filterInputTextureUniform6;
    LSQGPUImageRotationMode inputRotation6;
    GLuint filterSourceTexture6;
    CMTime sixthFrameTime;

    BOOL hasSetFifthTexture, hasReceivedSixthFrame, sixthFrameWasVideo;
    BOOL sixthFrameCheckDisabled;
}
- (void)disableSixthFrameCheck;
@end
