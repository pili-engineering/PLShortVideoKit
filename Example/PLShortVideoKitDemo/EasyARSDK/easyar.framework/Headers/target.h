//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_TARGET_H__
#define __EASYAR_TARGET_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

int easyar_Target_runtimeID(const easyar_Target * This);
void easyar_Target_uid(const easyar_Target * This, /* OUT */ easyar_String * * Return);
void easyar_Target_name(const easyar_Target * This, /* OUT */ easyar_String * * Return);
void easyar_Target_meta(const easyar_Target * This, /* OUT */ easyar_String * * Return);
void easyar_Target_setMeta(easyar_Target * This, easyar_String * data);
void easyar_Target__dtor(easyar_Target * This);
void easyar_Target__retain(const easyar_Target * This, /* OUT */ easyar_Target * * Return);
const char * easyar_Target__typeName(const easyar_Target * This);

void easyar_TargetInstance__ctor(/* OUT */ easyar_TargetInstance * * Return);
easyar_TargetStatus easyar_TargetInstance_status(const easyar_TargetInstance * This);
void easyar_TargetInstance_target(const easyar_TargetInstance * This, /* OUT */ easyar_Target * * Return);
easyar_Matrix34F easyar_TargetInstance_pose(const easyar_TargetInstance * This);
easyar_Matrix44F easyar_TargetInstance_poseGL(const easyar_TargetInstance * This);
void easyar_TargetInstance__dtor(easyar_TargetInstance * This);
void easyar_TargetInstance__retain(const easyar_TargetInstance * This, /* OUT */ easyar_TargetInstance * * Return);
const char * easyar_TargetInstance__typeName(const easyar_TargetInstance * This);

#ifdef __cplusplus
}
#endif

#endif
