//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_RECORDER_H__
#define __EASYAR_RECORDER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_Recorder__ctor(/* OUT */ easyar_Recorder * * Return);
void easyar_Recorder_setOutputFile(easyar_Recorder * This, easyar_String * path);
void easyar_Recorder_setInputTexture(easyar_Recorder * This, void * texPtr, int width, int height);
void easyar_Recorder_requestPermissions(easyar_Recorder * This, easyar_FunctorOfVoidFromPermissionStatusAndString permissionCallback);
bool easyar_Recorder_open(easyar_Recorder * This, easyar_FunctorOfVoidFromRecordStatusAndString statusCallback);
void easyar_Recorder_start(easyar_Recorder * This);
void easyar_Recorder_updateFrame(easyar_Recorder * This);
void easyar_Recorder_stop(easyar_Recorder * This);
void easyar_Recorder_close(easyar_Recorder * This);
bool easyar_Recorder_setProfile(easyar_Recorder * This, easyar_RecordProfile profile);
void easyar_Recorder_setVideoSize(easyar_Recorder * This, easyar_RecordVideoSize framesize);
void easyar_Recorder_setVideoBitrate(easyar_Recorder * This, int bitrate);
void easyar_Recorder_setChannelCount(easyar_Recorder * This, int count);
void easyar_Recorder_setAudioSampleRate(easyar_Recorder * This, int samplerate);
void easyar_Recorder_setAudioBitrate(easyar_Recorder * This, int bitrate);
void easyar_Recorder_setVideoOrientation(easyar_Recorder * This, easyar_RecordVideoOrientation mode);
void easyar_Recorder_setZoomMode(easyar_Recorder * This, easyar_RecordZoomMode mode);
void easyar_Recorder__dtor(easyar_Recorder * This);
void easyar_Recorder__retain(const easyar_Recorder * This, /* OUT */ easyar_Recorder * * Return);
const char * easyar_Recorder__typeName(const easyar_Recorder * This);

#ifdef __cplusplus
}
#endif

#endif
