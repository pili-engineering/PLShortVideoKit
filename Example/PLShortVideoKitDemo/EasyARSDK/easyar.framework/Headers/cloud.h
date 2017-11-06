//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_CLOUD_H__
#define __EASYAR_CLOUD_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_CloudRecognizer__ctor(/* OUT */ easyar_CloudRecognizer * * Return);
void easyar_CloudRecognizer_open(easyar_CloudRecognizer * This, easyar_String * server, easyar_String * appKey, easyar_String * appSecret, easyar_FunctorOfVoidFromCloudStatus callback_open, easyar_FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget callback_recognize);
bool easyar_CloudRecognizer_close(easyar_CloudRecognizer * This);
bool easyar_CloudRecognizer_attachStreamer(easyar_CloudRecognizer * This, easyar_FrameStreamer * obj);
bool easyar_CloudRecognizer_start(easyar_CloudRecognizer * This);
bool easyar_CloudRecognizer_stop(easyar_CloudRecognizer * This);
void easyar_CloudRecognizer__dtor(easyar_CloudRecognizer * This);
void easyar_CloudRecognizer__retain(const easyar_CloudRecognizer * This, /* OUT */ easyar_CloudRecognizer * * Return);
const char * easyar_CloudRecognizer__typeName(const easyar_CloudRecognizer * This);
void easyar_castCloudRecognizerToFrameFilter(const easyar_CloudRecognizer * This, /* OUT */ easyar_FrameFilter * * Return);
void easyar_tryCastFrameFilterToCloudRecognizer(const easyar_FrameFilter * This, /* OUT */ easyar_CloudRecognizer * * Return);

void easyar_ListOfPointerOfTarget__ctor(easyar_Target * const * begin, easyar_Target * const * end, /* OUT */ easyar_ListOfPointerOfTarget * * Return);
void easyar_ListOfPointerOfTarget__dtor(easyar_ListOfPointerOfTarget * This);
void easyar_ListOfPointerOfTarget_copy(const easyar_ListOfPointerOfTarget * This, /* OUT */ easyar_ListOfPointerOfTarget * * Return);
int easyar_ListOfPointerOfTarget_size(const easyar_ListOfPointerOfTarget * This);
easyar_Target * easyar_ListOfPointerOfTarget_at(const easyar_ListOfPointerOfTarget * This, int index);

#ifdef __cplusplus
}
#endif

#endif
