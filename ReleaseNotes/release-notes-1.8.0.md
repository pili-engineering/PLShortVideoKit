# PLShortVideoKit Release Notes for 1.8.0

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
- 发布 PLShortVideoKit.framework

### 功能
- 支持视频拍摄时自定义视频存放地址
- 支持转码时旋转视频
- 支持日志系统
- 修复 MV 特效在某种特定情形下预览不生效的问题
- 优化图片合成视频的效果
- 修复横屏拍摄时前几帧画面偏暗的问题

### 注意事项
* 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。