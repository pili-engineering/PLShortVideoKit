//
//  FURenderer.h
//
//  Created by ly on 16/11/2.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "funama.h"

typedef struct{
    CVPixelBufferRef pixelBuffer;
    GLuint bgraTextureHandle;
}FUOutput;

typedef enum {
    FUFormatBGRABuffer = FU_FORMAT_BGRA_BUFFER,
    FUFormatRGBABuffer = FU_FORMAT_RGBA_BUFFER,
    FUFormatNV12Buffer = FU_FORMAT_NV12_BUFFER,
    FUFormatI420Buffer = FU_FORMAT_I420_BUFFER,
    FUFormatRGBATexture = FU_FORMAT_RGBA_TEXTURE,
} FUFormat;

@interface FURenderer : NSObject

/**
 获取 FURenderer 单例
 
 @return FURenderer 单例
 */
+ (FURenderer *)shareRenderer;

/**
 初始化接口1:
     - 初始化 SDK，并对 SDK 进行授权，在调用其他接口前必须要先进行初始化。
     - 使用该接口进行初始化的话，需要在代码中配置 EAGLContext 环境，并且保证我们的接口是在同一个 EAGLContext 下调用的
 
 @param data v3.bundle 对应的二进制数据地址
 @param dataSize v3.bundle 数据的字节数
 @param ardata 该参数已舍弃，传 NULL 即可
 @param package 密钥数组，必须配置好密钥，SDK 才能正常工作
 @param size 密钥数组大小
 @return 初始化结果，为0则初始化失败，大于0则初始化成功
 */
- (int)setupWithData:(void *)data dataSize:(int)dataSize ardata:(void *)ardata authPackage:(void *)package authSize:(int)size;

/**
 初始化接口2：
     - 初始化 SDK，并对 SDK 进行授权，在调用其他接口前必须要先进行初始化。
     - 与 初始化接口1 相比此接口新增 shouldCreate 参数，如果传入YES我们将在内部创建并持有一个 EAGLContext，无需外部再创建 EAGLContext 环境。
 
 @param data v3.bundle 对应的二进制数据地址
 @param dataSize v3.bundle 数据的字节数
 @param ardata 该参数已废弃，传 NULL 即可
 @param package 密钥数组，必须配置好密钥，SDK 才能正常工作
 @param size 密钥数组大小
 @param shouldCreate 如果设置为 YES，我们会在内部创建并持有一个 EAGLContext，此时必须使用OC层接口
 @return 初始化结果，为0则初始化失败，大于0则初始化成功
 */
- (int)setupWithData:(void *)data dataSize:(int)dataSize ardata:(void *)ardata authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL)shouldCreate;

/**
 初始化接口3：
     - 初始化SDK，并对 SDK 进行授权，在调用其他接口前必须要先进行初始化。
     - 与 初始化接口2 相比改为通过 v3.bundle 的文件路径进行初始化，并且删除了废弃的 ardata 参数。
 
 @param v3path v3.bundle 对应的文件路径
 @param package 密钥数组，必须配置好密钥，SDK 才能正常工作
 @param size 密钥数组大小
 @param shouldCreate  如果设置为 YES，我们会在内部创建并持有一个 EAGLContext，此时必须使用OC层接口
 @return 初始化结果，为0则初始化失败，大于0则初始化成功
 */
- (int)setupWithDataPath:(NSString *)v3path authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL)shouldCreate;


/**
 初始化接口4：

 - 初始化SDK，采用离线鉴权方式
 
 @param v3path v3.bundle 对应的文件路径
 @param offLinePath offLineBundle.bundle 离线鉴权包路径
 @param package 密钥数组，必须配置好密钥，SDK 才能正常工作
 @param size 密钥数组大小
 @param shouldCreate  如果设置为 YES，我们会在内部创建并持有一个 EAGLContext，此时必须使用OC层接口
 @return 第一次鉴权成功后的文件
 */

- (NSData *)setupLocalWithV3Path:(NSString *)v3path offLinePath:(NSString *)offLinePath authPackage:(void *)package authSize:(int)size shouldCreateContext:(BOOL)shouldCreate;

/**
 视频处理接口1：
     - 将 items 中的道具绘制到 pixelBuffer 中
 
 @param pixelBuffer 图像数据，支持的格式为：BGRA、YUV420SP
 @param frameid 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画
 @param items 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等
 @param itemCount 句柄数组中包含的句柄个数
 @return 被处理过的的图像数据，返回 nil 视频处理失败
 */
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount;

/**
 视频处理接口2：
     - 将 items 中的道具绘制到 pixelBuffer 中
     - 与 视频处理接口1 相比新增 flip 参数，将该参数设置为 YES 可使道具做水平镜像翻转
 
 @param pixelBuffer 图像数据，支持的格式为：BGRA、YUV420SP
 @param frameid 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画
 @param items 包含多个道具句柄的 int 数组
 @param itemCount 句柄数组中包含的句柄个数
 @param flip 道具镜像使能，如果设置为 YES 可以将道具做镜像操作
 @return 被处理过的的图像数据，返回 nil 视频处理失败
 */
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount flipx:(BOOL)flip;

/**
 视频处理接口3：
 - 将 items 中的道具绘制到 pixelBuffer 中
 - 与 视频处理接口2 相比新增 customSize 参数，可以自定义输出分辨率
 
 @param pixelBuffer 图像数据，支持的格式为：BGRA、YUV420SP
 @param frameid 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画
 @param items 包含多个道具句柄的 int 数组
 @param itemCount 句柄数组中包含的句柄个数
 @param flip 道具镜像使能，如果设置为 YES 可以将道具做镜像操作
 @param customSize 自定义输出的分辨率，目前仅支持BGRA格式
 @return 被处理过的的图像数据，返回 nil 视频处理失败
 */

- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount flipx:(BOOL)flip customSize:(CGSize)customSize NS_AVAILABLE_IOS(8_0);

/**
 视频处理接口4：
     - 将 items 中的道具绘制到一个新的 pixelBuffer 中，输出与输入不是同一个 pixelBuffer
 
 @param pixelBuffer 图像数据，支持的格式为：BGRA、YUV420SP
 @param frameid 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画
 @param items 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等
 @param itemCount 句柄数组中包含的句柄个数
 @return 被处理过的的图像数据，返回 nil 视频处理失败
 */
- (CVPixelBufferRef)renderToInternalPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount NS_AVAILABLE_IOS(8_0);

/**
 视频处理接口5：
     - 将 items 中的道具绘制到 textureHandle 及 pixelBuffer 中
     - 该接口适用于可同时输入 GLES texture 及 pixelBuffer 的用户，这里的 pixelBuffer 主要用于 CPU 上的人脸检测，如果只有 GLES texture 此接口将无法工作。
 
 @param pixelBuffer 图像数据，支持的格式为：BGRA、YUV420SP，用于人脸识别
 @param textureHandle 用户当前 EAGLContext 下的 textureID，用于图像处理
 @param frameid 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画
 @param items 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等
 @param itemCount 句柄数组中包含的句柄个数
 @return 被处理过的的图像数据
 */
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount NS_AVAILABLE_IOS(8_0);

/**
 视频处理接口6：
     - 将items中的道具绘制到 textureHandle 及 pixelBuffer 中
     - 与 视频处理接口5 相比新增 flip 参数，将该参数设置为 YES 可使道具做水平镜像翻转。
 
 @param pixelBuffer 图像数据，支持的格式为：BGRA、YUV420SP，用于人脸识别
 @param textureHandle  用户当前 EAGLContext 下的 textureID，用于图像处理
 @param frameid 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画
 @param items 包含多个道具句柄的int数组，包括普通道具、美颜道具、手势道具等
 @param itemCount 句柄数组中包含的句柄个数
 @param flip 道具镜像使能，如果设置为 YES 可以将道具做镜像操作
 @return 被处理过的的图像数据
 */
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip NS_AVAILABLE_IOS(8_0);

/**
 视频处理接口7：
 - 将items中的道具绘制到 textureHandle 及 pixelBuffer 中
 - 与 视频处理接口6 相比新增 customSize 参数，可以自定义输出分辨率。
 
 @param pixelBuffer 图像数据，支持的格式为：BGRA、YUV420SP，用于人脸识别
 @param textureHandle  用户当前 EAGLContext 下的 textureID，用于图像处理
 @param frameid 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画
 @param items 包含多个道具句柄的int数组，包括普通道具、美颜道具、手势道具等
 @param itemCount 句柄数组中包含的句柄个数
 @param flip 道具镜像使能，如果设置为 YES 可以将道具做镜像操作
 @param customSize 自定义输出的分辨率，目前仅支持BGRA格式
 @return 被处理过的的图像数据
 */
- (FUOutput)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer bgraTexture:(GLuint)textureHandle withFrameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip customSize:(CGSize)customSize NS_AVAILABLE_IOS(8_0);

/**
 视频处理接口8：
     - 该接口不包含人脸检测功能，只能对图像做美白、红润、滤镜、磨皮操作，不包含瘦脸及大眼等美型功能。
 
 @param pixelBuffer 图像数据，支持的格式为：BGRA、YUV420SP
 @param item 美颜道具句柄
 @return 被处理过的的图像数据 返回 nil 视频处理失败
 */
- (CVPixelBufferRef)beautifyPixelBuffer:(CVPixelBufferRef)pixelBuffer withBeautyItem:(int)item;

/**
 视频处理接口9：
     - 将 items 中的道具绘制到 YUV420P 图像中
 
 @param y Y帧图像地址
 @param u U帧图像地址
 @param v V帧图像地址
 @param ystride Y帧stride
 @param ustride U帧stride
 @param vstride V帧stride
 @param width 图像宽度
 @param height 图像高度
 @param frameid 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画
 @param items 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等
 @param itemCount 句柄数组中包含的句柄个数
 */
- (void)renderFrame:(uint8_t*)y u:(uint8_t*)u v:(uint8_t*)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height frameId:(int)frameid items:(int *)items itemCount:(int)itemCount;

/**
 视频处理接口10：
     - 将 items 中的道具绘制到 YUV420P 图像中
     - 与 视频处理接口9 相比新增 flip 参数，将该参数设置为 YES 可使道具做水平镜像翻转
 
 @param y Y帧图像地址
 @param u U帧图像地址
 @param v V帧图像地址
 @param ystride Y帧stride
 @param ustride U帧stride
 @param vstride V帧stride
 @param width 图像宽度
 @param height 图像高度
 @param frameid 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画
 @param items 包含多个道具句柄的 int 数组，包括普通道具、美颜道具、手势道具等
 @param itemCount 句柄数组中包含的句柄个数
 @param flip 道具镜像使能，如果设置为 YES 可以将道具做镜像操作
 */
- (void)renderFrame:(uint8_t*)y u:(uint8_t*)u v:(uint8_t*)v ystride:(int)ystride ustride:(int)ustride vstride:(int)vstride width:(int)width height:(int)height frameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip;

/**
 视频处理接口11：
 - 将 items 中的道具绘制到 pixelBuffer 中
 - 与 视频处理接口2 相比新增 masks 参数，用来指定 items 中的道具画在多人中的哪一张脸上
 
 @param pixelBuffer 图像数据，支持的格式为：BGRA、YUV420SP
 @param frameid 当前处理的视频帧序数，每次处理完对其进行加 1 操作，不加 1 将无法驱动道具中的特效动画
 @param items 包含多个道具句柄的 int 数组
 @param itemCount 句柄数组中包含的句柄个数
 @param flip 道具镜像使能，如果设置为 YES 可以将道具做镜像操作
 @param masks 指定items中的道具画在多张人脸中的哪一张脸上的 int 数组，其长度要与 items 长度一致，
        masks中的每一位与items中的每一位道具一一对应。使用方法为：要使某一个道具画在检测到的第一张人脸上，
        对应的int值为 "2的0次方"，画在第二张人脸上对应的int值为 “2的1次方”，第三张人脸对应的int值为 “2的2次方”，
        以此类推。例：masks = {pow(2,0),pow(2,1),pow(2,2)....},值得注意的是美颜道具对应的int值为 0。
 @return 被处理过的的图像数据，返回 nil 视频处理失败
 */
- (CVPixelBufferRef)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer withFrameId:(int)frameid items:(int*)items itemCount:(int)itemCount flipx:(BOOL)flip masks:(void*)masks;

- (int)renderItems:(void *)inPtr inFormat:(FUFormat)inFormat outPtr:(void *)outPtr outFormat:(FUFormat)outFormat width:(int)width height:(int)height frameId:(int)frameid items:(int *)items itemCount:(int)itemCount flipx:(BOOL)flip;

/**
 resize视频图像，目前仅支持BGRA格式的pixelBuffer

 @param pixelBuffer BGRA格式的pixelBuffer
 @param resizeSize resizeSize
 @return resizeSize之后的pixelBuffer
 */
- (CVPixelBufferRef)resizePixelBuffer:(CVPixelBufferRef)pixelBuffer resizeSize:(CGSize)resizeSize NS_AVAILABLE_IOS(8_0);

/**
 通过texture获取指定大小与格式的pixelBuffer

 @param texture rgba texture
 @param textureSize texture 尺寸
 @param outPutSize 输出的pixelBuffer的尺寸
 @param outputFormat 输出的pixelBuffer的格式，接受的参数有两个，分别为：FU_FORMAT_NV12_BUFFER、FU_FORMAT_BGRA_BUFFER
 @return 从texture获取到的指定大小与格式的pixelBuffer
 */
- (CVPixelBufferRef)getPixelBufferFromTexture:(int)texture textureSize:(CGSize)textureSize outputSize:(CGSize)outPutSize outputFormat:(int)outputFormat NS_AVAILABLE_IOS(8_0);

/**
 切换摄像头时需调用的接口：
     - 切换摄像头时需要调用该接口，我们会在内部重置人脸检测的一些状态
 */
+ (void)onCameraChange;

/**
 销毁所有道具时需调用的接口：
 - 销毁所有道具时需要调用该接口，我们会在内部销毁每个指令中的OpenGL资源
 */
+ (void)OnDeviceLost;

/**
 通过道具二进制文件创建道具：
     - 通过道具二进制文件创建道具句柄
 
 @param data 道具二进制文件
 @param size 文件大小
 @return 创建的道具句柄
 */
+ (int)createItemFromPackage:(void*)data size:(int)size;

/**
 通过道具文件路径创建道具：
     - 通过道具文件路径创建道具句柄
 
 @param path 道具文件路径
 @return 创建的道具句柄
 */
+ (int)itemWithContentsOfFile:(NSString *)path;

/**
 销毁单个道具：
     - 通过道具句柄销毁道具，并释放相关资源
     - 销毁道具后请将道具句柄设为 0 ，以避免 SDK 使用无效的句柄而导致程序出错。
 
 @param item 道具句柄
 */
+ (void)destroyItem:(int)item;

/**
 销毁所有道具：
     - 销毁全部道具，并释放相关资源
     - 销毁道具后请将道具句柄数组中的句柄设为 0 ，以避免 SDK 使用无效的句柄而导致程序出错。
 */
+ (void)destroyAllItems;

/**
 为道具设置参数：
 
 @param item 道具句柄
 @param name 参数名
 @param value 参数值：只支持 NSString 、 NSNumber 两种数据类型
 @return 执行结果：返回 0 代表设置失败，大于 0 表示设置成功
 */
+ (int)itemSetParam:(int)item withName:(NSString *)name value:(id)value;

/**
 为道具设置参数：
 
 @param item 道具句柄
 @param name 参数名
 @param value 参数值：double 数组
 @param length 参数值：double 数组长度
 @return 执行结果：返回 0 代表设置失败，大于 0 表示设置成功
 */
+ (int)itemSetParamdv:(int)item withName:(NSString *)name value:(double *)value length:(int)length;

/**
 从道具中获取 double 型参数值：
 
 @param item 道具句柄
 @param name 参数名
 @return 参数值
 */
+ (double)getDoubleParamFromItem:(int)item withName:(NSString *)name;

/**
 从道具中获取 NSString 型参数值：
 
 @param item 道具句柄
 @param name 参数名
 @return 参数值
 */
+ (NSString *)getStringParamFromItem:(int)item withName:(NSString *)name;

+ (int)itemSetParamu8v:(int)item withName:(NSString *)name buffer:(void *)buffer size:(int)size;

+ (int)itemGetParamu8v:(int)item withName:(NSString *)name buffer:(void *)buffer size:(int)size;

/**
 判断是否检测到人脸：
 
 @return 检测到的人脸个数，返回 0 代表没有检测到人脸
 */
+ (int)isTracking;

/**
 开启多人检测模式：
     - 开启多人检测模式，最多可同时检测 8 张人脸
 
 @param maxFaces 设置多人模式开启的人脸个数，最多支持 8 个
 @return 上一次设置的人脸个数
 */
+ (int)setMaxFaces:(int)maxFaces;

/**
 人脸信息跟踪：
     - 该接口只对人脸进行检测，如果程序中没有运行过视频处理接口( 视频处理接口8 除外)，则需要先执行完该接口才能使用 获取人脸信息接口 来获取人脸信息
 
 @param inputFormat 输入图像格式：FU_FORMAT_BGRA_BUFFER 或 FU_FORMAT_NV12_BUFFER
 @param inputData 输入的图像 bytes 地址
 @param width 图像宽度
 @param height 图像高度
 @return 检测到的人脸个数，返回 0 代表没有检测到人脸
 */
+ (int)trackFace:(int)inputFormat inputData:(void*)inputData width:(int)width height:(int)height;

+ (int)trackFaceWithTongue:(int)inputFormat inputData:(void*)inputData width:(int)width height:(int)height;

/**
 获取人脸信息：
     - 在程序中需要先运行过视频处理接口( 视频处理接口8 除外)或 人脸信息跟踪接口 后才能使用该接口来获取人脸信息；
     - 该接口能获取到的人脸信息与我司颁发的证书有关，普通证书无法通过该接口获取到人脸信息；
     - 具体参数及证书要求如下：
 
         landmarks: 2D人脸特征点，返回值为75个二维坐标，长度75*2
         证书要求: LANDMARK证书、AVATAR证书
 
         landmarks_ar: 3D人脸特征点，返回值为75个三维坐标，长度75*3
         证书要求: AVATAR证书
 
         rotation: 人脸三维旋转，返回值为旋转四元数，长度4
         证书要求: LANDMARK证书、AVATAR证书
 
         translation: 人脸三维位移，返回值一个三维向量，长度3
         证书要求: LANDMARK证书、AVATAR证书
 
         eye_rotation: 眼球旋转，返回值为旋转四元数,长度4
         证书要求: LANDMARK证书、AVATAR证书
 
         rotation_raw: 人脸三维旋转（不考虑屏幕方向），返回值为旋转四元数，长度4
         证书要求: LANDMARK证书、AVATAR证书
 
         expression: 表情系数，长度46
         证书要求: AVATAR证书
 
         projection_matrix: 投影矩阵，长度16
         证书要求: AVATAR证书
 
         face_rect: 人脸矩形框，返回值为(xmin,ymin,xmax,ymax)，长度4
         证书要求: LANDMARK证书、AVATAR证书
 
         rotation_mode: 人脸朝向，0-3分别对应手机四种朝向，长度1
         证书要求: LANDMARK证书、AVATAR证书
 
 @param faceId 被检测的人脸 ID ，未开启多人检测时传 0 ，表示检测第一个人的人脸信息；当开启多人检测时，其取值范围为 [0 ~ maxFaces-1] ，取其中第几个值就代表检测第几个人的人脸信息
 @param name 人脸信息参数名： "landmarks" , "eye_rotation" , "translation" , "rotation" ....
 @param pret 作为容器使用的 float 数组指针，获取到的人脸信息会被直接写入该 float 数组。
 @param number float 数组的长度
 @return 返回 1 代表获取成功，返回 0 代表获取失败
 */
+ (int)getFaceInfo:(int)faceId name:(NSString *)name pret:(float *)pret number:(int)number;

/**
 获取正在跟踪人脸的标识符，用于在SDK外部对多人情况下的不同人脸进行区别。
 @param faceId，人脸编号，表示识别到的第 x 张人脸，从0开始，到n-1,n为当前跟踪到的人脸数。
 @return 人脸的标识符 [1,maxFaces]
 */
+ (int)getFaceIdentifier:(int)faceId;

/**
 将普通道具绑定到avatar道具：
     - 该接口主要应用于 P2A 项目中，将普通道具绑定到 avatar 道具上，从而实现道具间的数据共享；
     - 在视频处理时只需要传入 avatar 道具句柄，普通道具也会和 avatar 一起被绘制出来。
     - 普通道具又分免费版和收费版，免费版有免费版对应的 contract 文件，收费版有收费版对应的 contract 文件，当绑定时需要同时传入这些 contracts 文件才能绑定成功。
     - 注意： contract 的创建和普通道具创建方法一致
 
 @param avatarItem avatar 道具句柄
 @param items 需要被绑定到 avatar 道具上的普通道具的句柄数组
 @param itemsCount 句柄数组包含的道具句柄个数
 @param contracts contract 道具的句柄数组
 @param contractsCount contracts 数组中 contract 道具句柄的个数
 @return 被绑定到 avatar 道具上的普通道具个数
 */
+ (int)avatarBindItems:(int)avatarItem items:(int *)items itemsCount:(int)itemsCount contracts:(int *)contracts contractsCount:(int)contractsCount DEPRECATED_MSG_ATTRIBUTE("use bindItems:items:itemsCount: instead");

/**
 将普通道具从avatar道具上解绑：
     - 该接口可以将普通道具从 avatar 道具上解绑，主要应用场景为切换道具或去掉某个道具
 
 @param avatarItem avatar 道具句柄
 @param items 需要从 avatar 道具上的解除绑定的普通道具的句柄数组
 @param itemsCount 句柄数组包含的道具句柄个数
 @return 从 avatar 道具上解除绑定的普通道具个数
 */
+ (int)avatarUnbindItems:(int)avatarItem items:(int *)items itemsCount:(int)itemsCount DEPRECATED_MSG_ATTRIBUTE("use unBindItems:items:itemsCount: instead");

/**
 绑定道具：
     -  该接口可以将一些普通道具绑定到某个目标道具上，从而实现道具间的数据共享，在视频处理时只需要传入该目标道具句柄即可
 
 @param item 目标道具句柄
 @param items 需要被绑定到目标道具上的其他道具的句柄数组
 @param itemsCount 句柄数组包含的道具句柄个数
 @return 被绑定到目标道具上的普通道具个数
 */
+ (int)bindItems:(int)item items:(int*)items itemsCount:(int)itemsCount;

/**
 解绑道具：
 -  该接口可以将一些普通道具从某个目标道具上解绑
 
 @param item 目标道具句柄
 @param items 需要从目标道具上解除绑定的普通道具的句柄数组
 @param itemsCount 句柄数组包含的道具句柄个数
 @return 被绑定到目标道具上的普通道具个数
 */
+ (int)unBindItems:(int)item items:(int *)items itemsCount:(int)itemsCount;

/**
 解绑所有道具：
     - 该接口可以解绑绑定在目标道具上的全部道具
 
 @param item 目标道具句柄
 @return 从目标道具上解除绑定的普通道具个数
 */
+ (int)unbindAllItems:(int)item;

/**
 获取 SDK 版本信息：
 
 @return 版本信息
 */
+ (NSString *)getVersion;

+ (void)setExpressionCalibration:(int)expressionCalibration;

+ (void)setFocalLengthScale:(float)scale;

+ (int)loadExtendedARData:(void *)data size:(int)size;

+ (int)loadExtendedARDataWithDataPath:(NSString *)dataPath;

+ (int)loadAnimModel:(void *)model size:(int)size;

+ (int)loadAnimModelWithModelPath:(NSString *)modelPath;

+ (void)setDefaultRotationMode:(float)mode;

+ (void)setAsyncTrackFaceEnable:(int)enable;

+ (void)setTongueTrackingEnable:(int)enable;
 
+ (int)loadTongueModel:(void*)model size:(int)size;


/**
 释放nama资源
 */
+(void)namaLibDestroy;
@end
