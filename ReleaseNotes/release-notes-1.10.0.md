# PLShortVideoKit Release Notes for 1.10.0

### 简介
PLShortVideoKit 是七牛推出的一款适用于 iOS 平台的短视频 SDK，提供了包括美颜、滤镜、水印、断点录制、分段回删、视频编辑、混音特效、MV 特效、本地/云端存储在内的多种功能，支持高度定制以及二次开发。

### 版本
- 发布 PLShortVideoKit.framework

### 功能
- 支持文字动画转换为视频文件
- 支持多个视频同时进行切割编辑
- 对能直接 H.265 硬解码的机型支持导入 H.265 格式视频文件进行转码
- 支持在视频任意位置插入文字转场视频编辑
- 支持 PLSUploaderConfiguration  上传 params 设置
- 支持倍速录制视频时以对应的倍速播放背景音乐
- 优化 PLSEditPlayer 在暂停的时候 seek 时预览画面刷新逻辑
- 修复录制时播放背景音乐，并在录制结束后再次合成背景音乐导致有两重背景音乐声音的问题
- 修复多张图片合成视频时设置图片持续时间导致的最后一张图片没有被合入视频的问题
- 更新人脸贴纸库解决了使用人脸贴纸库后反复进出录制页面导致的崩溃问题

### 注意事项
- 若需要使用 PLShortVideoKit.framework 中的内置滤镜，则必须将 PLShortVideoKit.bundle 导入项目中。若需要增删、替换滤镜资源可操作 PLShortVideoKit.bundle 中的 colorFilter 文件夹。
- 抖音特效，需要联系七牛商务获取 appkey 和资源文件。具体使用可参看 PLShortVideoKitDemo。

