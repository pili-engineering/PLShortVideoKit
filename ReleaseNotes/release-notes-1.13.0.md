# PLShortVideoKit Release Notes for 1.13.0

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
- 发布 PLShortVideoKit.framework

### 功能
- 支持设置视频转码帧率
- 支持视频转码时裁剪视频像素区域
- 优化素材视频合拍音频数据回调格式，由 CMSampleBufferRef 修改为 AudioBufferlist
- 优化图片转视频模块生成的视频时长不精准的问题
- 优化 pod install 或 update PLShortVideoKit 时进度缓慢的问题
- 修复 PLSEditPlayer 在 iOS 9.0 以下无法播放的问题
- 修复 PLSMovieComposer 拼接 16 个以上视频失败的问题
- 修复 SDK 无法处理 5.1 声道的视频的问题
- 修复素材合拍，素材视频没有音频轨道时合拍失败的问题
   

### 注意事项
- 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。
- 抖音特效，需要联系七牛商务获取 appkey 和资源文件。具体使用可参看 PLShortVideoKitDemo。

