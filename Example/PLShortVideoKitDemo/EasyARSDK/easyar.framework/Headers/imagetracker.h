//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_IMAGETRACKER_H__
#define __EASYAR_IMAGETRACKER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_ImageTracker__ctor(/* OUT */ easyar_ImageTracker * * Return);
void easyar_ImageTracker_loadTarget(easyar_ImageTracker * This, easyar_Target * target, easyar_FunctorOfVoidFromPointerOfTargetAndBool callback);
void easyar_ImageTracker_unloadTarget(easyar_ImageTracker * This, easyar_Target * target, easyar_FunctorOfVoidFromPointerOfTargetAndBool callback);
bool easyar_ImageTracker_loadTargetBlocked(easyar_ImageTracker * This, easyar_Target * target);
bool easyar_ImageTracker_unloadTargetBlocked(easyar_ImageTracker * This, easyar_Target * target);
void easyar_ImageTracker_targets(easyar_ImageTracker * This, /* OUT */ easyar_ListOfPointerOfTarget * * Return);
bool easyar_ImageTracker_setSimultaneousNum(easyar_ImageTracker * This, int num);
int easyar_ImageTracker_simultaneousNum(easyar_ImageTracker * This);
bool easyar_ImageTracker_attachStreamer(easyar_ImageTracker * This, easyar_FrameStreamer * obj);
bool easyar_ImageTracker_start(easyar_ImageTracker * This);
bool easyar_ImageTracker_stop(easyar_ImageTracker * This);
void easyar_ImageTracker__dtor(easyar_ImageTracker * This);
void easyar_ImageTracker__retain(const easyar_ImageTracker * This, /* OUT */ easyar_ImageTracker * * Return);
const char * easyar_ImageTracker__typeName(const easyar_ImageTracker * This);
void easyar_castImageTrackerToFrameFilter(const easyar_ImageTracker * This, /* OUT */ easyar_FrameFilter * * Return);
void easyar_tryCastFrameFilterToImageTracker(const easyar_FrameFilter * This, /* OUT */ easyar_ImageTracker * * Return);
void easyar_castImageTrackerToTargetTracker(const easyar_ImageTracker * This, /* OUT */ easyar_TargetTracker * * Return);
void easyar_tryCastTargetTrackerToImageTracker(const easyar_TargetTracker * This, /* OUT */ easyar_ImageTracker * * Return);

void easyar_ListOfPointerOfTarget__ctor(easyar_Target * const * begin, easyar_Target * const * end, /* OUT */ easyar_ListOfPointerOfTarget * * Return);
void easyar_ListOfPointerOfTarget__dtor(easyar_ListOfPointerOfTarget * This);
void easyar_ListOfPointerOfTarget_copy(const easyar_ListOfPointerOfTarget * This, /* OUT */ easyar_ListOfPointerOfTarget * * Return);
int easyar_ListOfPointerOfTarget_size(const easyar_ListOfPointerOfTarget * This);
easyar_Target * easyar_ListOfPointerOfTarget_at(const easyar_ListOfPointerOfTarget * This, int index);

#ifdef __cplusplus
}
#endif

#endif
