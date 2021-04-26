#import "PLSGPUImageOutput.h"
#import "PLSGPUImageFilter.h"

@interface PLSGPUImageFilterGroup : PLSGPUImageOutput <PLSGPUImageInput>
{
    NSMutableArray *filters;
    BOOL isEndProcessing;
}

@property(readwrite, nonatomic, strong) PLSGPUImageOutput<PLSGPUImageInput> *terminalFilter;
@property(readwrite, nonatomic, strong) NSArray *initialFilters;
@property(readwrite, nonatomic, strong) PLSGPUImageOutput<PLSGPUImageInput> *inputFilterToIgnoreForUpdates; 

// Filter management
- (void)addFilter:(PLSGPUImageOutput<PLSGPUImageInput> *)newFilter;
- (PLSGPUImageOutput<PLSGPUImageInput> *)filterAtIndex:(NSUInteger)filterIndex;
- (NSUInteger)filterCount;

@end
