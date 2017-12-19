# PLShortVideoKit 1.7.0 to 1.8.0 API Differences

## General Headers

```
PLShortVideoRecorder.h
```

- *Added* - (void)startRecording:(NSURL *_Nonnull)fileURL;


```
PLShortVideoTranscoder.h
```

- *Added* @property (assign, nonatomic) PLSPreviewOrientation rotateOrientation;


```
PLShortVideoEditor.h
```

- *Added* @property (assign, nonatomic) CGFloat delayTimeForMusicToPlay;


```
PLSImageToMovieComposer.h
```

- *Added* @property (assign, nonatomic) CGFloat transitionDuration;
- *Added* @property (assign, nonatomic) CGFloat imageDuration;





















