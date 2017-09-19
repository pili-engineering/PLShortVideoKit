# PLShortVideoKit Release Notes for 1.4.1

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
* 发布 PLShortVideoKit.framework

### 功能
* 修复 iOS 11 系统上添加滤镜导致预览卡住的问题
* 修复拍摄时对焦动画引发的内存泄漏问题
* 更新上传依赖库 Qiniu 去适配 iOS 11 系统

### 注意事项
* 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。