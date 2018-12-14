//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_DRAWABLE_H__
#define __EASYAR_DRAWABLE_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_Drawable__dtor(easyar_Drawable * This);
void easyar_Drawable__retain(const easyar_Drawable * This, /* OUT */ easyar_Drawable * * Return);
const char * easyar_Drawable__typeName(const easyar_Drawable * This);

#ifdef __cplusplus
}
#endif

#endif
