# PLShortVideoKit 3.1.1 to 3.2.0 API Differences

## General Headers

`PLSTypeDefines.h`

- *Added*
 
```objc
typedef enum {
    PLSTransitionTypeFade                 = 0,  // 淡入淡出
    PLSTransitionTypeNone                 = 1,  // 无
    
    PLSTransitionTypeFadeBlack            = 2,  // 闪黑    v3.2.0
    PLSTransitionTypeFadeWhite            = 3,  // 闪白    v3.2.0
    PLSTransitionTypeCircularCrop         = 4,  // 圆形    v3.2.0
    
    PLSTransitionTypeSliderUp             = 5,  // 从上飞入 v3.2.0
    PLSTransitionTypeSliderDown           = 6,  // 从下飞入 v3.2.0
    PLSTransitionTypeSliderLeft           = 7,  // 从左飞入 v3.2.0
    PLSTransitionTypeSliderRight          = 8,  // 从右飞入 v3.2.0
    
    PLSTransitionTypeWipeUp               = 9,  // 从上擦除 v3.2.0
    PLSTransitionTypeWipeDown             = 10, // 从下擦除 v3.2.0
    PLSTransitionTypeWipeLeft             = 11, // 从左擦除 v3.2.0
    PLSTransitionTypeWipeRight            = 12, // 从右擦除 v3.2.0
    
} PLSTransitionType;
```

`PLSAVAssetExportSession.h`

- *Added* 

```objc
@property(nonatomic, assign) int gopSize;
```

`PLSUploaderResponInfo.h`

- *Added* 

```objc
@property (nonatomic, copy, readonly) NSString * _Nullable xClientId;

- (instancetype _Nullable)initWithStatusCode:(int)statusCode
                                       reqId:(NSString *_Nullable)reqId
                                   xClientId:(NSString *_Nullable)xClientId
                                        xlog:(NSString *_Nullable)xlog
                                        xvia:(NSString *_Nullable)xvia
                                       error:(NSError *_Nullable)error
                                        host:(NSString *_Nullable)host
                                    duration:(double)duration
                                          id:(NSString *_Nullable)id
                                   timeStamp:(UInt64)timeStamp
                                    canceled:(BOOL)canceled
                                          ok:(BOOL)ok
                                      broken:(BOOL)broken
                                    notQiniu:(BOOL)notQiniu;
```


- *Deprecated* 

```objc
@property (nonatomic, readonly) NSString * _Nullable serverIp- *Deprecated* 

- (instancetype _Nullable)initWithStatusCode:(int)statusCode
                                       reqId:(NSString *_Nullable)reqId
                                        xlog:(NSString *_Nullable)xlog
                                        xvia:(NSString *_Nullable)xvia
                                       error:(NSError *_Nullable)error
                                        host:(NSString *_Nullable)host
                                    duration:(double)duration
                                    serverIp:(NSString *_Nullable)serverIp
                                          id:(NSString *_Nullable)id
                                   timeStamp:(UInt64)timeStamp
                                    canceled:(BOOL)canceled
                                          ok:(BOOL)ok
                                      broken:(BOOL)broken
                                    notQiniu:(BOOL)notQiniu;
```

`PLSImageToMovieComposer.h`

- *Added* 

```objc
- (void)previewVideoByPlayerItem;

- (void)updatePreviewTransitionMedias:(NSInteger)index transitionType:(PLSTransitionType)transitionType;
```

`PLSImageVideoComposer.h`

- *Added* 

```objc
@property (copy, nonatomic) void(^ _Nullable previewBlock)(AVPlayerItem* playerItem);

@property (copy, nonatomic) void(^ _Nullable previewFailureBlock)(NSError* error);

@property (assign, nonatomic) BOOL useGobalTransition;

- (void)previewVideoByPlayerItem;

- (void)updatePreviewTransitionMedias:(NSInteger)index transitionType:(PLSTransitionType)transitionType;
```
