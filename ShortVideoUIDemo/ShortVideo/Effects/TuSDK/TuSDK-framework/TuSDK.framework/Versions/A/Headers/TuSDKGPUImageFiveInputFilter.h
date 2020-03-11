//
//  TuSDKGPUImageFiveInputFilter.h
//  mgushi
//
//  Created by Clear Hu on 13-9-10.
//  Copyright (c) 2013年 Lasque. All rights reserved.
//

#import "TuSDKGPUImageFourInputFilter.h"

extern NSString *const kTuSDKGPUImageFiveInputTextureVertexShaderString;

@interface TuSDKGPUImageFiveInputFilter : TuSDKGPUImageFourInputFilter
{
    SLGPUImageFramebuffer *fiveInputFramebuffer;

    GLint filterFifthTextureCoordinateAttribute;
    GLint filterInputTextureUniform5;
    LSQGPUImageRotationMode inputRotation5;
    GLuint filterSourceTexture5;
    CMTime fifthFrameTime;

    BOOL hasSetFourthTexture, hasReceivedFifthFrame, fifthFrameWasVideo;
    BOOL fifthFrameCheckDisabled;
}
- (void)disableFifthFrameCheck;
@end
