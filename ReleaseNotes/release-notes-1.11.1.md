# PLShortVideoKit Release Notes for 1.11.1

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
- 发布 PLShortVideoKit.framework

### 功能

- 优化视频拍摄效果，手动对焦的同时自动调整曝光位置
- 优化对 4K 视频的处理
- 优化短视频录制时 App 从后台回到前台自动开启录制的问题
- 优化 PLSEditPlayer seek 逻辑，能达到帧级别的 seek
- 优化 PLSEditPlayer 频繁添加背景音乐逻辑
- 优化对某些特殊视频进行编辑，首帧解码失败导致播放画面黑屏的问题
- 修复对某些特殊视频进行剪裁崩溃的问题
- 修复从手机系统相册导入视频进行编辑，部分视频方向不正确的问题
- 修复 PLSGLProgram 类名重复的问题
- 修复 PLShortVideoEditor 添加多音效首次预览的时候，播放时间点不对的问题
- 修复素材合拍 App 从后台回到前台无法继续录制的问题
- 修复 PLSAssetExportSession 在没有设置 PLSAudioSettingsKey 时视频剪裁不生效的问题
   

### 注意事项
- 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。
- 抖音特效，需要联系七牛商务获取 appkey 和资源文件。具体使用可参看 PLShortVideoKitDemo。

