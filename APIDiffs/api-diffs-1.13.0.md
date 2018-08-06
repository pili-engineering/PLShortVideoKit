# PLShortVideoKit 1.11.1 to 1.13.0 API Differences

## General Headers


```
PLShortVideoTranscoder
```

- *Added* @property (assign, nonatomic) CGRect videoSelectedRect;

- *Added* @property (assign, nonatomic) CGSize destVideoSize;

- *Added* @property (assign, nonatomic) float videoFrameRate;

- *Added* + (CGRect)videoDisplay:(AVAsset *)asset bounds:(CGRect)bounds rotate:(PLSPreviewOrientation)previewOrientation;

```
PLSVideoMixRecorder.h
```

- *Added* - (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder microphoneSourceDidGetAudioBufferList:(AudioBufferList *__nonnull)audioBufferList;

- *Added* - (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder sampleSourceDidGetAudioBufferList:(AudioBufferList *__nonnull)audioBufferList; 

- *Added* - (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetMergeAudioBufferList:(AudioBufferList * __nonnull)audioBufferList;

- *Deprecated* - (CMSampleBufferRef __nonnull)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder microphoneSourceDidGetSampleBuffer:(CMSampleBufferRef __nonnull)sampleBuffer;

- *Deprecated* - (CMSampleBufferRef __nonnull)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder sampleSourceDidGetSampleBuffer:(CMSampleBufferRef __nonnull)sampleBuffer;

- *Deprecated* - (CMSampleBufferRef __nonnull)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didGetMergeAudioSampleBuffer:(CMSampleBufferRef __nonnull)sampleBuffer;







