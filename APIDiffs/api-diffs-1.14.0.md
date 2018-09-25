# PLShortVideoKit 1.13.1 to 1.14.0 API Differences

## General Headers


```
PLSTypeDefines.h
```

- *Added* PLSComposerPriorityType 

```
PLShortVideoEditor.h
```

- *Added* - (void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position size:(CGSize)size;


```
PLSEditPlayer.h
```

- *Added* - (void)setWaterMarkWithImage:(UIImage *__nonnull)waterMarkImage position:(CGPoint)position size:(CGSize)size;


```
PLSMovieComposer.h
```

- *Added* @property (assign, nonatomic) PLSComposerPriorityType composerPriorityType;

```
PLSImageToMovieComposer.h
```

- *Added* - (instancetype)initWithImageURLs:(NSArray<NSURL *> *)urls;


- *Deprecated* - (instancetype)initWithImages:(NSArray<UIImage *> *)images;

```
PLSReverserEffect.h
```

- *Added* @property (assign, nonatomic, getter=isAudioRemoved) BOOL audioRemoved;

