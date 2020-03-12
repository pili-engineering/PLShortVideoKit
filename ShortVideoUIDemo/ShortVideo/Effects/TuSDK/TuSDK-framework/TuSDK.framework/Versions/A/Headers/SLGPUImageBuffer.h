#import "SLGPUImageBuffer.h"
#import "SLGPUImageFilter.h"
@interface SLGPUImageBuffer : SLGPUImageFilter
{
    NSMutableArray *bufferedFramebuffers;
}

@property(readwrite, nonatomic) NSUInteger bufferSize;

@end
