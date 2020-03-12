//
//  TuSDKGPUImageFourInputFilter.h
//  mgushi
//
//  Created by Clear Hu on 13-9-10.
//  Copyright (c) 2013年 Lasque. All rights reserved.
//

#import "TuSDKFilterAdapter.h"

extern NSString *const kTuSDKGPUImageFourInputTextureVertexShaderString;

@interface
TuSDKGPUImageFourInputFilter : TuSDKThreeInputFilter
{
    SLGPUImageFramebuffer *fourthInputFramebuffer;

    GLint filterFourthTextureCoordinateAttribute;
    GLint filterInputTextureUniform4;
    LSQGPUImageRotationMode inputRotation4;
    GLuint filterSourceTexture4;
    CMTime fourthFrameTime;

    BOOL hasSetThirdTexture, hasReceivedFourthFrame, fourthFrameWasVideo;
    BOOL fourthFrameCheckDisabled;
}

- (void)disableFourthFrameCheck;

-(void)unlockInputFramebuffer;
// glActiveTexture -> glBindTexture -> glUniform1i
-(void)renderToTextureglABUHook;
-(void)renderToTextureglVertexAttribPointerHook;
-(LSQGPUImageRotationMode)rotatedSizeHook:(NSInteger)textureIndex;
-(BOOL)newFrameReadyAtTimeHasReceivedHook;

-(BOOL)newFrameReadyAtTimeHook:(NSInteger)textureIndex frameTime:(CMTime)frameTime;
-(BOOL)newFrameReadyAtTimeHookCmTime:(CMTime)frameTime otherFrameTime:(CMTime)otherFrameTime atIndex:(NSInteger)textureIndex;
-(void)newFrameReadyAtTimeHookReceivedFramesAtIndex:(NSInteger)textureIndex;
-(void)newFrameReadyAtTimeHookAllReceivedFrames:(BOOL)isReceived;
@end
