# PLShortVideoKit Release Notes for 1.2.0

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
* 发布 PLShortVideoKit.framework 1.2.0

### 功能
* 支持录屏
* 支持手动对焦动画
* 修复偶现视频合成失败问题
* 修复剪辑的视频导出后时长少零点几秒的问题

### 注意事项
* PLShortVideoKit.framework 中的 PLShortVideoKit.bundle 必须导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。