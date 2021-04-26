#import "PLSGPUImageFilter.h"

@interface PLSGPUImageWatermarkFilter : PLSGPUImageFilter
{
}

- (void)setWatermarkImage:(UIImage*)image;
- (void)setWatermarkDisplaySize:(CGSize)size position:(CGPoint)position;

@end
