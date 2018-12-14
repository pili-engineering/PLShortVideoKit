//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_RECORDER_HXX__
#define __EASYAR_RECORDER_HXX__

#include "easyar/types.hxx"

namespace easyar {

class Recorder
{
protected:
    easyar_Recorder * cdata_ ;
    void init_cdata(easyar_Recorder * cdata);
    virtual Recorder & operator=(const Recorder & data) { return *this; } //deleted
public:
    Recorder(easyar_Recorder * cdata);
    virtual ~Recorder();

    Recorder(const Recorder & data);
    const easyar_Recorder * get_cdata() const;
    easyar_Recorder * get_cdata();

    Recorder();
    void setOutputFile(String * path);
    void setInputTexture(void * texPtr, int width, int height);
    void requestPermissions(FunctorOfVoidFromPermissionStatusAndString permissionCallback);
    bool open(FunctorOfVoidFromRecordStatusAndString statusCallback);
    void start();
    void updateFrame();
    void stop();
    void close();
    bool setProfile(RecordProfile profile);
    void setVideoSize(RecordVideoSize framesize);
    void setVideoBitrate(int bitrate);
    void setChannelCount(int count);
    void setAudioSampleRate(int samplerate);
    void setAudioBitrate(int bitrate);
    void setVideoOrientation(RecordVideoOrientation mode);
    void setZoomMode(RecordZoomMode mode);
};

#ifndef __EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
#define __EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
struct FunctorOfVoidFromPermissionStatusAndString
{
    void * _state;
    void (* func)(void * _state, PermissionStatus, String *);
    void (* destroy)(void * _state);
    FunctorOfVoidFromPermissionStatusAndString(void * _state, void (* func)(void * _state, PermissionStatus, String *), void (* destroy)(void * _state));
};

static void FunctorOfVoidFromPermissionStatusAndString_func(void * _state, easyar_PermissionStatus, easyar_String *);
static void FunctorOfVoidFromPermissionStatusAndString_destroy(void * _state);
static inline easyar_FunctorOfVoidFromPermissionStatusAndString FunctorOfVoidFromPermissionStatusAndString_to_c(FunctorOfVoidFromPermissionStatusAndString f);
#endif

#ifndef __EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
#define __EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
struct FunctorOfVoidFromRecordStatusAndString
{
    void * _state;
    void (* func)(void * _state, RecordStatus, String *);
    void (* destroy)(void * _state);
    FunctorOfVoidFromRecordStatusAndString(void * _state, void (* func)(void * _state, RecordStatus, String *), void (* destroy)(void * _state));
};

static void FunctorOfVoidFromRecordStatusAndString_func(void * _state, easyar_RecordStatus, easyar_String *);
static void FunctorOfVoidFromRecordStatusAndString_destroy(void * _state);
static inline easyar_FunctorOfVoidFromRecordStatusAndString FunctorOfVoidFromRecordStatusAndString_to_c(FunctorOfVoidFromRecordStatusAndString f);
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_RECORDER_HXX__
#define __IMPLEMENTATION_EASYAR_RECORDER_HXX__

#include "easyar/recorder.h"

namespace easyar {

inline Recorder::Recorder(easyar_Recorder * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline Recorder::~Recorder()
{
    if (cdata_) {
        easyar_Recorder__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline Recorder::Recorder(const Recorder & data)
    :
    cdata_(NULL)
{
    easyar_Recorder * cdata = NULL;
    easyar_Recorder__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_Recorder * Recorder::get_cdata() const
{
    return cdata_;
}
inline easyar_Recorder * Recorder::get_cdata()
{
    return cdata_;
}
inline void Recorder::init_cdata(easyar_Recorder * cdata)
{
    cdata_ = cdata;
}
inline Recorder::Recorder()
    :
    cdata_(NULL)
{
    easyar_Recorder * _return_value_ = NULL;
    easyar_Recorder__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline void Recorder::setOutputFile(String * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_setOutputFile(cdata_, arg0->get_cdata());
}
inline void Recorder::setInputTexture(void * arg0, int arg1, int arg2)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_setInputTexture(cdata_, arg0, arg1, arg2);
}
inline void Recorder::requestPermissions(FunctorOfVoidFromPermissionStatusAndString arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_requestPermissions(cdata_, FunctorOfVoidFromPermissionStatusAndString_to_c(arg0));
}
inline bool Recorder::open(FunctorOfVoidFromRecordStatusAndString arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_Recorder_open(cdata_, FunctorOfVoidFromRecordStatusAndString_to_c(arg0));
    return _return_value_;
}
inline void Recorder::start()
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_start(cdata_);
}
inline void Recorder::updateFrame()
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_updateFrame(cdata_);
}
inline void Recorder::stop()
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_stop(cdata_);
}
inline void Recorder::close()
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_close(cdata_);
}
inline bool Recorder::setProfile(RecordProfile arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_Recorder_setProfile(cdata_, static_cast<easyar_RecordProfile>(arg0));
    return _return_value_;
}
inline void Recorder::setVideoSize(RecordVideoSize arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_setVideoSize(cdata_, static_cast<easyar_RecordVideoSize>(arg0));
}
inline void Recorder::setVideoBitrate(int arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_setVideoBitrate(cdata_, arg0);
}
inline void Recorder::setChannelCount(int arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_setChannelCount(cdata_, arg0);
}
inline void Recorder::setAudioSampleRate(int arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_setAudioSampleRate(cdata_, arg0);
}
inline void Recorder::setAudioBitrate(int arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_setAudioBitrate(cdata_, arg0);
}
inline void Recorder::setVideoOrientation(RecordVideoOrientation arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_setVideoOrientation(cdata_, static_cast<easyar_RecordVideoOrientation>(arg0));
}
inline void Recorder::setZoomMode(RecordZoomMode arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Recorder_setZoomMode(cdata_, static_cast<easyar_RecordZoomMode>(arg0));
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
inline FunctorOfVoidFromPermissionStatusAndString::FunctorOfVoidFromPermissionStatusAndString(void * _state, void (* func)(void * _state, PermissionStatus, String *), void (* destroy)(void * _state))
{
    this->_state = _state;
    this->func = func;
    this->destroy = destroy;
}
static void FunctorOfVoidFromPermissionStatusAndString_func(void * _state, easyar_PermissionStatus arg0, easyar_String * arg1)
{
    PermissionStatus cpparg0 = static_cast<PermissionStatus>(arg0);
    easyar_String_copy(arg1, &arg1);
    String * cpparg1 = (arg1) == NULL ? NULL : new String(arg1);
    FunctorOfVoidFromPermissionStatusAndString * f = reinterpret_cast<FunctorOfVoidFromPermissionStatusAndString *>(_state);
    f->func(f->_state, cpparg0, cpparg1);
    delete cpparg1;
}
static void FunctorOfVoidFromPermissionStatusAndString_destroy(void * _state)
{
    FunctorOfVoidFromPermissionStatusAndString * f = reinterpret_cast<FunctorOfVoidFromPermissionStatusAndString *>(_state);
    if (f->destroy) {
        f->destroy(f->_state);
    }
    delete f;
}
static inline easyar_FunctorOfVoidFromPermissionStatusAndString FunctorOfVoidFromPermissionStatusAndString_to_c(FunctorOfVoidFromPermissionStatusAndString f)
{
    easyar_FunctorOfVoidFromPermissionStatusAndString _return_value_ = {NULL, NULL, NULL};
    if ((f.func == NULL) && (f.destroy == NULL)) { return _return_value_; }
    _return_value_._state = new FunctorOfVoidFromPermissionStatusAndString(f._state, f.func, f.destroy);
    _return_value_.func = FunctorOfVoidFromPermissionStatusAndString_func;
    _return_value_.destroy = FunctorOfVoidFromPermissionStatusAndString_destroy;
    return _return_value_;
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
inline FunctorOfVoidFromRecordStatusAndString::FunctorOfVoidFromRecordStatusAndString(void * _state, void (* func)(void * _state, RecordStatus, String *), void (* destroy)(void * _state))
{
    this->_state = _state;
    this->func = func;
    this->destroy = destroy;
}
static void FunctorOfVoidFromRecordStatusAndString_func(void * _state, easyar_RecordStatus arg0, easyar_String * arg1)
{
    RecordStatus cpparg0 = static_cast<RecordStatus>(arg0);
    easyar_String_copy(arg1, &arg1);
    String * cpparg1 = (arg1) == NULL ? NULL : new String(arg1);
    FunctorOfVoidFromRecordStatusAndString * f = reinterpret_cast<FunctorOfVoidFromRecordStatusAndString *>(_state);
    f->func(f->_state, cpparg0, cpparg1);
    delete cpparg1;
}
static void FunctorOfVoidFromRecordStatusAndString_destroy(void * _state)
{
    FunctorOfVoidFromRecordStatusAndString * f = reinterpret_cast<FunctorOfVoidFromRecordStatusAndString *>(_state);
    if (f->destroy) {
        f->destroy(f->_state);
    }
    delete f;
}
static inline easyar_FunctorOfVoidFromRecordStatusAndString FunctorOfVoidFromRecordStatusAndString_to_c(FunctorOfVoidFromRecordStatusAndString f)
{
    easyar_FunctorOfVoidFromRecordStatusAndString _return_value_ = {NULL, NULL, NULL};
    if ((f.func == NULL) && (f.destroy == NULL)) { return _return_value_; }
    _return_value_._state = new FunctorOfVoidFromRecordStatusAndString(f._state, f.func, f.destroy);
    _return_value_.func = FunctorOfVoidFromRecordStatusAndString_func;
    _return_value_.destroy = FunctorOfVoidFromRecordStatusAndString_destroy;
    return _return_value_;
}
#endif

}

#endif
