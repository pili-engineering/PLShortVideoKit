//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_IMAGETARGET_H__
#define __EASYAR_IMAGETARGET_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_ImageTarget__ctor(/* OUT */ easyar_ImageTarget * * Return);
bool easyar_ImageTarget_setup(easyar_ImageTarget * This, easyar_String * path, int storageType, easyar_String * name);
void easyar_ImageTarget_setupAll(easyar_String * path, int storageType, /* OUT */ easyar_ListOfPointerOfImageTarget * * Return);
easyar_Vec2F easyar_ImageTarget_size(const easyar_ImageTarget * This);
bool easyar_ImageTarget_setSize(easyar_ImageTarget * This, easyar_Vec2F size);
void easyar_ImageTarget_images(easyar_ImageTarget * This, /* OUT */ easyar_ListOfPointerOfImage * * Return);
int easyar_ImageTarget_runtimeID(const easyar_ImageTarget * This);
void easyar_ImageTarget_uid(const easyar_ImageTarget * This, /* OUT */ easyar_String * * Return);
void easyar_ImageTarget_name(const easyar_ImageTarget * This, /* OUT */ easyar_String * * Return);
void easyar_ImageTarget_meta(const easyar_ImageTarget * This, /* OUT */ easyar_String * * Return);
void easyar_ImageTarget_setMeta(easyar_ImageTarget * This, easyar_String * data);
void easyar_ImageTarget__dtor(easyar_ImageTarget * This);
void easyar_ImageTarget__retain(const easyar_ImageTarget * This, /* OUT */ easyar_ImageTarget * * Return);
const char * easyar_ImageTarget__typeName(const easyar_ImageTarget * This);
void easyar_castImageTargetToTarget(const easyar_ImageTarget * This, /* OUT */ easyar_Target * * Return);
void easyar_tryCastTargetToImageTarget(const easyar_Target * This, /* OUT */ easyar_ImageTarget * * Return);

void easyar_ListOfPointerOfImageTarget__ctor(easyar_ImageTarget * const * begin, easyar_ImageTarget * const * end, /* OUT */ easyar_ListOfPointerOfImageTarget * * Return);
void easyar_ListOfPointerOfImageTarget__dtor(easyar_ListOfPointerOfImageTarget * This);
void easyar_ListOfPointerOfImageTarget_copy(const easyar_ListOfPointerOfImageTarget * This, /* OUT */ easyar_ListOfPointerOfImageTarget * * Return);
int easyar_ListOfPointerOfImageTarget_size(const easyar_ListOfPointerOfImageTarget * This);
easyar_ImageTarget * easyar_ListOfPointerOfImageTarget_at(const easyar_ListOfPointerOfImageTarget * This, int index);

void easyar_ListOfPointerOfImage__ctor(easyar_Image * const * begin, easyar_Image * const * end, /* OUT */ easyar_ListOfPointerOfImage * * Return);
void easyar_ListOfPointerOfImage__dtor(easyar_ListOfPointerOfImage * This);
void easyar_ListOfPointerOfImage_copy(const easyar_ListOfPointerOfImage * This, /* OUT */ easyar_ListOfPointerOfImage * * Return);
int easyar_ListOfPointerOfImage_size(const easyar_ListOfPointerOfImage * This);
easyar_Image * easyar_ListOfPointerOfImage_at(const easyar_ListOfPointerOfImage * This, int index);

#ifdef __cplusplus
}
#endif

#endif
