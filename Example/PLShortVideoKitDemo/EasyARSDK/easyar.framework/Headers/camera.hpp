//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_CAMERA_HPP__
#define __EASYAR_CAMERA_HPP__

#include "easyar/types.hpp"

namespace easyar {

class CameraCalibration
{
protected:
    std::shared_ptr<easyar_CameraCalibration> cdata_;
    void init_cdata(std::shared_ptr<easyar_CameraCalibration> cdata);
    CameraCalibration & operator=(const CameraCalibration & data) = delete;
public:
    CameraCalibration(std::shared_ptr<easyar_CameraCalibration> cdata);
    virtual ~CameraCalibration();

    std::shared_ptr<easyar_CameraCalibration> get_cdata();

    CameraCalibration();
    Vec2I size();
    Vec2F focalLength();
    Vec2F principalPoint();
    Vec4F distortionParameters();
    int rotation();
    Matrix44F projectionGL(float nearPlane, float farPlane);
};

class CameraDevice
{
protected:
    std::shared_ptr<easyar_CameraDevice> cdata_;
    void init_cdata(std::shared_ptr<easyar_CameraDevice> cdata);
    CameraDevice & operator=(const CameraDevice & data) = delete;
public:
    CameraDevice(std::shared_ptr<easyar_CameraDevice> cdata);
    virtual ~CameraDevice();

    std::shared_ptr<easyar_CameraDevice> get_cdata();

    CameraDevice();
    bool start();
    bool stop();
    void requestPermissions(std::function<void(PermissionStatus, std::string)> permissionCallback);
    bool open(int camera);
    bool close();
    bool isOpened();
    void setHorizontalFlip(bool flip);
    float frameRate();
    int supportedFrameRateCount();
    float supportedFrameRate(int idx);
    bool setFrameRate(float fps);
    Vec2I size();
    int supportedSizeCount();
    Vec2I supportedSize(int idx);
    bool setSize(Vec2I size);
    float zoomScale();
    void setZoomScale(float scale);
    float minZoomScale();
    float maxZoomScale();
    std::shared_ptr<CameraCalibration> cameraCalibration();
    bool setFlashTorchMode(bool on);
    bool setFocusMode(CameraDeviceFocusMode focusMode);
    Matrix44F projectionGL(float nearPlane, float farPlane);
};

#ifndef __EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
#define __EASYAR_FUNCTOROFVOIDFROMPERMISSIONSTATUSANDSTRING__
static void FunctorOfVoidFromPermissionStatusAndString_func(void * _state, easyar_PermissionStatus, easyar_String *);
static void FunctorOfVoidFromPermissionStatusAndString_destroy(void * _state);
static inline easyar_FunctorOfVoidFromPermissionStatusAndString FunctorOfVoidFromPermissionStatusAndString_to_c(std::function<void(PermissionStatus, std::string)> f);
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_CAMERA_HPP__
#define __IMPLEMENTATION_EASYAR_CAMERA_HPP__

#include "easyar/camera.h"
#include "easyar/vector.hpp"
#include "easyar/matrix.hpp"

namespace easyar {

inline CameraCalibration::CameraCalibration(std::shared_ptr<easyar_CameraCalibration> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline CameraCalibration::~CameraCalibration()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_CameraCalibration> CameraCalibration::get_cdata()
{
    return cdata_;
}
inline void CameraCalibration::init_cdata(std::shared_ptr<easyar_CameraCalibration> cdata)
{
    cdata_ = cdata;
}
inline CameraCalibration::CameraCalibration()
    :
    cdata_(nullptr)
{
    easyar_CameraCalibration * _return_value_;
    easyar_CameraCalibration__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_CameraCalibration>(_return_value_, [](easyar_CameraCalibration * ptr) { easyar_CameraCalibration__dtor(ptr); }));
}
inline Vec2I CameraCalibration::size()
{
    auto _return_value_ = easyar_CameraCalibration_size(cdata_.get());
    return Vec2I{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline Vec2F CameraCalibration::focalLength()
{
    auto _return_value_ = easyar_CameraCalibration_focalLength(cdata_.get());
    return Vec2F{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline Vec2F CameraCalibration::principalPoint()
{
    auto _return_value_ = easyar_CameraCalibration_principalPoint(cdata_.get());
    return Vec2F{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline Vec4F CameraCalibration::distortionParameters()
{
    auto _return_value_ = easyar_CameraCalibration_distortionParameters(cdata_.get());
    return Vec4F{{{_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3]}}};
}
inline int CameraCalibration::rotation()
{
    auto _return_value_ = easyar_CameraCalibration_rotation(cdata_.get());
    return _return_value_;
}
inline Matrix44F CameraCalibration::projectionGL(float arg0, float arg1)
{
    auto _return_value_ = easyar_CameraCalibration_projectionGL(cdata_.get(), arg0, arg1);
    return Matrix44F{{{_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11], _return_value_.data[12], _return_value_.data[13], _return_value_.data[14], _return_value_.data[15]}}};
}

inline CameraDevice::CameraDevice(std::shared_ptr<easyar_CameraDevice> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline CameraDevice::~CameraDevice()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_CameraDevice> CameraDevice::get_cdata()
{
    return cdata_;
}
inline void CameraDevice::init_cdata(std::shared_ptr<easyar_CameraDevice> cdata)
{
    cdata_ = cdata;
}
inline CameraDevice::CameraDevice()
    :
    cdata_(nullptr)
{
    easyar_CameraDevice * _return_value_;
    easyar_CameraDevice__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_CameraDevice>(_return_value_, [](easyar_CameraDevice * ptr) { easyar_CameraDevice__dtor(ptr); }));
}
inline bool CameraDevice::start()
{
    auto _return_value_ = easyar_CameraDevice_start(cdata_.get());
    return _return_value_;
}
inline bool CameraDevice::stop()
{
    auto _return_value_ = easyar_CameraDevice_stop(cdata_.get());
    return _return_value_;
}
inline void CameraDevice::requestPermissions(std::function<void(PermissionStatus, std::string)> arg0)
{
    easyar_CameraDevice_requestPermissions(cdata_.get(), FunctorOfVoidFromPermissionStatusAndString_to_c(arg0));
}
inline bool CameraDevice::open(int arg0)
{
    auto _return_value_ = easyar_CameraDevice_open(cdata_.get(), arg0);
    return _return_value_;
}
inline bool CameraDevice::close()
{
    auto _return_value_ = easyar_CameraDevice_close(cdata_.get());
    return _return_value_;
}
inline bool CameraDevice::isOpened()
{
    auto _return_value_ = easyar_CameraDevice_isOpened(cdata_.get());
    return _return_value_;
}
inline void CameraDevice::setHorizontalFlip(bool arg0)
{
    easyar_CameraDevice_setHorizontalFlip(cdata_.get(), arg0);
}
inline float CameraDevice::frameRate()
{
    auto _return_value_ = easyar_CameraDevice_frameRate(cdata_.get());
    return _return_value_;
}
inline int CameraDevice::supportedFrameRateCount()
{
    auto _return_value_ = easyar_CameraDevice_supportedFrameRateCount(cdata_.get());
    return _return_value_;
}
inline float CameraDevice::supportedFrameRate(int arg0)
{
    auto _return_value_ = easyar_CameraDevice_supportedFrameRate(cdata_.get(), arg0);
    return _return_value_;
}
inline bool CameraDevice::setFrameRate(float arg0)
{
    auto _return_value_ = easyar_CameraDevice_setFrameRate(cdata_.get(), arg0);
    return _return_value_;
}
inline Vec2I CameraDevice::size()
{
    auto _return_value_ = easyar_CameraDevice_size(cdata_.get());
    return Vec2I{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline int CameraDevice::supportedSizeCount()
{
    auto _return_value_ = easyar_CameraDevice_supportedSizeCount(cdata_.get());
    return _return_value_;
}
inline Vec2I CameraDevice::supportedSize(int arg0)
{
    auto _return_value_ = easyar_CameraDevice_supportedSize(cdata_.get(), arg0);
    return Vec2I{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline bool CameraDevice::setSize(Vec2I arg0)
{
    auto _return_value_ = easyar_CameraDevice_setSize(cdata_.get(), easyar_Vec2I{{arg0.data[0], arg0.data[1]}});
    return _return_value_;
}
inline float CameraDevice::zoomScale()
{
    auto _return_value_ = easyar_CameraDevice_zoomScale(cdata_.get());
    return _return_value_;
}
inline void CameraDevice::setZoomScale(float arg0)
{
    easyar_CameraDevice_setZoomScale(cdata_.get(), arg0);
}
inline float CameraDevice::minZoomScale()
{
    auto _return_value_ = easyar_CameraDevice_minZoomScale(cdata_.get());
    return _return_value_;
}
inline float CameraDevice::maxZoomScale()
{
    auto _return_value_ = easyar_CameraDevice_maxZoomScale(cdata_.get());
    return _return_value_;
}
inline std::shared_ptr<CameraCalibration> CameraDevice::cameraCalibration()
{
    easyar_CameraCalibration * _return_value_;
    easyar_CameraDevice_cameraCalibration(cdata_.get(), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<CameraCalibration>(std::shared_ptr<easyar_CameraCalibration>(_return_value_, [](easyar_CameraCalibration * ptr) { easyar_CameraCalibration__dtor(ptr); })));
}
inline bool CameraDevice::setFlashTorchMode(bool arg0)
{
    auto _return_value_ = easyar_CameraDevice_setFlashTorchMode(cdata_.get(), arg0);
    return _return_value_;
}
inline bool CameraDevice::setFocusMode(CameraDeviceFocusMode arg0)
{
    auto _return_value_ = easyar_CameraDevice_setFocusMode(cdata_.get(), static_cast<easyar_CameraDeviceFocusMode>(arg0));
    return _return_value_;
}
inline Matrix44F CameraDevice::projectionGL(float arg0, float arg1)
{
    auto _return_value_ = easyar_CameraDevice_projectionGL(cdata_.get(), arg0, arg1);
    return Matrix44F{{{_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11], _return_value_.data[12], _return_value_.data[13], _return_value_.data[14], _return_value_.data[15]}}};
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

}

#endif
