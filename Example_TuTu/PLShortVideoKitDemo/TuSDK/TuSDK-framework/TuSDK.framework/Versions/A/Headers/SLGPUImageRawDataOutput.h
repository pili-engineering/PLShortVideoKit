#import <Foundation/Foundation.h>
#import "SLGPUImageContext.h"

struct LSQGPUByteColorVector {
    GLubyte red;
    GLubyte green;
    GLubyte blue;
    GLubyte alpha;
};
typedef struct LSQGPUByteColorVector LSQGPUByteColorVector;

@protocol LSQGPUImageRawDataProcessor;

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
@interface SLGPUImageRawDataOutput : NSObject <SLGPUImageInput> {
    CGSize imageSize;
    LSQGPUImageRotationMode inputRotation;
    BOOL outputBGRA;
}
#else
@interface SLGPUImageRawDataOutput : NSObject <SLGPUImageInput> {
    CGSize imageSize;
    LSQGPUImageRotationMode inputRotation;
    BOOL outputBGRA;
}
#endif

@property(readonly) GLubyte *rawBytesForImage;
@property(nonatomic, copy) void(^newFrameAvailableBlock)(void);
@property(nonatomic) BOOL enabled;

// Initialization and teardown
- (id)initWithImageSize:(CGSize)newImageSize resultsInBGRAFormat:(BOOL)resultsInBGRAFormat;

// Data access
- (LSQGPUByteColorVector)colorAtLocation:(CGPoint)locationInImage;
- (NSUInteger)bytesPerRowInOutput;

- (void)setImageSize:(CGSize)newImageSize;

- (void)lockFramebufferForReading;
- (void)unlockFramebufferAfterReading;

@end
