# PLShortVideoKit 1.6.0 to 1.7.0 API Differences

## General Headers

- *Added* class `PLSVideoEditingView`

- *Added* class `PLSVideoEdit`

- *Added* class `PLSText`

- *Added* class `PLSImageToMovieComposer`



```
PLShortVideoRecorder.h
```

- *Added* - (void)insertVideo:(NSURL *_Nonnull)videoURL;
- *Added* - (void)mixAudio:(NSURL *_Nullable)audioURL;
- *Added* - (void)mixWithMusicVolume:(float)musicVolume videoVolume:(float)videoVolume completionHandler:(void (^_Nonnull)(AVMutableComposition * _Nullable composition, AVAudioMix * _Nullable audioMix, NSError * _Nullable error))completionHandler;



```
PLShortVideoEditor.h
```

- *Added* - (PLSPreviewOrientation)rotateVideoLayer;
- *Added* - (void)resetVideoLayerOrientation;


```
PLSEditPlayer.h
```

- *Added* - (PLSPreviewOrientation)rotateVideoLayer;
- *Added* - (void)resetVideoLayerOrientation;


```
PLSAVAssetExportSession.h
```

- *Added* @property (assign, nonatomic) PLSPreviewOrientation videoLayerOrientation;



















