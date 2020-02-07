# PLShortVideoKit Release Notes for 3.1.1

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
- 发布 PLShortVideoKit.framework

### 缺陷
- 修复 iOS 13.0 下，图片合成视频无转场动画的问题
- 修复某些机型下，导出视频产生内存溢出的问题
- 修复首次更新至 v3.1.0 偶现运行拍摄或编辑发生 crash 的问题
- 修复 PLSImageVideoComposer 设置视频 timeRange 后合成首帧错误的问题

### 功能
- 新增对拍摄、编辑和转码的 H265 编码支持
   
### 注意事项
- 七牛短视频 SDK 自 v3.0.0 版本起, 划分为精简版、基础版、进阶版、专业版 。不同版本 SDK 可以使用的功能点数量有差别，请按照购买的 License 版本使用对应的短视频 SDK 版本。
- 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。
- 抖音特效，需要联系七牛商务获取 appkey 和资源文件。具体使用可参看 PLShortVideoKitDemo。
