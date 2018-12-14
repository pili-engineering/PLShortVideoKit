# PLShortVideoKit Release Notes for 1.16.0

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
- 发布 PLShortVideoKit.framework


### 增加
- 添加图片、GIF 图和视频混排功能
- 视频导出类 PLSAVAssetExportSession 支持设置导出视频的音频码率和声道数
- 视频切割类 PLSRangeMovieExport 支持设置导出视频的码率、宽高以及视频的填充模式
- 视频录制时音频编码采样率支持 16000Hz
- 多个视频文件拼接增加视频优先（PLSComposerPriorityTypeVideo）和音频优先（PLSComposerPriorityTypeAudio）模式

### 缺陷
- 修复视频录制当设置背景音乐起始位置不是 0 的时候，删除已经录制的片段导致背景音乐起始位置变为 0 的问题
- 修复视频录制当设置的录制视频宽高之比和采集视频的宽高之比不相等时，录制视频画面剪裁位置不对的问题
- 修复视频导出类 PLSAVAssetExportSession 导出视频可能会丢失最开始几帧视频的问题
- 修复 1080P 的视频在 iPhone 5 上执行时光倒流失败的问题
- 修复 PLSEditPlayer 播放部分视频结束的时候播放画面黑屏的问题
   
### 注意事项
- 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。
- 抖音特效，需要联系七牛商务获取 appkey 和资源文件。具体使用可参看 PLShortVideoKitDemo。

