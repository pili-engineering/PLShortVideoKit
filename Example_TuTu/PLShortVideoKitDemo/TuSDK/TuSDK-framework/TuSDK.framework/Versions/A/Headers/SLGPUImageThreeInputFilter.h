#import "SLGPUImageTwoInputFilter.h"

extern NSString *const LSQKGPUImageThreeInputTextureVertexShaderString;

@interface SLGPUImageThreeInputFilter : SLGPUImageTwoInputFilter
{
    SLGPUImageFramebuffer *thirdInputFramebuffer;

    GLint filterThirdTextureCoordinateAttribute;
    GLint filterInputTextureUniform3;
    LSQGPUImageRotationMode inputRotation3;
    GLuint filterSourceTexture3;
    CMTime thirdFrameTime;
    
    BOOL hasSetSecondTexture, hasReceivedThirdFrame, thirdFrameWasVideo;
    BOOL thirdFrameCheckDisabled;
}

- (void)disableThirdFrameCheck;

@end
