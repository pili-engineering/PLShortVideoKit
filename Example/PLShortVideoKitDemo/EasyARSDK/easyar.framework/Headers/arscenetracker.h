//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_ARSCENETRACKER_H__
#define __EASYAR_ARSCENETRACKER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_ARSceneTracker__ctor(/* OUT */ easyar_ARSceneTracker * * Return);
bool easyar_ARSceneTracker_attachStreamer(easyar_ARSceneTracker * This, easyar_FrameStreamer * obj);
bool easyar_ARSceneTracker_start(easyar_ARSceneTracker * This);
bool easyar_ARSceneTracker_stop(easyar_ARSceneTracker * This);
void easyar_ARSceneTracker__dtor(easyar_ARSceneTracker * This);
void easyar_ARSceneTracker__retain(const easyar_ARSceneTracker * This, /* OUT */ easyar_ARSceneTracker * * Return);
const char * easyar_ARSceneTracker__typeName(const easyar_ARSceneTracker * This);
void easyar_castARSceneTrackerToFrameFilter(const easyar_ARSceneTracker * This, /* OUT */ easyar_FrameFilter * * Return);
void easyar_tryCastFrameFilterToARSceneTracker(const easyar_FrameFilter * This, /* OUT */ easyar_ARSceneTracker * * Return);

#ifdef __cplusplus
}
#endif

#endif
