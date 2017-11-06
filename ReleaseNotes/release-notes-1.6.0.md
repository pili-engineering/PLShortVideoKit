# PLShortVideoKit Release Notes for 1.6.0

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
* 发布 PLShortVideoKit.framework

### 功能
* 支持配音功能
* 支持编辑时对视频进行变速处理
* 支持 AR 特效拍摄
* 支持摄像头对焦位置的回调
* 修复横竖屏自动切换的拍摄模式下设备方向检测不精准的问题
* 修复视频拍摄时使用前置 AVCaptureSessionPreset1920x1080 预览黑屏的问题
* 修复频繁切换 1:1 与全屏录制模型出现的预览黑屏问题
* 修复录屏偶现 Crash 的问题
* 修复视频转码偶现 Crash 的问题
* 修复多个视频拼接使用视频拼接模块后生成的视频体积变大的问题
* 修复背景音乐与视频时长相同时导出的视频无声音的问题
* 修复 iPhone 5 设备上将视频转码成 1080P 后快速执行视频导出偶现 Crash 的问题

### 注意事项
* 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。