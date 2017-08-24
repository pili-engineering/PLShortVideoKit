# PLShortVideoKit 1.2.1 to 1.3.0 API Differences

## General Headers

```
PLShortVideoRecorder.h
```

- *Added* @property (assign, nonatomic) BOOL adaptationRecording;
- *Added* @property (copy, nonatomic) void(^ _Nullable deviceOrientationBlock)(PLSPreviewOrientation deviceOrientation);


- *Added* class `PLSGifComposer`


```
PLSEditorPlayer.h
```

- *Added* + (PLSEditPlayer *_Nullable)audioPlayer;


```
PLSFilter.h
```

- *Added* @property (strong, nonatomic) NSString *colorImagePath;
- *Added* - (instancetype)init;


```
PLSTypeDefines.h
```

- *Added* typedef NS_ENUM(NSInteger, PLSPreviewOrientation) {
    PLSPreviewOrientationPortrait           = 1,
    PLSPreviewOrientationPortraitUpsideDown = 2,
    PLSPreviewOrientationLandscapeRight     = 3,
    PLSPreviewOrientationLandscapeLeft      = 4,
};













