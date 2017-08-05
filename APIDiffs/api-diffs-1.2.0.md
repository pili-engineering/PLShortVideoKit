# PLShortVideoKit 1.1.1 to 1.2.0 API Differences

## General Headers


```
PLShortVideoRecorder.h
```

- *Added* @property (assign, nonatomic, readonly) BOOL captureEnabled;
- *Added* - (nonnull instancetype)initWithVideoConfiguration:(PLSVideoConfiguration *__nonnull)videoConfiguration audioConfiguration:(PLSAudioConfiguration *__nonnull)audioConfiguration captureEnabled:(BOOL)captureEnabled;;
- *Added* - (void)writePixelBuffer:(CVPixelBufferRef _Nonnull)pixelBuffer timeStamp:(CMTime)timeStamp;
- *Added* - (void)writeSampleBuffer:(CMSampleBufferRef _Nonnull)sampleBuffer;













