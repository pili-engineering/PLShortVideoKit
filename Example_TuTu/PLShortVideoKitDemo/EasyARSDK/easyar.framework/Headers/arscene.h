//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_ARSCENE_H__
#define __EASYAR_ARSCENE_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_ARScene__ctor(/* OUT */ easyar_ARScene * * Return);
int easyar_ARScene_runtimeID(const easyar_ARScene * This);
void easyar_ARScene_uid(const easyar_ARScene * This, /* OUT */ easyar_String * * Return);
void easyar_ARScene_name(const easyar_ARScene * This, /* OUT */ easyar_String * * Return);
void easyar_ARScene_meta(const easyar_ARScene * This, /* OUT */ easyar_String * * Return);
void easyar_ARScene_setMeta(easyar_ARScene * This, easyar_String * data);
void easyar_ARScene__dtor(easyar_ARScene * This);
void easyar_ARScene__retain(const easyar_ARScene * This, /* OUT */ easyar_ARScene * * Return);
const char * easyar_ARScene__typeName(const easyar_ARScene * This);
void easyar_castARSceneToTarget(const easyar_ARScene * This, /* OUT */ easyar_Target * * Return);
void easyar_tryCastTargetToARScene(const easyar_Target * This, /* OUT */ easyar_ARScene * * Return);

#ifdef __cplusplus
}
#endif

#endif
