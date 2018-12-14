//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_CAMERA_HXX__
#define __EASYAR_CAMERA_HXX__

#include "easyar/types.hxx"

namespace easyar {

class CameraCalibration
{
protected:
    easyar_CameraCalibration * cdata_ ;
    void init_cdata(easyar_CameraCalibration * cdata);
    virtual CameraCalibration & operator=(const CameraCalibration & data) { return *this; } //deleted
public:
    CameraCalibration(easyar_CameraCalibration * cdata);
    virtual ~CameraCalibration();

    CameraCalibration(const CameraCalibration & data);
    const easyar_CameraCalibration * get_cdata() const;
    easyar_CameraCalibration * get_cdata();

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
    easyar_CameraDevice * cdata_ ;
    void init_cdata(easyar_CameraDevice * cdata);
    virtual CameraDevice & operator=(const CameraDevice & data) { return *this; } //deleted
public:
    CameraDevice(easyar_CameraDevice * cdata);
    virtual ~CameraDevice();

    CameraDevice(const CameraDevice & data);
    const easyar_CameraDevice * get_cdata() const;
    easyar_CameraDevice * get_cdata();

    CameraDevice();
    bool start();
    bool stop();
    void requestPermissions(FunctorOfVoidFromPermissionStatusAndString permissionCallback);
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
    void cameraCalibration(/* OUT */ CameraCalibration * * Return);
    bool setFlashTorchMode(bool on);
    bool setFocusMode(CameraDeviceFocusMode focusMode);
    Matrix44F projectionGL(float nearPlane, float farPlane);
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

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_CAMERA_HXX__
#define __IMPLEMENTATION_EASYAR_CAMERA_HXX__

#include "easyar/camera.h"
#include "easyar/vector.hxx"
#include "easyar/matrix.hxx"

namespace easyar {

inline CameraCalibration::CameraCalibration(easyar_CameraCalibration * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline CameraCalibration::~CameraCalibration()
{
    if (cdata_) {
        easyar_CameraCalibration__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline CameraCalibration::CameraCalibration(const CameraCalibration & data)
    :
    cdata_(NULL)
{
    easyar_CameraCalibration * cdata = NULL;
    easyar_CameraCalibration__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_CameraCalibration * CameraCalibration::get_cdata() const
{
    return cdata_;
}
inline easyar_CameraCalibration * CameraCalibration::get_cdata()
{
    return cdata_;
}
inline void CameraCalibration::init_cdata(easyar_CameraCalibration * cdata)
{
    cdata_ = cdata;
}
inline CameraCalibration::CameraCalibration()
    :
    cdata_(NULL)
{
    easyar_CameraCalibration * _return_value_ = NULL;
    easyar_CameraCalibration__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline Vec2I CameraCalibration::size()
{
    if (cdata_ == NULL) {
        return Vec2I();
    }
    easyar_Vec2I _return_value_ = easyar_CameraCalibration_size(cdata_);
    return Vec2I(_return_value_.data[0], _return_value_.data[1]);
}
inline Vec2F CameraCalibration::focalLength()
{
    if (cdata_ == NULL) {
        return Vec2F();
    }
    easyar_Vec2F _return_value_ = easyar_CameraCalibration_focalLength(cdata_);
    return Vec2F(_return_value_.data[0], _return_value_.data[1]);
}
inline Vec2F CameraCalibration::principalPoint()
{
    if (cdata_ == NULL) {
        return Vec2F();
    }
    easyar_Vec2F _return_value_ = easyar_CameraCalibration_principalPoint(cdata_);
    return Vec2F(_return_value_.data[0], _return_value_.data[1]);
}
inline Vec4F CameraCalibration::distortionParameters()
{
    if (cdata_ == NULL) {
        return Vec4F();
    }
    easyar_Vec4F _return_value_ = easyar_CameraCalibration_distortionParameters(cdata_);
    return Vec4F(_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3]);
}
inline int CameraCalibration::rotation()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_CameraCalibration_rotation(cdata_);
    return _return_value_;
}
inline Matrix44F CameraCalibration::projectionGL(float arg0, float arg1)
{
    if (cdata_ == NULL) {
        return Matrix44F();
    }
    easyar_Matrix44F _return_value_ = easyar_CameraCalibration_projectionGL(cdata_, arg0, arg1);
    return Matrix44F(_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11], _return_value_.data[12], _return_value_.data[13], _return_value_.data[14], _return_value_.data[15]);
}

inline CameraDevice::CameraDevice(easyar_CameraDevice * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline CameraDevice::~CameraDevice()
{
    if (cdata_) {
        easyar_CameraDevice__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline CameraDevice::CameraDevice(const CameraDevice & data)
    :
    cdata_(NULL)
{
    easyar_CameraDevice * cdata = NULL;
    easyar_CameraDevice__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_CameraDevice * CameraDevice::get_cdata() const
{
    return cdata_;
}
inline easyar_CameraDevice * CameraDevice::get_cdata()
{
    return cdata_;
}
inline void CameraDevice::init_cdata(easyar_CameraDevice * cdata)
{
    cdata_ = cdata;
}
inline CameraDevice::CameraDevice()
    :
    cdata_(NULL)
{
    easyar_CameraDevice * _return_value_ = NULL;
    easyar_CameraDevice__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline bool CameraDevice::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_start(cdata_);
    return _return_value_;
}
inline bool CameraDevice::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_stop(cdata_);
    return _return_value_;
}
inline void CameraDevice::requestPermissions(FunctorOfVoidFromPermissionStatusAndString arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_CameraDevice_requestPermissions(cdata_, FunctorOfVoidFromPermissionStatusAndString_to_c(arg0));
}
inline bool CameraDevice::open(int arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_open(cdata_, arg0);
    return _return_value_;
}
inline bool CameraDevice::close()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_close(cdata_);
    return _return_value_;
}
inline bool CameraDevice::isOpened()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_isOpened(cdata_);
    return _return_value_;
}
inline void CameraDevice::setHorizontalFlip(bool arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_CameraDevice_setHorizontalFlip(cdata_, arg0);
}
inline float CameraDevice::frameRate()
{
    if (cdata_ == NULL) {
        return float();
    }
    float _return_value_ = easyar_CameraDevice_frameRate(cdata_);
    return _return_value_;
}
inline int CameraDevice::supportedFrameRateCount()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_CameraDevice_supportedFrameRateCount(cdata_);
    return _return_value_;
}
inline float CameraDevice::supportedFrameRate(int arg0)
{
    if (cdata_ == NULL) {
        return float();
    }
    float _return_value_ = easyar_CameraDevice_supportedFrameRate(cdata_, arg0);
    return _return_value_;
}
inline bool CameraDevice::setFrameRate(float arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_setFrameRate(cdata_, arg0);
    return _return_value_;
}
inline Vec2I CameraDevice::size()
{
    if (cdata_ == NULL) {
        return Vec2I();
    }
    easyar_Vec2I _return_value_ = easyar_CameraDevice_size(cdata_);
    return Vec2I(_return_value_.data[0], _return_value_.data[1]);
}
inline int CameraDevice::supportedSizeCount()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_CameraDevice_supportedSizeCount(cdata_);
    return _return_value_;
}
inline Vec2I CameraDevice::supportedSize(int arg0)
{
    if (cdata_ == NULL) {
        return Vec2I();
    }
    easyar_Vec2I _return_value_ = easyar_CameraDevice_supportedSize(cdata_, arg0);
    return Vec2I(_return_value_.data[0], _return_value_.data[1]);
}
inline bool CameraDevice::setSize(Vec2I arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_setSize(cdata_, arg0.get_cdata());
    return _return_value_;
}
inline float CameraDevice::zoomScale()
{
    if (cdata_ == NULL) {
        return float();
    }
    float _return_value_ = easyar_CameraDevice_zoomScale(cdata_);
    return _return_value_;
}
inline void CameraDevice::setZoomScale(float arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_CameraDevice_setZoomScale(cdata_, arg0);
}
inline float CameraDevice::minZoomScale()
{
    if (cdata_ == NULL) {
        return float();
    }
    float _return_value_ = easyar_CameraDevice_minZoomScale(cdata_);
    return _return_value_;
}
inline float CameraDevice::maxZoomScale()
{
    if (cdata_ == NULL) {
        return float();
    }
    float _return_value_ = easyar_CameraDevice_maxZoomScale(cdata_);
    return _return_value_;
}
inline void CameraDevice::cameraCalibration(/* OUT */ CameraCalibration * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_CameraCalibration * _return_value_ = NULL;
    easyar_CameraDevice_cameraCalibration(cdata_, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new CameraCalibration(_return_value_));
}
inline bool CameraDevice::setFlashTorchMode(bool arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_setFlashTorchMode(cdata_, arg0);
    return _return_value_;
}
inline bool CameraDevice::setFocusMode(CameraDeviceFocusMode arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraDevice_setFocusMode(cdata_, static_cast<easyar_CameraDeviceFocusMode>(arg0));
    return _return_value_;
}
inline Matrix44F CameraDevice::projectionGL(float arg0, float arg1)
{
    if (cdata_ == NULL) {
        return Matrix44F();
    }
    easyar_Matrix44F _return_value_ = easyar_CameraDevice_projectionGL(cdata_, arg0, arg1);
    return Matrix44F(_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11], _return_value_.data[12], _return_value_.data[13], _return_value_.data[14], _return_value_.data[15]);
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

}

#endif
