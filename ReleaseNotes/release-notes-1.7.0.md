# PLShortVideoKit Release Notes for 1.7.0

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
* 发布 PLShortVideoKit.framework

### 功能
* 支持文字特效
* 支持视频涂鸦
* 支持视频贴纸
* 支持图片合成视频
* 支持视频草稿
* 支持拍摄时录制背景音乐
* 支持编辑时旋转视频
* 支持编辑时使用视频首帧作为滤镜封面图
* 修复编辑时音乐时长小于视频时长时音乐不随视频循环播放的问题

### 注意事项
* 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。