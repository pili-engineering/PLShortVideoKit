# PLShortVideoKit 1.5.0 to 1.6.0 API Differences

## General Headers

```
PLShortVideoRecorder.h
```

- *Added*@property (assign, nonatomic) PLSFileType outputFileType;
- *Added* - (AVAsset *_Nullable)mixAsset:(AVAsset *_Nullable)asset timeRange:(CMTimeRange)timeRange;
- *Added* @property (assign, nonatomic) BOOL innerFocusViewShowEnable;
- *Added* - (void)shortVideoRecorderDidFocusAtPoint:(CGPoint)point;



```
PLSMovieComposer.h
```

- *Added* @property (assign, nonatomic) PLSFileType outputFileType;
- *Added* @property (assign, nonatomic) int videoFrameRate;
- *Added* @property (assign, nonatomic) float bitrate;


- *Added* class `PLShortVideoAsset`













