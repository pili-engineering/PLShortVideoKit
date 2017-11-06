//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_IMAGE_H__
#define __EASYAR_IMAGE_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_Image_buffer(const easyar_Image * This, /* OUT */ easyar_Buffer * * Return);
easyar_PixelFormat easyar_Image_format(const easyar_Image * This);
int easyar_Image_width(const easyar_Image * This);
int easyar_Image_height(const easyar_Image * This);
int easyar_Image_stride(const easyar_Image * This);
void * easyar_Image_data(const easyar_Image * This);
void easyar_Image__dtor(easyar_Image * This);
void easyar_Image__retain(const easyar_Image * This, /* OUT */ easyar_Image * * Return);
const char * easyar_Image__typeName(const easyar_Image * This);

#ifdef __cplusplus
}
#endif

#endif
