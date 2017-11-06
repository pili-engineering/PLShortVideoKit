//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_OBJECTTRACKER_H__
#define __EASYAR_OBJECTTRACKER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_ObjectTracker__ctor(/* OUT */ easyar_ObjectTracker * * Return);
void easyar_ObjectTracker_loadTarget(easyar_ObjectTracker * This, easyar_Target * target, easyar_FunctorOfVoidFromPointerOfTargetAndBool callback);
void easyar_ObjectTracker_unloadTarget(easyar_ObjectTracker * This, easyar_Target * target, easyar_FunctorOfVoidFromPointerOfTargetAndBool callback);
bool easyar_ObjectTracker_loadTargetBlocked(easyar_ObjectTracker * This, easyar_Target * target);
bool easyar_ObjectTracker_unloadTargetBlocked(easyar_ObjectTracker * This, easyar_Target * target);
void easyar_ObjectTracker_targets(easyar_ObjectTracker * This, /* OUT */ easyar_ListOfPointerOfTarget * * Return);
bool easyar_ObjectTracker_setSimultaneousNum(easyar_ObjectTracker * This, int num);
int easyar_ObjectTracker_simultaneousNum(easyar_ObjectTracker * This);
bool easyar_ObjectTracker_attachStreamer(easyar_ObjectTracker * This, easyar_FrameStreamer * obj);
bool easyar_ObjectTracker_start(easyar_ObjectTracker * This);
bool easyar_ObjectTracker_stop(easyar_ObjectTracker * This);
void easyar_ObjectTracker__dtor(easyar_ObjectTracker * This);
void easyar_ObjectTracker__retain(const easyar_ObjectTracker * This, /* OUT */ easyar_ObjectTracker * * Return);
const char * easyar_ObjectTracker__typeName(const easyar_ObjectTracker * This);
void easyar_castObjectTrackerToFrameFilter(const easyar_ObjectTracker * This, /* OUT */ easyar_FrameFilter * * Return);
void easyar_tryCastFrameFilterToObjectTracker(const easyar_FrameFilter * This, /* OUT */ easyar_ObjectTracker * * Return);
void easyar_castObjectTrackerToTargetTracker(const easyar_ObjectTracker * This, /* OUT */ easyar_TargetTracker * * Return);
void easyar_tryCastTargetTrackerToObjectTracker(const easyar_TargetTracker * This, /* OUT */ easyar_ObjectTracker * * Return);

void easyar_ListOfPointerOfTarget__ctor(easyar_Target * const * begin, easyar_Target * const * end, /* OUT */ easyar_ListOfPointerOfTarget * * Return);
void easyar_ListOfPointerOfTarget__dtor(easyar_ListOfPointerOfTarget * This);
void easyar_ListOfPointerOfTarget_copy(const easyar_ListOfPointerOfTarget * This, /* OUT */ easyar_ListOfPointerOfTarget * * Return);
int easyar_ListOfPointerOfTarget_size(const easyar_ListOfPointerOfTarget * This);
easyar_Target * easyar_ListOfPointerOfTarget_at(const easyar_ListOfPointerOfTarget * This, int index);

#ifdef __cplusplus
}
#endif

#endif
