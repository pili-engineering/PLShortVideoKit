# PLShortVideoKit Release Notes for 1.2.1

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
* 发布 PLShortVideoKit.framework
* 发布 PLShortVideoKit.bundle

### 功能
* 修复首次安装后第一次录制无法预览和采集的问题
* 修复被裁减的视频执行静音导出后起始时间内未静音的问题
* 更新滤镜封面图

### 注意事项
* 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。
