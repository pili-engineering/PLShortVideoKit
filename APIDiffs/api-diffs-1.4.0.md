# PLShortVideoKit 1.3.0 to 1.4.0 API Differences

## General Headers

```
PLSAVAssetExportSession.h
```

- *Added* @property (assign, nonatomic) BOOL isExportMovieToPhotosAlbum;


```
PLSGifComposer.h
```

- *Added* @property (assign, nonatomic) CGFloat interval;
- *Added* - (void)cancelComposeGif;


```
PLShortVideoRecorder.h
```

- *Added* @property (readwrite, nonatomic) PLSVideoRecoderRateType recoderRate;


```
PLShortVideoTranscoder.h
```

- *Added* @property (assign, nonatomic) BOOL isExportMovieToPhotosAlbum;


```
PLSTypeDefines.h
```

- *Added* NS_ENUM(NSInteger, PLSVideoRecoderRateType)


```
Added Class PLSMovieComposer
```














