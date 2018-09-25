# PLShortVideoKit Release Notes for 1.14.0

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
- 发布 PLShortVideoKit.framework

### 优化
- 优化图片转视频当图片数量过多造成内存溢出的问题
- 优化 1080P 视频时光倒流特效内存溢出的问题

### 增加
- 增加时光倒流特效是否移除音频接口
- 增加设置水印大小接口
- 多个视频拼接，支持音视频同步优先模式和播放流畅优先模式
- 支持 MV 特效选择 MV 素材时间段
- 支持 MV 特效循环添加
- MV 特效支持 MV 素材帧率和被编辑视频帧率不相等的场景

### 缺陷
- 修复使用七牛上传 SDK Qiniu v7.2.4 及以上版本导致短视频上传崩溃的问题
- 修复 PLSAVAssetExportSession 的音频参数使用 NSDictionary 崩溃的问题
   
### 注意事项
- 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。
- 抖音特效，需要联系七牛商务获取 appkey 和资源文件。具体使用可参看 PLShortVideoKitDemo。

