//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_FRAMEFILTER_HXX__
#define __EASYAR_FRAMEFILTER_HXX__

#include "easyar/types.hxx"

namespace easyar {

class FrameFilter
{
protected:
    easyar_FrameFilter * cdata_ ;
    void init_cdata(easyar_FrameFilter * cdata);
    virtual FrameFilter & operator=(const FrameFilter & data) { return *this; } //deleted
public:
    FrameFilter(easyar_FrameFilter * cdata);
    virtual ~FrameFilter();

    FrameFilter(const FrameFilter & data);
    const easyar_FrameFilter * get_cdata() const;
    easyar_FrameFilter * get_cdata();

    bool attachStreamer(FrameStreamer * obj);
    bool start();
    bool stop();
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_FRAMEFILTER_HXX__
#define __IMPLEMENTATION_EASYAR_FRAMEFILTER_HXX__

#include "easyar/framefilter.h"
#include "easyar/framestreamer.hxx"

namespace easyar {

inline FrameFilter::FrameFilter(easyar_FrameFilter * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline FrameFilter::~FrameFilter()
{
    if (cdata_) {
        easyar_FrameFilter__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline FrameFilter::FrameFilter(const FrameFilter & data)
    :
    cdata_(NULL)
{
    easyar_FrameFilter * cdata = NULL;
    easyar_FrameFilter__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_FrameFilter * FrameFilter::get_cdata() const
{
    return cdata_;
}
inline easyar_FrameFilter * FrameFilter::get_cdata()
{
    return cdata_;
}
inline void FrameFilter::init_cdata(easyar_FrameFilter * cdata)
{
    cdata_ = cdata;
}
inline bool FrameFilter::attachStreamer(FrameStreamer * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_FrameFilter_attachStreamer(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline bool FrameFilter::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_FrameFilter_start(cdata_);
    return _return_value_;
}
inline bool FrameFilter::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_FrameFilter_stop(cdata_);
    return _return_value_;
}

}

#endif
