# PLShortVideoKit 1.14.0 to 1.15.0 API Differences

## General Headers


```
PLSTypeDefines.h
```

- *Added* PLSWaterMarkType 

```
PLShortVideoEditor.h
```

- *Added* - (void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position size:(CGSize)size waterMarkType:(PLSWaterMarkType)type alpha:(CGFloat)alpha rotateDegree:(CGFloat)degree;

- *Added* - (void)setGifWaterMarkWithData:(NSData *)gifData position:(CGPoint)position size:(CGSize)size alpha:(CGFloat)alpha rotateDegree:(CGFloat)degree;

```
PLSEditPlayer.h
```

- *Added* - (void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position size:(CGSize)size waterMarkType:(PLSWaterMarkType)type alpha:(CGFloat)alpha rotateDegree:(CGFloat)degree;

- *Added* - (void)setGifWaterMarkWithData:(NSData *)gifData position:(CGPoint)position size:(CGSize)size alpha:(CGFloat)alpha rotateDegree:(CGFloat)degree;



```
PLSAVAssetExportSession.h
```

- *Added* @property (assign, nonatomic) float outputVideoFrameRate;


```
PLShortVideoAsset.h
```

- *Added* - (AVAsset *)scaleTimeRanges:(NSArray *)timeRangeArray toRateTypes:(NSArray *)rateTypeArray;


```
AVAsset+PLSExtendProperty.h
```

- *Added* @property (assign, nonatomic, readonly) float pls_normalFrameRate;


```
PLSVideoMixRecorder.h
```

- *Added* - (void)videoMixRecorder:(PLSVideoMixRecorder *)recorder didDeleteFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration;

- *Added* - (void)deleteLastFile;

