//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_Renderer : easyar_RefBase

+ (easyar_Renderer *) create;
- (void)chooseAPI:(easyar_RendererAPI)api;
- (void)setDevice:(void *)device;
- (bool)render:(easyar_Drawable *)frame viewport:(easyar_Vec4I *)viewport;
- (bool)renderToTexture:(easyar_Drawable *)frame texture:(void *)texture;
- (bool)renderErrorMessage:(easyar_Vec4I *)viewport;
- (bool)renderErrorMessageToTexture:(void *)texture;

@end
