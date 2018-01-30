# PLShortVideoKit 1.8.0 to 1.9.0 API Differences

## General Headers

```
PLShortVideoRecorder.h
```

- *Deprecated* - (void)shortVideoRecorderDidFocusAtPoint:(CGPoint)point;

- *Added* - (void)shortVideoRecorder:(PLShortVideoRecorder *__nonnull)recorder didFocusAtPoint:(CGPoint)point;

- *Added* - (void)getScreenShotWithCompletionHandler:(void(^_Nullable)(UIImage * _Nullable image))handle;



```
PLShortVideoEditor.h
```

- *Deprecated* - (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer;

- *Added* - (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer timestamp:(CMTime)timestamp;

- *Added* - (void)shortVideoEditor:(PLShortVideoEditor *)editor didReadyToPlayForAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange;

- *Added* - (void)shortVideoEditor:(PLShortVideoEditor *)editor didReachEndForAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange;

- *Added* @property (assign, nonatomic, readonly) BOOL isEditing;

- *Added* - (CMTime)currentTime;

- *Added* - (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler;



```
PLSEditPlayer.h
```

- *Deprecated* - (CVPixelBufferRef __nonnull)player:(PLSEditPlayer *__nonnull)player didGetOriginPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer;

- *Added* - (CVPixelBufferRef __nonnull)player:(PLSEditPlayer *__nonnull)player didGetOriginPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer timestamp:(CMTime)timestamp;

- *Added* - (void)player:(PLSEditPlayer *__nonnull)player didReadyToPlayForItem:(AVPlayerItem *__nonnull)item timeRange:(CMTimeRange)timeRange;

- *Added* - (void)player:(PLSEditPlayer *__nonnull)player didReachEndForItem:(AVPlayerItem *__nonnull)item timeRange:(CMTimeRange)timeRange;


```
PLSAVAssetExportSession
```

- *Deprecated* - (CVPixelBufferRef __nonnull)assetExportSession:(PLSAVAssetExportSession *__nonnull)assetExportSession didOutputPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer;

- *Added* - (CVPixelBufferRef __nonnull)assetExportSession:(PLSAVAssetExportSession *__nonnull)assetExportSession didOutputPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer timestamp:(CMTime)timestamp;






















