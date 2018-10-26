# PLShortVideoKit Release Notes for 1.15.0

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
- 发布 PLShortVideoKit.framework

### 优化
- 优化贴纸显示和隐藏动画时长的问题

### 增加
- 支持 GIF 水印
- 支持设置水印作用时间段、水印透明度和水印旋转角度
- 视频录制类 PLShortVideoRecorder 支持 AVCaptureSession 属性
- 视频导出类 PLSAVAssetExportSession 支持设置导出视频帧率

### 缺陷
- 修复视频导出类 PLSAVAssetExportSession 导出非 16 整数倍分辨率时，生成的视频有黑边的问题
- 修复素材合拍内存泄漏的问题
- 修复 GIF 制作类 PLSGifComposer 在 iOS 10 及以上版本生成的 GIF 图片循环次数始终是 1 次的问题
- 修复视频导出类 PLSAVAssetExportSession 当同时设置视频旋转和添加 MV 时，导出的视频 MV 显示位置错乱的问题
   
### 注意事项
- 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。
- 抖音特效，需要联系七牛商务获取 appkey 和资源文件。具体使用可参看 PLShortVideoKitDemo。

