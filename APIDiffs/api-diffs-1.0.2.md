# PLShortVideoKit 1.0.1 to 1.0.2 API Differences

## General Headers

```
PLSFile.h
```

- *Added* - (void)writeMovieWithUrl:(NSURL *__nonnull)url timeRange:(CMTimeRange)timeRange filter:(id __nullable)filter;


```
PLSFileSection.h
```

- *Added* @property (assign, nonatomic) CGFloat startTime;
- *Added* @property (assign, nonatomic) CGFloat endTime;
- *Added* @property (assign, nonatomic) UIInterfaceOrientation orientation;
- *Added* @property (assign, nonatomic) CGFloat degree;
- *Added* @property (assign, nonatomic) CGSize naturalSize;
- *Added* @property (assign, nonatomic) CGSize videoSize;
- *Added* @property (assign, nonatomic) CGFloat frameRate;




