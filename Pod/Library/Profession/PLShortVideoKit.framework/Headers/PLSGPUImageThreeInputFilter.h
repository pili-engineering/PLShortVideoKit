#import "PLSGPUImageTwoInputFilter.h"

extern NSString *const kPLSGPUImageThreeInputTextureVertexShaderString;

@interface PLSGPUImageThreeInputFilter : PLSGPUImageTwoInputFilter
{
    PLSGPUImageFramebuffer *thirdInputFramebuffer;

    GLint filterThirdTextureCoordinateAttribute;
    GLint filterInputTextureUniform3;
    PLSGPUImageRotationMode inputRotation3;
    GLuint filterSourceTexture3;
    CMTime thirdFrameTime;
    
    BOOL hasSetSecondTexture, hasReceivedThirdFrame, thirdFrameWasVideo;
    BOOL thirdFrameCheckDisabled;
}

- (void)disableThirdFrameCheck;

@end
