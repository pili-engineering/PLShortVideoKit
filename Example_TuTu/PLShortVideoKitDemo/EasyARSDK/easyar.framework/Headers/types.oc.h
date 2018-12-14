//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import <Foundation/Foundation.h>

@interface easyar_RefBase : NSObject
@end

@class easyar_ObjectTarget;

@class easyar_ObjectTracker;

typedef enum easyar_CloudStatus : NSInteger
{
    easyar_CloudStatus_Success = 0,
    easyar_CloudStatus_Reconnecting = 1,
    easyar_CloudStatus_Fail = 2,
} easyar_CloudStatus;

@class easyar_CloudRecognizer;

@class easyar_Buffer;

@class easyar_Drawable;

@class easyar_Frame;

typedef enum easyar_PixelFormat : NSInteger
{
    easyar_PixelFormat_Unknown = 0,
    easyar_PixelFormat_Gray = 1,
    easyar_PixelFormat_YUV_NV21 = 2,
    easyar_PixelFormat_YUV_NV12 = 3,
    easyar_PixelFormat_RGB888 = 4,
    easyar_PixelFormat_BGR888 = 5,
    easyar_PixelFormat_RGBA8888 = 6,
} easyar_PixelFormat;

@class easyar_Image;

@class easyar_Matrix34F;

@class easyar_Matrix44F;

@class easyar_Vec4F;

@class easyar_Vec3F;

@class easyar_Vec2F;

@class easyar_Vec4I;

@class easyar_Vec2I;

typedef enum easyar_CameraDeviceFocusMode : NSInteger
{
    easyar_CameraDeviceFocusMode_Normal = 0,
    easyar_CameraDeviceFocusMode_Triggerauto = 1,
    easyar_CameraDeviceFocusMode_Continousauto = 2,
    easyar_CameraDeviceFocusMode_Infinity = 3,
    easyar_CameraDeviceFocusMode_Macro = 4,
} easyar_CameraDeviceFocusMode;

typedef enum easyar_CameraDeviceType : NSInteger
{
    easyar_CameraDeviceType_Default = 0,
    easyar_CameraDeviceType_Back = 1,
    easyar_CameraDeviceType_Front = 2,
} easyar_CameraDeviceType;

@class easyar_CameraCalibration;

@class easyar_CameraDevice;

typedef enum easyar_PermissionStatus : NSInteger
{
    easyar_PermissionStatus_Granted = 0x00000000,
    easyar_PermissionStatus_Denied = 0x00000001,
    easyar_PermissionStatus_Error = 0x00000002,
} easyar_PermissionStatus;

typedef enum easyar_VideoStatus : NSInteger
{
    easyar_VideoStatus_Error = -1,
    easyar_VideoStatus_Ready = 0,
    easyar_VideoStatus_Completed = 1,
} easyar_VideoStatus;

typedef enum easyar_VideoType : NSInteger
{
    easyar_VideoType_Normal = 0,
    easyar_VideoType_TransparentSideBySide = 1,
    easyar_VideoType_TransparentTopAndBottom = 2,
} easyar_VideoType;

@class easyar_VideoPlayer;

typedef enum easyar_RendererAPI : NSInteger
{
    easyar_RendererAPI_Auto = 0,
    easyar_RendererAPI_None = 1,
    easyar_RendererAPI_GLES2 = 2,
    easyar_RendererAPI_GLES3 = 3,
    easyar_RendererAPI_GL = 4,
    easyar_RendererAPI_D3D9 = 5,
    easyar_RendererAPI_D3D11 = 6,
    easyar_RendererAPI_D3D12 = 7,
} easyar_RendererAPI;

@class easyar_Renderer;

@class easyar_Engine;

@class easyar_FrameFilter;

@class easyar_FrameStreamer;

@class easyar_CameraFrameStreamer;

@class easyar_QRCodeScanner;

typedef enum easyar_StorageType : NSInteger
{
    easyar_StorageType_App = 0,
    easyar_StorageType_Assets = 1,
    easyar_StorageType_Absolute = 2,
    easyar_StorageType_Json = 0x00000100,
} easyar_StorageType;

@class easyar_Target;

typedef enum easyar_TargetStatus : NSInteger
{
    easyar_TargetStatus_Unknown = 0,
    easyar_TargetStatus_Undefined = 1,
    easyar_TargetStatus_Detected = 2,
    easyar_TargetStatus_Tracked = 3,
} easyar_TargetStatus;

@class easyar_TargetInstance;

@class easyar_TargetTracker;

@class easyar_ImageTarget;

@class easyar_ImageTracker;

typedef enum easyar_RecordProfile : NSInteger
{
    easyar_RecordProfile_Quality_1080P_Low = 0x00000001,
    easyar_RecordProfile_Quality_1080P_Middle = 0x00000002,
    easyar_RecordProfile_Quality_1080P_High = 0x00000004,
    easyar_RecordProfile_Quality_720P_Low = 0x00000008,
    easyar_RecordProfile_Quality_720P_Middle = 0x00000010,
    easyar_RecordProfile_Quality_720P_High = 0x00000020,
    easyar_RecordProfile_Quality_480P_Low = 0x00000040,
    easyar_RecordProfile_Quality_480P_Middle = 0x00000080,
    easyar_RecordProfile_Quality_480P_High = 0x00000100,
    easyar_RecordProfile_Quality_Default = 0x00000010,
} easyar_RecordProfile;

typedef enum easyar_RecordVideoSize : NSInteger
{
    easyar_RecordVideoSize_Vid1080p = 0x00000002,
    easyar_RecordVideoSize_Vid720p = 0x00000010,
    easyar_RecordVideoSize_Vid480p = 0x00000080,
} easyar_RecordVideoSize;

typedef enum easyar_RecordZoomMode : NSInteger
{
    easyar_RecordZoomMode_NoZoomAndClip = 0x00000000,
    easyar_RecordZoomMode_ZoomInWithAllContent = 0x00000001,
} easyar_RecordZoomMode;

typedef enum easyar_RecordVideoOrientation : NSInteger
{
    easyar_RecordVideoOrientation_Landscape = 0x00000000,
    easyar_RecordVideoOrientation_Portrait = 0x00000001,
} easyar_RecordVideoOrientation;

typedef enum easyar_RecordStatus : NSInteger
{
    easyar_RecordStatus_OnStarted = 0x00000002,
    easyar_RecordStatus_OnStopped = 0x00000004,
    easyar_RecordStatus_FailedToStart = 0x00000202,
    easyar_RecordStatus_FileSucceeded = 0x00000400,
    easyar_RecordStatus_FileFailed = 0x00000401,
    easyar_RecordStatus_LogInfo = 0x00000800,
    easyar_RecordStatus_LogError = 0x00001000,
} easyar_RecordStatus;

@class easyar_Recorder;

@class easyar_ARScene;

@class easyar_ARSceneTracker;
