//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_RENDERER_H__
#define __EASYAR_RENDERER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_Renderer__ctor(/* OUT */ easyar_Renderer * * Return);
void easyar_Renderer_chooseAPI(easyar_Renderer * This, easyar_RendererAPI api);
void easyar_Renderer_setDevice(easyar_Renderer * This, void * device);
bool easyar_Renderer_render(easyar_Renderer * This, easyar_Drawable * frame, easyar_Vec4I viewport);
bool easyar_Renderer_renderToTexture(easyar_Renderer * This, easyar_Drawable * frame, void * texture);
bool easyar_Renderer_renderErrorMessage(easyar_Renderer * This, easyar_Vec4I viewport);
bool easyar_Renderer_renderErrorMessageToTexture(easyar_Renderer * This, void * texture);
void easyar_Renderer__dtor(easyar_Renderer * This);
void easyar_Renderer__retain(const easyar_Renderer * This, /* OUT */ easyar_Renderer * * Return);
const char * easyar_Renderer__typeName(const easyar_Renderer * This);

#ifdef __cplusplus
}
#endif

#endif
