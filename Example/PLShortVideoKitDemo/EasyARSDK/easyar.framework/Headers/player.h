//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_PLAYER_H__
#define __EASYAR_PLAYER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_VideoPlayer__ctor(/* OUT */ easyar_VideoPlayer * * Return);
void easyar_VideoPlayer_setVideoType(easyar_VideoPlayer * This, easyar_VideoType videoType);
void easyar_VideoPlayer_setRenderTexture(easyar_VideoPlayer * This, void * texture);
void easyar_VideoPlayer_open(easyar_VideoPlayer * This, easyar_String * path, easyar_StorageType storageType, easyar_FunctorOfVoidFromVideoStatus callback);
void easyar_VideoPlayer_close(easyar_VideoPlayer * This);
bool easyar_VideoPlayer_play(easyar_VideoPlayer * This);
bool easyar_VideoPlayer_stop(easyar_VideoPlayer * This);
bool easyar_VideoPlayer_pause(easyar_VideoPlayer * This);
bool easyar_VideoPlayer_isRenderTextureAvailable(easyar_VideoPlayer * This);
void easyar_VideoPlayer_updateFrame(easyar_VideoPlayer * This);
int easyar_VideoPlayer_duration(easyar_VideoPlayer * This);
int easyar_VideoPlayer_currentPosition(easyar_VideoPlayer * This);
bool easyar_VideoPlayer_seek(easyar_VideoPlayer * This, int position);
easyar_Vec2I easyar_VideoPlayer_size(easyar_VideoPlayer * This);
float easyar_VideoPlayer_volume(easyar_VideoPlayer * This);
bool easyar_VideoPlayer_setVolume(easyar_VideoPlayer * This, float volume);
void easyar_VideoPlayer__dtor(easyar_VideoPlayer * This);
void easyar_VideoPlayer__retain(const easyar_VideoPlayer * This, /* OUT */ easyar_VideoPlayer * * Return);
const char * easyar_VideoPlayer__typeName(const easyar_VideoPlayer * This);

#ifdef __cplusplus
}
#endif

#endif
