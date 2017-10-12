# PLShortVideoKit 1.4.1 to 1.5.0 API Differences

## General Headers

```
PLShortVideoEditor.h
```

- *Added* - (CVPixelBufferRef)shortVideoEditor:(PLShortVideoEditor *)editor didGetOriginPixelBuffer:(CVPixelBufferRef)pixelBuffer;
- *Added* @property (weak, nonatomic) id<PLShortVideoEditorDelegate> delegate;
- *Added* @property (strong, nonatomic, readonly) UIView *previewView;
- *Added* @property (assign, nonatomic) BOOL loopEnabled;
- *Added* @property (assign, nonatomic) CMTimeRange timeRange;
- *Added* @property (assign, nonatomic) CGSize videoSize;
- *Added* @property (assign, nonatomic, readwrite) CGFloat volume;
- *Added* - (instancetype)initWithAsset:(AVAsset *)asset videoSize:(CGSize)videoSize;
- *Added* - (void)replaceCurrentAssetWithAsset:(AVAsset *)asset;
- *Added* - (void)addFilter:(NSString *)colorImagePath; 
- *Added* - (void)addMVLayerWithColor:(NSURL *)colorURL alpha:(NSURL *)alphaURL;
- *Added* - (void)addMusic:(NSURL *)musicURL timeRange:(CMTimeRange)timeRange volume:(NSNumber *)volume;
- *Added* - (void)updateMusic:(CMTimeRange)timeRange volume:(NSNumber *)volume;
- *Added* - (void)setWaterMarkWithImage:(UIImage *)waterMarkImage position:(CGPoint)position;
- *Added* - (void)clearWaterMark;

- *Deprecated* @property (strong, nonatomic) PLSEditPlayer *player;
- *Deprecated* @property (strong, nonatomic) PLSEditPlayer *audioPlayer;


```
PLSEditPlayer.h
```

- *Added* @property (assign, nonatomic) CGSize videoSize;
- *Added* - (void)addFilter:(NSString *_Nullable)colorImagePath;
- *Added* - (void)addMVLayerWithColor:(NSURL *_Nullable)colorURL alpha:(NSURL *_Nullable)alphaURL;


```
PLSAVAssetExportSession.h
```

- *Added* @property (assign, nonatomic) CGSize outputVideoSize;
- *Added* - (void)addFilter:(NSString *_Nullable)colorImagePath;
- *Added* - (void)addMVLayerWithColor:(NSURL *_Nullable)colorURL alpha:(NSURL *_Nullable)alphaURL;


- *Added* class `PLSReverserEffect `













