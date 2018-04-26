//
//  TuSDKTKStatistics.h
//  TuSDK
//
//  Created by Clear Hu on 15/2/9.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKTKLocation.h"
#import "TuSDKFilterOption.h"
#import "TuSDKPFSticker.h"
#import "TuSDKPFBrush.h"

#pragma mark - TuSDKTKStatisticsType
/**
 *  组件行为类型
#import "TuSDKTKStatistics.h"
 
// sdk统计代码，请不要加入您的应用
[TuSDKTKStatistics appendWithComponentIdt:tkc_albumComponent];
 */
typedef NS_ENUM(NSInteger, TuSDKTKComponentType) {
    /**
     * sdk 组件
     */
    tkc_sdkComponent = 0x01,
    /**
     * sdk 加载完成组件
     */
    tkc_sdkLoadedComponent = 0x02,
    /**
     * sdk 快速相机范例
     */
    tkc_sdkSimpleCamera = 0x10,
    
    /**
     * 系统相册组件
     */
    tkc_albumComponent = 0x200000,
    
    /**
     * 系统相册控制器
     */
    tkc_albumListFragment = 0x201000,
    
    /**
     * 系统相册(带相机)组件
     */
    tkc_albumMultipleComponent = 0x200001,
    
    /**
     * 系统相册(带相机)控制器
     */
    tkc_albumMultipleListFragment = 0x201001,
    
    /**
     * 相册照片列表控制器
     */
    tkc_photoListFragment = 0x202000,
    
    /**
     * 相册照片预览控制器
     */
    tkc_photoListPreviewFragment = 0x202001,
    
    /**
     * 头像设置组件
     */
    tkc_avatarComponent = 0x300000,
    
    /**
     * 图片编辑组件
     */
    tkc_editComponent = 0x400000,
    
    /**
     * 图片编辑裁切旋转控制器
     */
    tkc_editCuterFragment = 0x401000,
    
    /**
     * 图片编辑裁切旋转控制器 左旋转动作
     */
    tkc_editCuter_action_trun_left = 0x401011,
    
    /**
     * 图片编辑裁切旋转控制器 右旋转动作
     */
    tkc_editCuter_action_trun_right = 0x401012,
    
    /**
     * 图片编辑裁切旋转控制器 水平镜像动作
     */
    tkc_editCuter_action_mirror_horizontal = 0x401021,
    
    /**
     * 图片编辑裁切旋转控制器 垂直镜像动作
     */
    tkc_editCuter_action_mirror_vertical = 0x401022,
    
    /**
     * 图片编辑裁切旋转控制器 显示比例 原始
     */
    tkc_editCuter_action_ratio_orgin = 0x401040,
    
    /**
     * 图片编辑裁切旋转控制器 显示比例 9_16
     */
    tkc_editCuter_action_ratio_9_16 = 0x401041,
    
    /**
     * 图片编辑裁切旋转控制器 显示比例 3_4
     */
    tkc_editCuter_action_ratio_3_4 = 0x401042,
    
    /**
     * 图片编辑裁切旋转控制器 显示比例 2_3
     */
    tkc_editCuter_action_ratio_2_3 = 0x401043,
    
    /**
     * 图片编辑裁切旋转控制器 显示比例 1_1
     */
    tkc_editCuter_action_ratio_1_1 = 0x401044,
    
    /**
     * 图片编辑裁切旋转控制器 显示比例 3_2
     */
    tkc_editCuter_action_ratio_3_2 = 0x401045,
    
    /**
     * 图片编辑裁切旋转控制器 显示比例 4_3
     */
    tkc_editCuter_action_ratio_4_3 = 0x401046,
    
    /**
     * 图片编辑裁切旋转控制器 显示比例 16_9
     */
    tkc_editCuter_action_ratio_16_9 = 0x401047,
    
    /**
     * 图片编辑入口控制器
     */
    tkc_editEntryFragment = 0x402000,
    
    /**
     * 图片编辑滤镜控制器
     */
    tkc_editFilterFragment = 0x403000,
    
    /**
     * 裁剪与缩放控制器
     */
    tkc_editTurnAndCutFragment = 0x404000,
    
    /**
     * 图片处理行为
     */
    tkc_editPhotoAction = 0x405000,
    
    /**
     * 多功能图片处理组件
     */
    tkc_editMultipleComponent = 0x406000,
    
    /**
     * 多功能图片处理控制器
     */
    tkc_editMultipleFragment = 0x407000,
    
    /**
     * 美肤控制器 增加 一键美颜，大眼瘦脸
     */
    tkc_editSkinFragment = 0x408000,
    
    /**
     * 图像调整控制器
     */
    tkc_editAdjustFragment = 0x409000,
    
    /**
     * 图像锐化控制器
     */
    tkc_editSharpnessFragment = 0x409100,
    
    /**
     * 大光圈控制器
     */
    tkc_editApertureFragment = 0x409200,
    
    /**
     * 暗角控制器
     */
    tkc_editVignetteFragment = 0x409300,
    
    /**
     * 在线滤镜控制器
     */
    tkc_editFilterOnlineFragment = 0x409400,
    
    /**
     * 涂抹控制器
     */
    tkc_editSmudgeFragment = 0x409500,
    
    /**
     * 滤镜涂抹控制器
     */
    tkc_editWipeAndFilterFragment = 0x409600,
    
    /**
     * 圣光控制器
     */
    tkc_editHolyLightFragment = 0x409700,
    
    /**
     * 编辑控制器
     */
    tkc_multipleEditFragment = 0x409800,
    
    /**
     * HDR编辑控制器 
     */
    tkc_editHDRFragment = 0x409900,
    
    /**
     * 文字贴纸编辑控制器
     */
    tkc_editTextFragment = 0x410000,
    
    /**
     * 相机控制器
     */
    tkc_cameraFragment = 0x500000,
    
    /**
     * 相机预览控制器
     */
    tkc_cameraPreviewFragment = 0x500010,
    
    /**
     * 相机控制器 拍照动作
     */
    tkc_camera_action_take_picture = 0x501010,
    
    /**
     * 相机控制器 拍照动作
     */
    tkc_camera_action_capture_with_volume = 0x501011,
    
    /**
     * 相机控制器 后置摄像头
     */
    tkc_camera_action_faceing_back = 0x501021,
    
    /**
     * 相机控制器 前置摄像头
     */
    tkc_camera_action_faceing_front = 0x501022,
    
    /**
     * 相机控制器 关闭闪光灯
     */
    tkc_camera_action_flash_off = 0x501030,
    
    /**
     * 相机控制器 开启闪光灯
     */
    tkc_camera_action_flash_on = 0x501031,
    
    /**
     * 相机控制器自动闪光灯
     */
    tkc_camera_action_flash_auto = 0x501032,
    
    /**
     * 相机控制器 显示比例 原始
     */
    tkc_camera_action_ratio_orgin = 0x501040,
    
    /**
     * 相机控制器 显示比例 9_16
     */
    tkc_camera_action_ratio_9_16 = 0x501041,
    
    /**
     * 相机控制器 显示比例 3_4
     */
    tkc_camera_action_ratio_3_4 = 0x501042,
    
    /**
     * 相机控制器 显示比例 2_3
     */
    tkc_camera_action_ratio_2_3 = 0x501043,
    
    /**
     * 相机控制器 显示比例 1_1
     */
    tkc_camera_action_ratio_1_1 = 0x501044,
    
    /**
     * 相机控制器 显示比例 3_2
     */
    tkc_camera_action_ratio_3_2 = 0x501045,
    
    /**
     * 相机控制器 显示比例 4_3
     */
    tkc_camera_action_ratio_4_3 = 0x501046,
    
    /**
     * 相机控制器 显示比例 16_9
     */
    tkc_camera_action_ratio_16_9 = 0x501047,
    
    /**
     * 本地贴纸控制器
     */
    tkc_editStickerLocalFragment = 0x601000,
    /**
     * 在线贴纸控制器
     */
    tkc_editStickerOnlineFragment = 0x602000,
    
    /**
     * 贴纸编辑控制器
     */
    tkc_editStickerFragment = 0x603000,
    
    /*
     * Gif组件
     */
    tkc_gifViewer = 0x700000,
    
    /**
     *  在线图像颜色分析
     */
    tkc_imageAnalysis_color = 0x800001,

    
    // 在线验证相关
    
    /*
     * 获取更新验证信息
     */
    tck_getUpdatedAppAuthAction = 0x810000,
    
    /*
     * 成功获取验证信息
     */
    tck_getAppAuthActionSuccess = 0x810002,
    
    /*
     * 获取验证信息时出错
     */
    tck_getAppAuthActionFail = 0x810004,
    
    /*
     *  成功更新验证信息
     */
    tck_updateAppAuthActionSuccess = 0x810006,
    
    /*
     * 更新验证信息无效
     */
    tck_updateAppAuthActionFail = 0x810008,
    
    
    /**
     *
     * 0x90 视频库占用
     *
     * 0x91 - 0x93 已被TuSDKFaceID占用 详见TuSDKFaceID -> Secrets -> TuSDKPFStatistics.h
     */
};

#pragma mark - TuSDKTKStatistics
/**
 *  数据统计
 */
@interface TuSDKTKStatistics : NSObject
/**
 *  数据统计
 *
 *  @param path 数据位置
 *
 *  @return 数据统计对象
 */
+ (void)initWithDataPath:(NSString *)path;

/**
 *  添加组件统计ID
 *
 *  @param idt 组件统计ID
 */
+ (void)appendWithComponentIdt:(uint64_t)idt;

/**
 * 添加滤镜统计
 *
 * @param filter
 *            滤镜配置选项
 */
+ (void)appendWithFilter:(TuSDKFilterOption *)filter;

/**
 * 添加贴纸统计
 *
 * @param sticker
 *            贴纸数据
 */
+ (void)appendWithSticker:(TuSDKPFSticker *)sticker;

/**
 * 添加笔刷统计
 *
 * @param brush
 *            笔刷数据
 */
+ (void)appendWithBrush:(TuSDKPFBrush *)brush;

/**
 *  刷新数据
 */
+ (void)flushData;
@end
