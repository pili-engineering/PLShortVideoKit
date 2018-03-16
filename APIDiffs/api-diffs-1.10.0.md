# PLShortVideoKit 1.9.0 to 1.10.0 API Differences

## General Headers

```
PLSUploaderConfiguration.h
```

- *Added* @property (nonatomic, strong) NSDictionary * _Nullable params;
- *Added* - (instancetype _Nullable)initWithToken:(NSString * _Nonnull)token videoKey:(NSString * _Nullable)videoKey https:(BOOL)https recorder:(NSString * _Nullable)recorder params:(NSDictionary * _Nullable)params;


```
Added Class PLSTextSetting
Added Class PLSImageSetting
Added Class PLSFadeTranstion
Added Class PLSScaleTransition
Added Class PLSRotateTransition
Added Class PLSPositionTransition
Added Class PLSTransitionMaker

Added Class PLSRangeMedia
Added Class PLSRangeMovieExport
Added Class PLSRangeMediaTools
```













