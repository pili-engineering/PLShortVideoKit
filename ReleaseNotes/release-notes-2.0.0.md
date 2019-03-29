# PLShortVideoKit Release Notes for 2.0.0

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
- 发布 PLShortVideoKit.framework

### 功能
- 视频编辑 PLShortVideoEditor 在暂停的时候改变 fillMode，支持即时效果刷新
- 视频拍摄 PLShortVideoRecorder 添加新的相机切换接口，支持设置相机切换完成回调

### 优化
- 优化视频编辑 PLShortVideoEditor 对 1080P 及以上视频进行编辑, 在 iOS 12 系统上内存占用较大的问题

### 缺陷
- 修复视频拍摄 PLShortVideoRecorder 添加背景音乐的时候，自适应横屏拍摄失效的问题
- 修复视频编辑 PLShortVideoEditor 原视频设置为非循环播放，背景音乐仍然循环播放的问题
- 修复视频编辑 PLShortVideoEditor 使用 initWithPlayerItem: 方法初始化 crash 的问题
- 修复视频编辑 PLShortVideoEditor 的 timeRange 设置为 kCMTimeRangeZero 时，设置背景音乐不生效的问题
- 修复视频导出 AVAssetExportSession 不设置 PLSAudioSettingsKey，音量设置无效的问题
- 修复视频导出 AVAssetExportSession 添加 MV 的时候，存在内存泄漏的问题
- 修复视频导出 AVAssetExportSession 完成进度回调可能会从 99% 到 0 的问题

   
### 注意事项
- 七牛短视频 SDK 自 v2.0.0 版本起, 划分为基础版、进阶版、专业版。不同版本 SDK 可以使用的功能点数量有差别，请按照购买的 License 版本使用对应的短视频 SDK 版本。
- 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。
- 抖音特效，需要联系七牛商务获取 appkey 和资源文件。具体使用可参看 PLShortVideoKitDemo。

