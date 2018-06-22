# PLShortVideoKit 1.10.0 to 1.11.0 API Differences

## General Headers


```
PLShortVideoRecorder.h
```

- *Added* @property (strong, nonatomic) UIView *_Nullable catpuredView;

- *Added* - (nonnull instancetype)initWithCatpuredViewVideoConfiguration:(PLSVideoConfiguration *_Nonnull)catpuredViewVideoConfiguration audioConfiguration:(PLSAudioConfiguration *_Nullable)audioConfiguration;

- *Added* @property (assign, nonatomic) BOOL backgroundMonitorEnable;

- *Added* - (void)mixAudio:(NSURL *_Nullable)audioURL playEnable:(BOOL)playEnable;

- *Added* - (void)mixAudio:(NSURL *_Nullable)audioURL startTime:(NSTimeInterval)startTime volume:(CGFloat)volume playEnable:(BOOL)playEnable;

```
PLShortVideoEditor.h
```

- *Added* - (instancetype)initWithPlayerItem:(AVPlayerItem *)playerItem videoSize:(CGSize)videoSize;

- *Added* - (void)addMusic:(NSURL *)musicURL timeRange:(CMTimeRange)timeRange volume:(NSNumber *)volume loopEnable:(BOOL)loopEnable;

- *Added* - (void)updateMultiMusics:(NSArray <NSDictionary *>*)multiMusicsSettings;


```
PLSRangeMovieExport.h
```

- *Added* @property (assign, nonatomic) PLSFilePreset outputFilePreset;



```
PLSEditSettings.h
```

- *Added* PLS_EXPORT NSString *const PLSStickerSettingsKey;

- *Added* PLS_EXPORT NSString *const PLSLocationStartTimeKey;

- *Added* PLS_EXPORT NSString *const PLSLocationDurationKey;



```
PLShortVideoTranscoder.h
```

- *Added* @property (assign, nonatomic) float bitrate;


```
PLSAVAssetExportSession.h
```
- *Added* @property (assign, nonatomic) float bitrate;


```
Added Class PLSAudioMixConfiguration
Added Class PLSVideoMixConfiguration
Added Class PLSVideoMixRecorder

Added Class PLSMixMediaItem
Added Class PLSMultiVideoMixer

Added Class PLSImageRotateRecorder

Added Class AVAsset+PLSExtendProperty

```













