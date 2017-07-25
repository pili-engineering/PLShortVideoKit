# PLShortVideoKit 1.0.0 to 1.0.1 API Differences

## General Headers

```
PLShortVideoSession.h
```

- *Modified* `- (CVPixelBufferRef __nonnull)shortVideoSession:(PLShortVideoSession *__nonnull)session microphoneSourceDidGetPixelBuffer:(CVPixelBufferRef __nonnull)audioBuffer;
`

|      | Description                                                               |
| ---- | ------------------------------------------------------------------------- |
| From | ```- (CVPixelBufferRef __nonnull)shortVideoSession:(PLShortVideoSession *__nonnull)session microphoneSourceDidGetPixelBuffer:(CVPixelBufferRef __nonnull)audioBuffer;```                                           |
| To   | ```- (CMSampleBufferRef __nonnull)shortVideoSession:(PLShortVideoSession *__nonnull)session microphoneSourceDidGetSampleBuffer:(CMSampleBufferRef __nonnull)sampleBuffer;``` |