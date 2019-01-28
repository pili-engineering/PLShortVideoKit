# PLShortVideoKit 1.16.0 to 1.16.1 API Differences

## General Headers

```
PLShortVideoRecorder.h
```

- *Added* + (void)checkAuthentication:(void(^ __nonnull)(PLSAuthenticationResult result))resultBlock;;

```
PLSTypeDefines.h
```

- *Added* PLSAuthenticationResult;


```
AVAsset+PLSExtendProperty.h
```

- *Added* @property (assign, nonatomic, readonly) UInt32 pls_channel;

- *Added* @property (assign, nonatomic, readonly) Float64 pls_sampleRate;
