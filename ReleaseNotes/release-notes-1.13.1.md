# PLShortVideoKit Release Notes for 1.13.1

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
- 发布 PLShortVideoKit.framework

### 优化
- 优化拍摄页面使用 UIImagePickerController 打开系统相机之后再返回拍摄页面导致预览画面不能铺满屏幕的问题
- 优化首次启动短视频录制出现的已录制视频时长回调顺序不对的问题
- 优化短视频编辑 PLShortVideoEditor 更新背景音乐的 timeRange 之后，首次播放时背景音乐起始部分重复播放的问题

### 缺陷
- 修复 Swift 开发环境下调用视频拍摄接口时，实现正在录制中的回调 shortVideoRecorder: didRecordingToOutputFileAtURL: fileDuration: totalDuration: 导致 Crash 的问题
   

### 注意事项
- 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。
- 抖音特效，需要联系七牛商务获取 appkey 和资源文件。具体使用可参看 PLShortVideoKitDemo。

