//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_ARSCENETRACKER_HXX__
#define __EASYAR_ARSCENETRACKER_HXX__

#include "easyar/types.hxx"
#include "easyar/framefilter.hxx"

namespace easyar {

class ARSceneTracker : public FrameFilter
{
protected:
    easyar_ARSceneTracker * cdata_ ;
    void init_cdata(easyar_ARSceneTracker * cdata);
    virtual ARSceneTracker & operator=(const ARSceneTracker & data) { return *this; } //deleted
public:
    ARSceneTracker(easyar_ARSceneTracker * cdata);
    virtual ~ARSceneTracker();

    ARSceneTracker(const ARSceneTracker & data);
    const easyar_ARSceneTracker * get_cdata() const;
    easyar_ARSceneTracker * get_cdata();

    ARSceneTracker();
    bool attachStreamer(FrameStreamer * obj);
    bool start();
    bool stop();
    static void tryCastFromFrameFilter(FrameFilter * v, /* OUT */ ARSceneTracker * * Return);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_ARSCENETRACKER_HXX__
#define __IMPLEMENTATION_EASYAR_ARSCENETRACKER_HXX__

#include "easyar/arscenetracker.h"
#include "easyar/framefilter.hxx"
#include "easyar/framestreamer.hxx"

namespace easyar {

inline ARSceneTracker::ARSceneTracker(easyar_ARSceneTracker * cdata)
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline ARSceneTracker::~ARSceneTracker()
{
    if (cdata_) {
        easyar_ARSceneTracker__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ARSceneTracker::ARSceneTracker(const ARSceneTracker & data)
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    easyar_ARSceneTracker * cdata = NULL;
    easyar_ARSceneTracker__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_ARSceneTracker * ARSceneTracker::get_cdata() const
{
    return cdata_;
}
inline easyar_ARSceneTracker * ARSceneTracker::get_cdata()
{
    return cdata_;
}
inline void ARSceneTracker::init_cdata(easyar_ARSceneTracker * cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameFilter * cdata_inner = NULL;
        easyar_castARSceneTrackerToFrameFilter(cdata, &cdata_inner);
        FrameFilter::init_cdata(cdata_inner);
    }
}
inline ARSceneTracker::ARSceneTracker()
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    easyar_ARSceneTracker * _return_value_ = NULL;
    easyar_ARSceneTracker__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline bool ARSceneTracker::attachStreamer(FrameStreamer * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ARSceneTracker_attachStreamer(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline bool ARSceneTracker::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ARSceneTracker_start(cdata_);
    return _return_value_;
}
inline bool ARSceneTracker::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ARSceneTracker_stop(cdata_);
    return _return_value_;
}
inline void ARSceneTracker::tryCastFromFrameFilter(FrameFilter * v, /* OUT */ ARSceneTracker * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ARSceneTracker * cdata = NULL;
    easyar_tryCastFrameFilterToARSceneTracker(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new ARSceneTracker(cdata);
}

}

#endif
