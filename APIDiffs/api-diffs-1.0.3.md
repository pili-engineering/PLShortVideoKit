# PLShortVideoKit 1.0.2 to 1.0.3 API Differences

## General Headers

```
PLSEditor.h
```

- *Added* class `PLSAudio`
- *Added* class `PLSMovie`
- *Added* @property (nonatomic, strong) AVAudioPlayer *audioPlayer;
- *Added* @property (nonatomic, strong) PLSAudio *audio;
- *Added* @property (nonatomic, strong) PLSMovie *movie;
- *Added* @property (assign, nonatomic) CGFloat videoStartTime;
- *Added* @property (assign, nonatomic) CGFloat videoEndTime;
- *Added* @property (assign, nonatomic) CGFloat videoVolume;
- *Added* @property (strong, nonatomic) NSURL *audioURL;
- *Added* @property (strong, nonatomic) NSString *audioFileName;
- *Added* @property (assign, nonatomic) CGFloat audioStartTime;
- *Added* @property (assign, nonatomic) CGFloat audioDuration;
- *Added* @property (assign, nonatomic) CGFloat audioVolume;
- *Added* + (instancetype)sharedInstance;


```
PLSEditor.h
```

- *Added* @property (strong, nonatomic) PLSAudio *__nullable audio;
- *Added* @property (assign, nonatomic) CGFloat volume;





