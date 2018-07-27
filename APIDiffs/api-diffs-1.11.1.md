# PLShortVideoKit 1.11.0 to 1.11.1 API Differences

## General Headers


```
PLSVideoMixRecorder.h
```

- *Remove* - (void)videoMixRecorder:(PLSVideoMixRecorder *__nonnull)recorder didFinishRecordingMaxDuration:(CGFloat)maxDuration;

- *Remove* @property (assign, nonatomic) CGFloat maxDuration;

- *Remove* @property (assign, nonatomic) CGFloat minDuration;

- *Remove* - (void)finishRecording;

- *Added* @property (assign, nonatomic) BOOL backgroundMonitorEnable;












