//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_FRAMESTREAMER_HXX__
#define __EASYAR_FRAMESTREAMER_HXX__

#include "easyar/types.hxx"

namespace easyar {

class FrameStreamer
{
protected:
    easyar_FrameStreamer * cdata_ ;
    void init_cdata(easyar_FrameStreamer * cdata);
    virtual FrameStreamer & operator=(const FrameStreamer & data) { return *this; } //deleted
public:
    FrameStreamer(easyar_FrameStreamer * cdata);
    virtual ~FrameStreamer();

    FrameStreamer(const FrameStreamer & data);
    const easyar_FrameStreamer * get_cdata() const;
    easyar_FrameStreamer * get_cdata();

    void peek(/* OUT */ Frame * * Return);
    bool start();
    bool stop();
};

class CameraFrameStreamer : public FrameStreamer
{
protected:
    easyar_CameraFrameStreamer * cdata_ ;
    void init_cdata(easyar_CameraFrameStreamer * cdata);
    virtual CameraFrameStreamer & operator=(const CameraFrameStreamer & data) { return *this; } //deleted
public:
    CameraFrameStreamer(easyar_CameraFrameStreamer * cdata);
    virtual ~CameraFrameStreamer();

    CameraFrameStreamer(const CameraFrameStreamer & data);
    const easyar_CameraFrameStreamer * get_cdata() const;
    easyar_CameraFrameStreamer * get_cdata();

    CameraFrameStreamer();
    bool attachCamera(CameraDevice * obj);
    void peek(/* OUT */ Frame * * Return);
    bool start();
    bool stop();
    static void tryCastFromFrameStreamer(FrameStreamer * v, /* OUT */ CameraFrameStreamer * * Return);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_FRAMESTREAMER_HXX__
#define __IMPLEMENTATION_EASYAR_FRAMESTREAMER_HXX__

#include "easyar/framestreamer.h"
#include "easyar/frame.hxx"
#include "easyar/camera.hxx"

namespace easyar {

inline FrameStreamer::FrameStreamer(easyar_FrameStreamer * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline FrameStreamer::~FrameStreamer()
{
    if (cdata_) {
        easyar_FrameStreamer__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline FrameStreamer::FrameStreamer(const FrameStreamer & data)
    :
    cdata_(NULL)
{
    easyar_FrameStreamer * cdata = NULL;
    easyar_FrameStreamer__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_FrameStreamer * FrameStreamer::get_cdata() const
{
    return cdata_;
}
inline easyar_FrameStreamer * FrameStreamer::get_cdata()
{
    return cdata_;
}
inline void FrameStreamer::init_cdata(easyar_FrameStreamer * cdata)
{
    cdata_ = cdata;
}
inline void FrameStreamer::peek(/* OUT */ Frame * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_Frame * _return_value_ = NULL;
    easyar_FrameStreamer_peek(cdata_, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new Frame(_return_value_));
}
inline bool FrameStreamer::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_FrameStreamer_start(cdata_);
    return _return_value_;
}
inline bool FrameStreamer::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_FrameStreamer_stop(cdata_);
    return _return_value_;
}

inline CameraFrameStreamer::CameraFrameStreamer(easyar_CameraFrameStreamer * cdata)
    :
    FrameStreamer(static_cast<easyar_FrameStreamer *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline CameraFrameStreamer::~CameraFrameStreamer()
{
    if (cdata_) {
        easyar_CameraFrameStreamer__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline CameraFrameStreamer::CameraFrameStreamer(const CameraFrameStreamer & data)
    :
    FrameStreamer(static_cast<easyar_FrameStreamer *>(NULL)),
    cdata_(NULL)
{
    easyar_CameraFrameStreamer * cdata = NULL;
    easyar_CameraFrameStreamer__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_CameraFrameStreamer * CameraFrameStreamer::get_cdata() const
{
    return cdata_;
}
inline easyar_CameraFrameStreamer * CameraFrameStreamer::get_cdata()
{
    return cdata_;
}
inline void CameraFrameStreamer::init_cdata(easyar_CameraFrameStreamer * cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameStreamer * cdata_inner = NULL;
        easyar_castCameraFrameStreamerToFrameStreamer(cdata, &cdata_inner);
        FrameStreamer::init_cdata(cdata_inner);
    }
}
inline CameraFrameStreamer::CameraFrameStreamer()
    :
    FrameStreamer(static_cast<easyar_FrameStreamer *>(NULL)),
    cdata_(NULL)
{
    easyar_CameraFrameStreamer * _return_value_ = NULL;
    easyar_CameraFrameStreamer__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline bool CameraFrameStreamer::attachCamera(CameraDevice * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraFrameStreamer_attachCamera(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline void CameraFrameStreamer::peek(/* OUT */ Frame * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_Frame * _return_value_ = NULL;
    easyar_CameraFrameStreamer_peek(cdata_, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new Frame(_return_value_));
}
inline bool CameraFrameStreamer::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraFrameStreamer_start(cdata_);
    return _return_value_;
}
inline bool CameraFrameStreamer::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CameraFrameStreamer_stop(cdata_);
    return _return_value_;
}
inline void CameraFrameStreamer::tryCastFromFrameStreamer(FrameStreamer * v, /* OUT */ CameraFrameStreamer * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_CameraFrameStreamer * cdata = NULL;
    easyar_tryCastFrameStreamerToCameraFrameStreamer(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new CameraFrameStreamer(cdata);
}

}

#endif
