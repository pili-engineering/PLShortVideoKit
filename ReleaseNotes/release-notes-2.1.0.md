# PLShortVideoKit Release Notes for 2.1.0

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
- 发布 PLShortVideoKit.framework

### 功能
- 支持 GIF 动态贴纸功能
- 支持设置静态贴纸不被滤镜效果渲染

### 优化
- 优化合拍内存使用量

### 缺陷
- 修复 PLSGifComposer 获取视频图片，当获取图片数量是 1 的时候获取失败的问题
- 修复使用 swift 调用 PLSComposeItem，PLSComposeItem init 方法不执行的问题
- 修复视频录制，在启用根据设备方向自动调整横竖屏录制时，横屏模式下录制偶现生成的视频文件是竖屏的问题
- 修复对时长较长的视频进行转码失败的问题

   
### 注意事项
- 七牛短视频 SDK 自 v2.0.0 版本起, 划分为基础版、进阶版、专业版。不同版本 SDK 可以使用的功能点数量有差别，请按照购买的 License 版本使用对应的短视频 SDK 版本。
- 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。
- 抖音特效，需要联系七牛商务获取 appkey 和资源文件。具体使用可参看 PLShortVideoKitDemo。
