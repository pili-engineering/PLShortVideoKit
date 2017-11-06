//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_QRCODE_HXX__
#define __EASYAR_QRCODE_HXX__

#include "easyar/types.hxx"
#include "easyar/framefilter.hxx"

namespace easyar {

class QRCodeScanner : public FrameFilter
{
protected:
    easyar_QRCodeScanner * cdata_ ;
    void init_cdata(easyar_QRCodeScanner * cdata);
    virtual QRCodeScanner & operator=(const QRCodeScanner & data) { return *this; } //deleted
public:
    QRCodeScanner(easyar_QRCodeScanner * cdata);
    virtual ~QRCodeScanner();

    QRCodeScanner(const QRCodeScanner & data);
    const easyar_QRCodeScanner * get_cdata() const;
    easyar_QRCodeScanner * get_cdata();

    QRCodeScanner();
    bool attachStreamer(FrameStreamer * obj);
    bool start();
    bool stop();
    static void tryCastFromFrameFilter(FrameFilter * v, /* OUT */ QRCodeScanner * * Return);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_QRCODE_HXX__
#define __IMPLEMENTATION_EASYAR_QRCODE_HXX__

#include "easyar/qrcode.h"
#include "easyar/framefilter.hxx"
#include "easyar/framestreamer.hxx"

namespace easyar {

inline QRCodeScanner::QRCodeScanner(easyar_QRCodeScanner * cdata)
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline QRCodeScanner::~QRCodeScanner()
{
    if (cdata_) {
        easyar_QRCodeScanner__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline QRCodeScanner::QRCodeScanner(const QRCodeScanner & data)
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    easyar_QRCodeScanner * cdata = NULL;
    easyar_QRCodeScanner__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_QRCodeScanner * QRCodeScanner::get_cdata() const
{
    return cdata_;
}
inline easyar_QRCodeScanner * QRCodeScanner::get_cdata()
{
    return cdata_;
}
inline void QRCodeScanner::init_cdata(easyar_QRCodeScanner * cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameFilter * cdata_inner = NULL;
        easyar_castQRCodeScannerToFrameFilter(cdata, &cdata_inner);
        FrameFilter::init_cdata(cdata_inner);
    }
}
inline QRCodeScanner::QRCodeScanner()
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    easyar_QRCodeScanner * _return_value_ = NULL;
    easyar_QRCodeScanner__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline bool QRCodeScanner::attachStreamer(FrameStreamer * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_QRCodeScanner_attachStreamer(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline bool QRCodeScanner::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_QRCodeScanner_start(cdata_);
    return _return_value_;
}
inline bool QRCodeScanner::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_QRCodeScanner_stop(cdata_);
    return _return_value_;
}
inline void QRCodeScanner::tryCastFromFrameFilter(FrameFilter * v, /* OUT */ QRCodeScanner * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_QRCodeScanner * cdata = NULL;
    easyar_tryCastFrameFilterToQRCodeScanner(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new QRCodeScanner(cdata);
}

}

#endif
