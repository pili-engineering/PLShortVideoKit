#import "SLGPUImageOutput.h"

// The bytes passed into this input are not copied or retained, but you are free to deallocate them after they are used by this filter.
// The bytes are uploaded and stored within a texture, so nothing is kept locally.
// The default format for input bytes is LSQGPUPixelFormatBGRA, unless specified with pixelFormat:
// The default type for input bytes is LSQGPUPixelTypeUByte, unless specified with pixelType:

typedef enum {
	LSQGPUPixelFormatBGRA = GL_BGRA,
	LSQGPUPixelFormatRGBA = GL_RGBA,
	LSQGPUPixelFormatRGB = GL_RGB,
    LSQGPUPixelFormatLuminance = GL_LUMINANCE
} LSQGPUPixelFormat;

typedef enum {
	LSQGPUPixelTypeUByte = GL_UNSIGNED_BYTE,
	LSQGPUPixelTypeFloat = GL_FLOAT
} LSQGPUPixelType;

@interface SLGPUImageRawDataInput : SLGPUImageOutput
{
    CGSize uploadedImageSize;
	
	dispatch_semaphore_t dataUpdateSemaphore;
}

// Initialization and teardown
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize;
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize pixelFormat:(LSQGPUPixelFormat)pixelFormat;
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize pixelFormat:(LSQGPUPixelFormat)pixelFormat type:(LSQGPUPixelType)pixelType;

/** Input data pixel format
 */
@property (readwrite, nonatomic) LSQGPUPixelFormat pixelFormat;
@property (readwrite, nonatomic) LSQGPUPixelType   pixelType;

// Image rendering
- (void)updateDataFromBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize;
- (void)processData;
- (void)processDataForTimestamp:(CMTime)frameTime;
- (CGSize)outputImageSize;

@end
