# PLShortVideoKit 3.0.0 to 3.1.0 API Differences

## General Headers

`PLSComposeMediaItem`

- *Added* @property (assign, nonatomic) CMTimeRange timeRange;

`PLSTypeDefines`

- *Added* 

```objc
typedef enum {
    PLSTransitionTypeFade                 = 0,  // 淡入淡出
    PLSTransitionTypeNone                 = 1,  // 无
} PLSTransitionType;
```
*Warning* You can only set `PLSImageVideoComposer` if the `PLSTransitionType` is `PLSTransitionTypeNone`