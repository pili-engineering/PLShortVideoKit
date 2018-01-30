# PLShortVideoKit Release Notes for 1.9.0

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
- 发布 PLShortVideoKit.framework

### 功能
- 支持抖音特效
- 支持拍摄时截取图片
- 支持编辑类 PLShortVideoEditor 和视频导出类 PLSAVAssetExportSession 回调出视频的时间戳
- 修复快速开始和停止视频录制导致偶现文件写入报错的问题
- 修复编辑时添加背景音乐导致视频没有从剪切的起始位置处播放的问题
- 修复编辑类 PLShortVideoEditor 的回调不执行的问题
- 修复 1:1 比例的视频添加涂鸦、文字、图片后导出的视频出现倒立的问题
- 修复添加 MV 特效导出视频后原视频和背景音乐的音量大小不生效的问题
- 修复添加 MV 特效后只能固定输出某个视频分辨率的问题。
- 修复同时快速切换摄像头和滤镜偶现的 Crash 问题
- 修复在拒绝麦克风权限情形下添加背景音乐录制视频后进入编辑时 Crash 的问题
- 修复在拒绝相机权限情形下录制结束后进入编辑时 Crash 的问题
- 修复在拒绝相机和麦克风权限情形下视频录制结束后进行视频导出操作没有回调 Error 信息的问题
- 修复倍速拍摄后在编辑时不同倍速视频段衔接处会出现视频帧闪烁的问题

### 注意事项
- 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。
- 抖音特效，需要联系七牛商务获取 appkey 和资源文件。具体使用可参看 PLShortVideoKitDemo。

