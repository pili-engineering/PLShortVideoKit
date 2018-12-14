//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_FRAMEFILTER_HPP__
#define __EASYAR_FRAMEFILTER_HPP__

#include "easyar/types.hpp"

namespace easyar {

class FrameFilter
{
protected:
    std::shared_ptr<easyar_FrameFilter> cdata_;
    void init_cdata(std::shared_ptr<easyar_FrameFilter> cdata);
    FrameFilter & operator=(const FrameFilter & data) = delete;
public:
    FrameFilter(std::shared_ptr<easyar_FrameFilter> cdata);
    virtual ~FrameFilter();

    std::shared_ptr<easyar_FrameFilter> get_cdata();

    bool attachStreamer(std::shared_ptr<FrameStreamer> obj);
    bool start();
    bool stop();
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_FRAMEFILTER_HPP__
#define __IMPLEMENTATION_EASYAR_FRAMEFILTER_HPP__

#include "easyar/framefilter.h"
#include "easyar/framestreamer.hpp"

namespace easyar {

inline FrameFilter::FrameFilter(std::shared_ptr<easyar_FrameFilter> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline FrameFilter::~FrameFilter()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_FrameFilter> FrameFilter::get_cdata()
{
    return cdata_;
}
inline void FrameFilter::init_cdata(std::shared_ptr<easyar_FrameFilter> cdata)
{
    cdata_ = cdata;
}
inline bool FrameFilter::attachStreamer(std::shared_ptr<FrameStreamer> arg0)
{
    auto _return_value_ = easyar_FrameFilter_attachStreamer(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline bool FrameFilter::start()
{
    auto _return_value_ = easyar_FrameFilter_start(cdata_.get());
    return _return_value_;
}
inline bool FrameFilter::stop()
{
    auto _return_value_ = easyar_FrameFilter_stop(cdata_.get());
    return _return_value_;
}

}

#endif
