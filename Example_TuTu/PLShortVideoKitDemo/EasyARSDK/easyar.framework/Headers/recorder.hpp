//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_RECORDER_HPP__
#define __EASYAR_RECORDER_HPP__

#include "easyar/types.hpp"

namespace easyar {

class Recorder
{
protected:
    std::shared_ptr<easyar_Recorder> cdata_;
    void init_cdata(std::shared_ptr<easyar_Recorder> cdata);
    Recorder & operator=(const Recorder & data) = delete;
public:
    Recorder(std::shared_ptr<easyar_Recorder> cdata);
    virtual ~Recorder();

    std::shared_ptr<easyar_Recorder> get_cdata();

    Recorder();
    void setOutputFile(std::string path);
    void setInputTexture(void * texPtr, int width, int height);
    void requestPermissions(std::function<void(PermissionStatus, std::string)> permissionCallback);
    bool open(std::function<void(RecordStatus, std::string)> statusCallback);
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
static void FunctorOfVoidFromPermissionStatusAndString_func(void * _state, easyar_PermissionStatus, easyar_String *);
static void FunctorOfVoidFromPermissionStatusAndString_destroy(void * _state);
static inline easyar_FunctorOfVoidFromPermissionStatusAndString FunctorOfVoidFromPermissionStatusAndString_to_c(std::function<void(PermissionStatus, std::string)> f);
#endif

#ifndef __EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
#define __EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
static void FunctorOfVoidFromRecordStatusAndString_func(void * _state, easyar_RecordStatus, easyar_String *);
static void FunctorOfVoidFromRecordStatusAndString_destroy(void * _state);
static inline easyar_FunctorOfVoidFromRecordStatusAndString FunctorOfVoidFromRecordStatusAndString_to_c(std::function<void(RecordStatus, std::string)> f);
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_RECORDER_HPP__
#define __IMPLEMENTATION_EASYAR_RECORDER_HPP__

#include "easyar/recorder.h"

namespace easyar {

inline Recorder::Recorder(std::shared_ptr<easyar_Recorder> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline Recorder::~Recorder()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_Recorder> Recorder::get_cdata()
{
    return cdata_;
}
inline void Recorder::init_cdata(std::shared_ptr<easyar_Recorder> cdata)
{
    cdata_ = cdata;
}
inline Recorder::Recorder()
    :
    cdata_(nullptr)
{
    easyar_Recorder * _return_value_;
    easyar_Recorder__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_Recorder>(_return_value_, [](easyar_Recorder * ptr) { easyar_Recorder__dtor(ptr); }));
}
inline void Recorder::setOutputFile(std::string arg0)
{
    easyar_Recorder_setOutputFile(cdata_.get(), std_string_to_easyar_String(arg0).get());
}
inline void Recorder::setInputTexture(void * arg0, int arg1, int arg2)
{
    easyar_Recorder_setInputTexture(cdata_.get(), arg0, arg1, arg2);
}
inline void Recorder::requestPermissions(std::function<void(PermissionStatus, std::string)> arg0)
{
    easyar_Recorder_requestPermissions(cdata_.get(), FunctorOfVoidFromPermissionStatusAndString_to_c(arg0));
}
inline bool Recorder::open(std::function<void(RecordStatus, std::string)> arg0)
{
    auto _return_value_ = easyar_Recorder_open(cdata_.get(), FunctorOfVoidFromRecordStatusAndString_to_c(arg0));
    return _return_value_;
}
inline void Recorder::start()
{
    easyar_Recorder_start(cdata_.get());
}
inline void Recorder::updateFrame()
{
    easyar_Recorder_updateFrame(cdata_.get());
}
inline void Recorder::stop()
{
    easyar_Recorder_stop(cdata_.get());
}
inline void Recorder::close()
{
    easyar_Recorder_close(cdata_.get());
}
inline bool Recorder::setProfile(RecordProfile arg0)
{
    auto _return_value_ = easyar_Recorder_setProfile(cdata_.get(), static_cast<easyar_RecordProfile>(arg0));
    return _return_value_;
}
inline void Recorder::setVideoSize(RecordVideoSize arg0)
{
    easyar_Recorder_setVideoSize(cdata_.get(), static_cast<easyar_RecordVideoSize>(arg0));
}
inline void Recorder::setVideoBitrate(int arg0)
{
    easyar_Recorder_setVideoBitrate(cdata_.get(), arg0);
}
inline void Recorder::setChannelCount(int arg0)
{
    easyar_Recorder_setChannelCount(cdata_.get(), arg0);
}
inline void Recorder::setAudioSampleRate(int arg0)
{
    easyar_Recorder_setAudioSampleRate(cdata_.get(), arg0);
}
inline void Recorder::setAudioBitrate(int arg0)
{
    easyar_Recorder_setAudioBitrate(cdata_.get(), arg0);
}
inline void Recorder::setVideoOrientation(RecordVideoOrientation arg0)
{
    easyar_Recorder_setVideoOrientation(cdata_.get(), static_cast<easyar_RecordVideoOrientation>(arg0));
}
inline void Recorder::setZoomMode(RecordZoomMode arg0)
{
    easyar_Recorder_setZoomMode(cdata_.get(), static_cast<easyar_RecordZoomMode>(arg0));
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
static void FunctorOfVoidFromPermissionStatusAndString_func(void * _state, easyar_PermissionStatus arg0, easyar_String * arg1)
{
    PermissionStatus cpparg0 = static_cast<PermissionStatus>(arg0);
    easyar_String_copy(arg1, &arg1);
    std::string cpparg1 = std_string_from_easyar_String(std::shared_ptr<easyar_String>(arg1, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
    auto f = reinterpret_cast<std::function<void(PermissionStatus, std::string)> *>(_state);
    (*f)(cpparg0, cpparg1);
}
static void FunctorOfVoidFromPermissionStatusAndString_destroy(void * _state)
{
    auto f = reinterpret_cast<std::function<void(PermissionStatus, std::string)> *>(_state);
    delete f;
}
static inline easyar_FunctorOfVoidFromPermissionStatusAndString FunctorOfVoidFromPermissionStatusAndString_to_c(std::function<void(PermissionStatus, std::string)> f)
{
    if (f == nullptr) { return easyar_FunctorOfVoidFromPermissionStatusAndString{nullptr, nullptr, nullptr}; }
    return easyar_FunctorOfVoidFromPermissionStatusAndString{new std::function<void(PermissionStatus, std::string)>(f), FunctorOfVoidFromPermissionStatusAndString_func, FunctorOfVoidFromPermissionStatusAndString_destroy};
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMRECORDSTATUSANDSTRING__
static void FunctorOfVoidFromRecordStatusAndString_func(void * _state, easyar_RecordStatus arg0, easyar_String * arg1)
{
    RecordStatus cpparg0 = static_cast<RecordStatus>(arg0);
    easyar_String_copy(arg1, &arg1);
    std::string cpparg1 = std_string_from_easyar_String(std::shared_ptr<easyar_String>(arg1, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
    auto f = reinterpret_cast<std::function<void(RecordStatus, std::string)> *>(_state);
    (*f)(cpparg0, cpparg1);
}
static void FunctorOfVoidFromRecordStatusAndString_destroy(void * _state)
{
    auto f = reinterpret_cast<std::function<void(RecordStatus, std::string)> *>(_state);
    delete f;
}
static inline easyar_FunctorOfVoidFromRecordStatusAndString FunctorOfVoidFromRecordStatusAndString_to_c(std::function<void(RecordStatus, std::string)> f)
{
    if (f == nullptr) { return easyar_FunctorOfVoidFromRecordStatusAndString{nullptr, nullptr, nullptr}; }
    return easyar_FunctorOfVoidFromRecordStatusAndString{new std::function<void(RecordStatus, std::string)>(f), FunctorOfVoidFromRecordStatusAndString_func, FunctorOfVoidFromRecordStatusAndString_destroy};
}
#endif

}

#endif
