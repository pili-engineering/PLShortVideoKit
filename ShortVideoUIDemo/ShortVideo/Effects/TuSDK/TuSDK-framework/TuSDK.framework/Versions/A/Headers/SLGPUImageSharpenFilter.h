#import "SLGPUImageFilter.h"

@interface SLGPUImageSharpenFilter : SLGPUImageFilter
{
    GLint sharpnessUniform;
    GLint imageWidthFactorUniform, imageHeightFactorUniform;
}

// Sharpness ranges from -4.0 to 4.0, with 0.0 as the normal level
@property(readwrite, nonatomic) CGFloat sharpness; 

@end
