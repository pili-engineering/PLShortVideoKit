#import "SLGPUImageVideoCamera.h"

void LSQStillImageDataReleaseCallback(void *releaseRefCon, const void *baseAddress);
void LSQGPUImageCreateResizedSampleBuffer(CVPixelBufferRef cameraFrame, CGSize finalSize, CMSampleBufferRef *sampleBuffer);

@interface SLGPUImageStillCamera : SLGPUImageVideoCamera

/** The JPEG compression quality to use when capturing a photo as a JPEG.
 */
@property CGFloat jpegCompressionQuality;

// Only reliably set inside the context of the completion handler of one of the capture methods
@property (readonly) NSDictionary *currentCaptureMetadata;

// Photography controls
- (void)capturePhotoAsSampleBufferWithCompletionHandler:(void (^)(CMSampleBufferRef imageSampleBuffer, NSError *error))block;
- (void)capturePhotoAsImageProcessedUpToFilter:(SLGPUImageOutput<SLGPUImageInput> *)finalFilterInChain withCompletionHandler:(void (^)(UIImage *processedImage, NSError *error))block;
- (void)capturePhotoAsImageProcessedUpToFilter:(SLGPUImageOutput<SLGPUImageInput> *)finalFilterInChain withOrientation:(UIImageOrientation)orientation withCompletionHandler:(void (^)(UIImage *processedImage, NSError *error))block;
- (void)capturePhotoAsJPEGProcessedUpToFilter:(SLGPUImageOutput<SLGPUImageInput> *)finalFilterInChain withCompletionHandler:(void (^)(NSData *processedJPEG, NSError *error))block;
- (void)capturePhotoAsJPEGProcessedUpToFilter:(SLGPUImageOutput<SLGPUImageInput> *)finalFilterInChain withOrientation:(UIImageOrientation)orientation withCompletionHandler:(void (^)(NSData *processedJPEG, NSError *error))block;
- (void)capturePhotoAsPNGProcessedUpToFilter:(SLGPUImageOutput<SLGPUImageInput> *)finalFilterInChain withCompletionHandler:(void (^)(NSData *processedPNG, NSError *error))block;
- (void)capturePhotoAsPNGProcessedUpToFilter:(SLGPUImageOutput<SLGPUImageInput> *)finalFilterInChain withOrientation:(UIImageOrientation)orientation withCompletionHandler:(void (^)(NSData *processedPNG, NSError *error))block;

@end
