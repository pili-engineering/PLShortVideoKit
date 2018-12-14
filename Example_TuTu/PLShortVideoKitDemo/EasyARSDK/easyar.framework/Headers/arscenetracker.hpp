//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_ARSCENETRACKER_HPP__
#define __EASYAR_ARSCENETRACKER_HPP__

#include "easyar/types.hpp"
#include "easyar/framefilter.hpp"

namespace easyar {

class ARSceneTracker : public FrameFilter
{
protected:
    std::shared_ptr<easyar_ARSceneTracker> cdata_;
    void init_cdata(std::shared_ptr<easyar_ARSceneTracker> cdata);
    ARSceneTracker & operator=(const ARSceneTracker & data) = delete;
public:
    ARSceneTracker(std::shared_ptr<easyar_ARSceneTracker> cdata);
    virtual ~ARSceneTracker();

    std::shared_ptr<easyar_ARSceneTracker> get_cdata();

    ARSceneTracker();
    bool attachStreamer(std::shared_ptr<FrameStreamer> obj);
    bool start();
    bool stop();
    static std::shared_ptr<ARSceneTracker> tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v);
};

}

namespace std {

template<>
inline shared_ptr<easyar::ARSceneTracker> dynamic_pointer_cast<easyar::ARSceneTracker, easyar::FrameFilter>(const shared_ptr<easyar::FrameFilter> & r) noexcept
{
    return easyar::ARSceneTracker::tryCastFromFrameFilter(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_ARSCENETRACKER_HPP__
#define __IMPLEMENTATION_EASYAR_ARSCENETRACKER_HPP__

#include "easyar/arscenetracker.h"
#include "easyar/framefilter.hpp"
#include "easyar/framestreamer.hpp"

namespace easyar {

inline ARSceneTracker::ARSceneTracker(std::shared_ptr<easyar_ARSceneTracker> cdata)
    :
    FrameFilter(std::shared_ptr<easyar_FrameFilter>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline ARSceneTracker::~ARSceneTracker()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_ARSceneTracker> ARSceneTracker::get_cdata()
{
    return cdata_;
}
inline void ARSceneTracker::init_cdata(std::shared_ptr<easyar_ARSceneTracker> cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameFilter * ptr = nullptr;
        easyar_castARSceneTrackerToFrameFilter(cdata_.get(), &ptr);
        FrameFilter::init_cdata(std::shared_ptr<easyar_FrameFilter>(ptr, [](easyar_FrameFilter * ptr) { easyar_FrameFilter__dtor(ptr); }));
    }
}
inline ARSceneTracker::ARSceneTracker()
    :
    FrameFilter(std::shared_ptr<easyar_FrameFilter>(nullptr)),
    cdata_(nullptr)
{
    easyar_ARSceneTracker * _return_value_;
    easyar_ARSceneTracker__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_ARSceneTracker>(_return_value_, [](easyar_ARSceneTracker * ptr) { easyar_ARSceneTracker__dtor(ptr); }));
}
inline bool ARSceneTracker::attachStreamer(std::shared_ptr<FrameStreamer> arg0)
{
    auto _return_value_ = easyar_ARSceneTracker_attachStreamer(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline bool ARSceneTracker::start()
{
    auto _return_value_ = easyar_ARSceneTracker_start(cdata_.get());
    return _return_value_;
}
inline bool ARSceneTracker::stop()
{
    auto _return_value_ = easyar_ARSceneTracker_stop(cdata_.get());
    return _return_value_;
}
inline std::shared_ptr<ARSceneTracker> ARSceneTracker::tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_ARSceneTracker * cdata;
    easyar_tryCastFrameFilterToARSceneTracker(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<ARSceneTracker>(std::shared_ptr<easyar_ARSceneTracker>(cdata, [](easyar_ARSceneTracker * ptr) { easyar_ARSceneTracker__dtor(ptr); }));
}

}

#endif
