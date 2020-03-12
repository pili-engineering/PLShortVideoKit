#import "SLGPUImageOutput.h"
#import "SLGPUImageFilter.h"

@interface SLGPUImageFilterGroup : SLGPUImageOutput <SLGPUImageInput>
{
    NSMutableArray *filters;
    BOOL isEndProcessing;
}

@property(readwrite, nonatomic, strong) SLGPUImageOutput<SLGPUImageInput> *terminalFilter;
@property(readwrite, nonatomic, strong) NSArray *initialFilters;
@property(readwrite, nonatomic, strong) SLGPUImageOutput<SLGPUImageInput> *inputFilterToIgnoreForUpdates;

// Filter management
- (void)addFilter:(SLGPUImageOutput<SLGPUImageInput> *)newFilter;
- (SLGPUImageOutput<SLGPUImageInput> *)filterAtIndex:(NSUInteger)filterIndex;
- (NSUInteger)filterCount;

@end
