//
//  FaceTracker.h
//  FaceTracker
//
//  Created by yuanwh on 16/7/5.
//  Copyright © 2016年 sobrr. All rights reserved.
//

#ifdef __cplusplus

#define FT_OK 0                            //正常状态
#define FT_E_OUT_OF_DATE -1                //日期过期
#define FT_E_INVALID_BUNDLEID -2           //bundle id匹配错误
#define FT_E_DETECTOR_LOADFAILED -3        //xml载入失败
#define FT_E_ALIGNMENT_LOADFAILED -4       //bin载入失败
#define FT_E_INVALID_FACE_NUM -5           //错误的人脸个数
#define FT_E_WRONG_IMAGE_FORMAT -6         //错误的图像格式
#define FT_E_NO_DETECT_FACE -8             //没有检测到人脸
#define FT_E_TRACK_FAILED -9               //跟踪失败
#define FT_E_NETCERTIFICATION_FAILED -10   //网络验证失败
#define FT_E_NULL_KEY_STRING -11           //空的密钥
#define FT_E_NULL_FACERSTS -12             //返回结果内存没有初始化
#define FT_E_LICENSE_LOADFAILED -13       //license载入失败

extern "C"
{
#endif

typedef struct cv_pointf_t
{
    float x;        ///< 点的水平方向坐标，为浮点数
    float y;        ///< 点的竖直方向坐标，为浮点数

} cv_pointf_t;

typedef struct cv_rect_t
{
    int x;        ///< 矩形X坐标
    int y;        ///< 矩形Y坐标
    int width;  ///< 矩形宽度
    int height; ///< 矩形高度
} cv_rect_t;

typedef struct result_68_t
{
    cv_rect_t rect; ///< 检测器检测出的人脸框
    cv_pointf_t points_array[68];    ///< 人脸68关键点的数组
    float yaw;            ///< 水平转角，真实度量的左负右正
    float pitch;            ///< 俯仰角，真实度量的上负下正
    float roll;            ///< 旋转角，真实度量的左负右正
    bool mouth_open;    ///大张嘴标志位,   false-闭嘴     true-张嘴
    bool brow_up;       ///眉毛表情标志位, false-不动     true-上扬
    bool eye_status;    ///眼睛表情标志位, false-张开     true-闭眼
    bool head_yaw;
    bool head_pithch;
} result_68_t, *p_result_68_t;

typedef enum
{
    CV_CLOCKWISE_ROTATE_0 = 0,    ///< 图像不需要转向
    CV_CLOCKWISE_ROTATE_90 = 1,    ///< 图像需要顺时针旋转90度
    CV_CLOCKWISE_ROTATE_180 = 2,    ///< 图像需要顺时针旋转180度
    CV_CLOCKWISE_ROTATE_270 = 3    ///< 图像需要顺时针旋转270度
} cv_rotate_type;

/********************************
 init - 初始化函数
 Input -  dir：文件存放路径
 Output - 状态值参见 #define
 *******************************/
int init(const char *dir);

/********************************
 init - 初始化函数
 Input -  dir：文件存放路径
 Input -  low_performance_cost：低端机子建议设置为true
 Output - 状态值参见 #define
 *******************************/
int init2Param(const char *dir, bool low_performance_cost);

/********************************
 init - 初始化函数
 Input -  strHarrXmlPath：detector模型文件存放路径
 Input -  strTrackModelPath：tracker模型文件存放路径
 Input -  strLicenseValue：licence内容
 Input -  low_performance_cost：低端机子建议设置为true
 Output - 状态值参见 #define
 *******************************/
int init4Param(const char *strHarrXmlPath, const char *strTrackModelPath, const char *strLicenseValue, bool low_performance_cost);

/********************************
 track - 跟踪函数
 Input -    pixels：图像文件
 format：图像格式：（0-BGRA， 1-NV12， 2-RGB）
 width： 图像宽度
 height：图像高度
 p_result：跟踪结果指针，指向存放结果内存首地址
 rstNum：  当前跟踪的人脸数
 orientation： 图像旋转方向，参见cv_rotate_type
 faceNum： 设定当前帧最大跟踪人脸数 （1 <= rstNum <= faceNum <= 5）
 Output - 状态值参见 #define
 *******************************/
int track(unsigned char *pixels, int format, int width, int height, result_68_t **p_result, int *rstNum, int orientation, int faceNum);

/********************************
 destory - 析构函数
 Input -  void
 Output - void
 *******************************/
void destory();
//    void release_result();
//    void converFormt (unsigned char **pixels,int width, int height);

/********************************
 调整滤波参数，可设置，默认0.5，可以使点变稳不抖动
 Input -  void
 Output - void
 *******************************/
void setSigmaSpace(float sigma);


#ifdef __cplusplus
}
#endif
