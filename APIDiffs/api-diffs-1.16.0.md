# PLShortVideoKit 1.15.0 to 1.16.0 API Differences

## General Headers

```
PLShortVideoEditor.h
```

- *Added* - (void)updateMultiMusics:(NSArray <NSDictionary *>*)multiMusicsSettings keepMoviePlayerStatus:(BOOL)keepStatus;

```
PLSAVAssetExportSession.h
```

- *Added* @property (assign, nonatomic) NSInteger audioBitrate;

- *Added* @property (assign, nonatomic) NSInteger audioChannel;

```
PLSRangeMediaTools.h
```

- *Added* + (AVPlayerItem *)playerItemWithRangeMedia:(NSArray<PLSRangeMedia *> *)rangeMedias videoSize:(CGSize)videoSize fillMode:(PLSVideoFillModeType)fillMode;

```
PLSRangeMovieExport.h
```

- *Added* @property (assign, nonatomic) CGSize outputVideoSize;

- *Added* @property (assign, nonatomic) PLSVideoFillModeType fillMode;

- *Added* @property (assign, nonatomic) NSInteger bitrate;

- *Deprecated* @property (assign, nonatomic) PLSFilePreset outputFilePreset;


```
PLSGifComposer.h
```

- *Added* + (void)getImagesWithVideoURL:(NSURL * _Nonnull)videoURL startTime:(float)startTime endTime:(float)endTime imageCount:(int)imageCount imageSize:(CGSize)imageSize completionBlock:(void (^)(NSError *error, NSArray *images))completionBlock;

- *Added* + (void)getImagesWithAsset:(AVAsset * _Nonnull)asset startTime:(float)startTime endTime:(float)endTime imageCount:(int)imageCount imageSize:(CGSize)imageSize completionBlock:(void (^)(NSError *error, NSArray *images))completionBlock;


```
PLSTypeDefines.h
```

- *Added* PLSAudioSampleRate_16000Hz
- *Added* PLSAudioBitRate_32Kbps
- *Added* PLSAudioBitRate_256Kbps


- *Added* class `PLSImageVideoComposer`
- *Added* class `PLSComposeMediaItem`
- *Deprecated* class `PLSImageToMovieComposer`
- *Deprecated* class `PLSMovieComposer`

