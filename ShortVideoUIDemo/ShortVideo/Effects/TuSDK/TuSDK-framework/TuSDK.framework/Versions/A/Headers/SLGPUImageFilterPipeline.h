#import <Foundation/Foundation.h>
#import "SLGPUImageOutput.h"

@interface SLGPUImageFilterPipeline : NSObject
{
    NSString *stringValue;
}

@property (strong) NSMutableArray *filters;

@property (strong) SLGPUImageOutput *input;
@property (strong) id <SLGPUImageInput> output;

- (id)initWithOrderedFilters:(NSArray*) filters input:(SLGPUImageOutput*)input output:(id <SLGPUImageInput>)output;
- (id)initWithConfiguration:(NSDictionary*) configuration input:(SLGPUImageOutput*)input output:(id <SLGPUImageInput>)output;
- (id)initWithConfigurationFile:(NSURL*) configuration input:(SLGPUImageOutput*)input output:(id <SLGPUImageInput>)output;

- (void)addFilter:(SLGPUImageOutput<SLGPUImageInput> *)filter;
- (void)addFilter:(SLGPUImageOutput<SLGPUImageInput> *)filter atIndex:(NSUInteger)insertIndex;
- (void)replaceFilterAtIndex:(NSUInteger)index withFilter:(SLGPUImageOutput<SLGPUImageInput> *)filter;
- (void)replaceAllFilters:(NSArray *) newFilters;
- (void)removeFilter:(SLGPUImageOutput<SLGPUImageInput> *)filter;
- (void)removeFilterAtIndex:(NSUInteger)index;
- (void)removeAllFilters;

- (UIImage *)currentFilteredFrame;
- (UIImage *)currentFilteredFrameWithOrientation:(UIImageOrientation)imageOrientation;
- (CGImageRef)newCGImageFromCurrentFilteredFrame;

@end
