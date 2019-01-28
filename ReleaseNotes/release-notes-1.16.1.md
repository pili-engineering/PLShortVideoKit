# PLShortVideoKit Release Notes for 1.16.1

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
- 发布 PLShortVideoKit.framework


### 增加
- 添加 SDK 授权状态查询接口

### 优化
- 去掉对 i386 模拟器的支持，优化 SDK 包体大小

### 缺陷
- 修复时光倒流特效处理声道数大于 2 的视频导出失败的问题
- 修复视频编辑添加 MV 特效，预览的时候 MV 滞后视频播放 1s 左右问题
- 修复对无音频通道的视频添加 MV 特效，AVAssetExportSession 导出时 crash 的问题
- 修复 AVAssetExportSession 导出视频通道比音频通道时长短的视频时结尾处出现黑帧的问题
- 修复 AVAssetExportSession 添加贴纸起始时间是 0 的时候，第一帧视频没有贴纸效果的问题
- 修复 PLShortVideoRecorder 截帧小概率 crash 的问题
   
### 注意事项
- 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。
- 抖音特效，需要联系七牛商务获取 appkey 和资源文件。具体使用可参看 PLShortVideoKitDemo。

