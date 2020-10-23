# PLShortVideoKit 3.2.0 to 3.2.1 API Differences

## General Headers

`PLShortVideoRecorder.h`

- *Added*
 
```objc
- (nonnull instancetype)initWithVideoConfiguration:(PLSVideoConfiguration *__nonnull)videoConfiguration
                                audioConfiguration:(PLSAudioConfiguration *__nonnull)audioConfiguration
                               videoCaptureEnabled:(BOOL)videoCaptureEnabled
                               audioCaptureEnabled:(BOOL)audioCaptureEnabled;
```