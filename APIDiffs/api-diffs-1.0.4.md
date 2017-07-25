# PLShortVideoKit 1.0.3 to 1.0.4 API Differences

## General Headers

```
PLShortVideoSession.h
```

- *Added* @property (assign, nonatomic) BOOL filterModeOn;
- *Added* @property (strong, nonatomic, readonly) NSArray<NSDictionary *> *__nullable filters;
- *Added* @property (assign, nonatomic) NSInteger filterIndex;
- *Added* @property (strong, nonatomic, readonly) id __nullable currentFilter;


```
PLSUploader.h
```
- *Added* protocol `PLSUploaderDelegate`
- *Added* @property (nonatomic, assign, readonly, getter=isCancelUpload)BOOL cancelUpload;
- *Added* @property (nonatomic, assign, readonly)float uploadPercent;
- *Added* @property (nonatomic, strong, readonly)PLSUploaderConfiguration * _Nullable uploadConfig;
- *Added* @property (nonatomic, weak, nullable) id<PLSUploaderDelegate>  delegate;
- *Added* + (nullable instancetype)sharedUploader:(nonnull PLSUploaderConfiguration *)config;
- *Added* - (nullable instancetype)initWithConfiguration:(nonnull PLSUploaderConfiguration *)config;
- *Added* - (void)uploadVideoFile;
- *Added* - (void)cancelUploadVidoFile;







