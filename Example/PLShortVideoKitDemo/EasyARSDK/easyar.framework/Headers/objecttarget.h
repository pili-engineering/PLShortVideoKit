//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_OBJECTTARGET_H__
#define __EASYAR_OBJECTTARGET_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_ObjectTarget__ctor(/* OUT */ easyar_ObjectTarget * * Return);
bool easyar_ObjectTarget_setup(easyar_ObjectTarget * This, easyar_String * path, int storageType, easyar_String * name);
void easyar_ObjectTarget_setupAll(easyar_String * path, int storageType, /* OUT */ easyar_ListOfPointerOfObjectTarget * * Return);
float easyar_ObjectTarget_scale(const easyar_ObjectTarget * This);
void easyar_ObjectTarget_boundingBox(easyar_ObjectTarget * This, /* OUT */ easyar_ListOfVec3F * * Return);
void easyar_ObjectTarget_boundingBoxGL(easyar_ObjectTarget * This, /* OUT */ easyar_ListOfVec3F * * Return);
bool easyar_ObjectTarget_setScale(easyar_ObjectTarget * This, float scale);
int easyar_ObjectTarget_runtimeID(const easyar_ObjectTarget * This);
void easyar_ObjectTarget_uid(const easyar_ObjectTarget * This, /* OUT */ easyar_String * * Return);
void easyar_ObjectTarget_name(const easyar_ObjectTarget * This, /* OUT */ easyar_String * * Return);
void easyar_ObjectTarget_meta(const easyar_ObjectTarget * This, /* OUT */ easyar_String * * Return);
void easyar_ObjectTarget_setMeta(easyar_ObjectTarget * This, easyar_String * data);
void easyar_ObjectTarget__dtor(easyar_ObjectTarget * This);
void easyar_ObjectTarget__retain(const easyar_ObjectTarget * This, /* OUT */ easyar_ObjectTarget * * Return);
const char * easyar_ObjectTarget__typeName(const easyar_ObjectTarget * This);
void easyar_castObjectTargetToTarget(const easyar_ObjectTarget * This, /* OUT */ easyar_Target * * Return);
void easyar_tryCastTargetToObjectTarget(const easyar_Target * This, /* OUT */ easyar_ObjectTarget * * Return);

void easyar_ListOfPointerOfObjectTarget__ctor(easyar_ObjectTarget * const * begin, easyar_ObjectTarget * const * end, /* OUT */ easyar_ListOfPointerOfObjectTarget * * Return);
void easyar_ListOfPointerOfObjectTarget__dtor(easyar_ListOfPointerOfObjectTarget * This);
void easyar_ListOfPointerOfObjectTarget_copy(const easyar_ListOfPointerOfObjectTarget * This, /* OUT */ easyar_ListOfPointerOfObjectTarget * * Return);
int easyar_ListOfPointerOfObjectTarget_size(const easyar_ListOfPointerOfObjectTarget * This);
easyar_ObjectTarget * easyar_ListOfPointerOfObjectTarget_at(const easyar_ListOfPointerOfObjectTarget * This, int index);

void easyar_ListOfVec3F__ctor(easyar_Vec3F const * begin, easyar_Vec3F const * end, /* OUT */ easyar_ListOfVec3F * * Return);
void easyar_ListOfVec3F__dtor(easyar_ListOfVec3F * This);
void easyar_ListOfVec3F_copy(const easyar_ListOfVec3F * This, /* OUT */ easyar_ListOfVec3F * * Return);
int easyar_ListOfVec3F_size(const easyar_ListOfVec3F * This);
easyar_Vec3F easyar_ListOfVec3F_at(const easyar_ListOfVec3F * This, int index);

#ifdef __cplusplus
}
#endif

#endif
