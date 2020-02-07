# PLShortVideoKit 3.1.0 to 3.1.1 API Differences

## General Headers

`PLShortVideoRecorder`

- *Deprecated* 

```objc
- (CVPixelBufferRef __nonnull)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder cameraSourceDidGetPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer;
```

- *Added*
 
```objc
- (CVPixelBufferRef __nonnull)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder cameraSourceDidGetPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer timingInfo:(CMSampleTimingInfo)timingInfo;
```

`PLSTypeDefines`

- *Added* 

```objc
typedef enum {
    PLSVideoHardwareTypeH264 = 0,
    PLSVideoHardwareTypeHEVC = 1,  // iOS 11.0 及以上版本支持，即 hvc1
} PLSVideoHardwareType;
```
*Warning* You can set it, such as `PLSVideoConfiguration`、`PLShortVideoTranscoder`、`PLSAVAssetExportSession`、`PLSImageToMovieComposer`、`PLSRangeMovieExport`、`PLSMultiVideoMixer`、`PLSImageVideoComposer`、`PLSGifToMovieConverter`、`PLSImageToMovieConverter`