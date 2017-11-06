//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_TARGETTRACKER_HPP__
#define __EASYAR_TARGETTRACKER_HPP__

#include "easyar/types.hpp"
#include "easyar/framefilter.hpp"

namespace easyar {

class TargetTracker : public FrameFilter
{
protected:
    std::shared_ptr<easyar_TargetTracker> cdata_;
    void init_cdata(std::shared_ptr<easyar_TargetTracker> cdata);
    TargetTracker & operator=(const TargetTracker & data) = delete;
public:
    TargetTracker(std::shared_ptr<easyar_TargetTracker> cdata);
    virtual ~TargetTracker();

    std::shared_ptr<easyar_TargetTracker> get_cdata();

    void loadTarget(std::shared_ptr<Target> target, std::function<void(std::shared_ptr<Target>, bool)> callback);
    void unloadTarget(std::shared_ptr<Target> target, std::function<void(std::shared_ptr<Target>, bool)> callback);
    bool loadTargetBlocked(std::shared_ptr<Target> target);
    bool unloadTargetBlocked(std::shared_ptr<Target> target);
    std::vector<std::shared_ptr<Target>> targets();
    bool setSimultaneousNum(int num);
    int simultaneousNum();
    bool attachStreamer(std::shared_ptr<FrameStreamer> obj);
    bool start();
    bool stop();
    static std::shared_ptr<TargetTracker> tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v);
};

#ifndef __EASYAR_FUNCTOROFVOIDFROMPOINTEROFTARGETANDBOOL__
#define __EASYAR_FUNCTOROFVOIDFROMPOINTEROFTARGETANDBOOL__
static void FunctorOfVoidFromPointerOfTargetAndBool_func(void * _state, easyar_Target *, bool);
static void FunctorOfVoidFromPointerOfTargetAndBool_destroy(void * _state);
static inline easyar_FunctorOfVoidFromPointerOfTargetAndBool FunctorOfVoidFromPointerOfTargetAndBool_to_c(std::function<void(std::shared_ptr<Target>, bool)> f);
#endif

#ifndef __EASYAR_LISTOFPOINTEROFTARGET__
#define __EASYAR_LISTOFPOINTEROFTARGET__
static inline std::shared_ptr<easyar_ListOfPointerOfTarget> std_vector_to_easyar_ListOfPointerOfTarget(std::vector<std::shared_ptr<Target>> l);
static inline std::vector<std::shared_ptr<Target>> std_vector_from_easyar_ListOfPointerOfTarget(std::shared_ptr<easyar_ListOfPointerOfTarget> pl);
#endif

}

namespace std {

template<>
inline shared_ptr<easyar::TargetTracker> dynamic_pointer_cast<easyar::TargetTracker, easyar::FrameFilter>(const shared_ptr<easyar::FrameFilter> & r) noexcept
{
    return easyar::TargetTracker::tryCastFromFrameFilter(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_TARGETTRACKER_HPP__
#define __IMPLEMENTATION_EASYAR_TARGETTRACKER_HPP__

#include "easyar/targettracker.h"
#include "easyar/framefilter.hpp"
#include "easyar/target.hpp"
#include "easyar/framestreamer.hpp"

namespace easyar {

inline TargetTracker::TargetTracker(std::shared_ptr<easyar_TargetTracker> cdata)
    :
    FrameFilter(std::shared_ptr<easyar_FrameFilter>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline TargetTracker::~TargetTracker()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_TargetTracker> TargetTracker::get_cdata()
{
    return cdata_;
}
inline void TargetTracker::init_cdata(std::shared_ptr<easyar_TargetTracker> cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameFilter * ptr = nullptr;
        easyar_castTargetTrackerToFrameFilter(cdata_.get(), &ptr);
        FrameFilter::init_cdata(std::shared_ptr<easyar_FrameFilter>(ptr, [](easyar_FrameFilter * ptr) { easyar_FrameFilter__dtor(ptr); }));
    }
}
inline void TargetTracker::loadTarget(std::shared_ptr<Target> arg0, std::function<void(std::shared_ptr<Target>, bool)> arg1)
{
    easyar_TargetTracker_loadTarget(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), FunctorOfVoidFromPointerOfTargetAndBool_to_c(arg1));
}
inline void TargetTracker::unloadTarget(std::shared_ptr<Target> arg0, std::function<void(std::shared_ptr<Target>, bool)> arg1)
{
    easyar_TargetTracker_unloadTarget(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), FunctorOfVoidFromPointerOfTargetAndBool_to_c(arg1));
}
inline bool TargetTracker::loadTargetBlocked(std::shared_ptr<Target> arg0)
{
    auto _return_value_ = easyar_TargetTracker_loadTargetBlocked(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline bool TargetTracker::unloadTargetBlocked(std::shared_ptr<Target> arg0)
{
    auto _return_value_ = easyar_TargetTracker_unloadTargetBlocked(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline std::vector<std::shared_ptr<Target>> TargetTracker::targets()
{
    easyar_ListOfPointerOfTarget * _return_value_;
    easyar_TargetTracker_targets(cdata_.get(), &_return_value_);
    return std_vector_from_easyar_ListOfPointerOfTarget(std::shared_ptr<easyar_ListOfPointerOfTarget>(_return_value_, [](easyar_ListOfPointerOfTarget * ptr) { easyar_ListOfPointerOfTarget__dtor(ptr); }));
}
inline bool TargetTracker::setSimultaneousNum(int arg0)
{
    auto _return_value_ = easyar_TargetTracker_setSimultaneousNum(cdata_.get(), arg0);
    return _return_value_;
}
inline int TargetTracker::simultaneousNum()
{
    auto _return_value_ = easyar_TargetTracker_simultaneousNum(cdata_.get());
    return _return_value_;
}
inline bool TargetTracker::attachStreamer(std::shared_ptr<FrameStreamer> arg0)
{
    auto _return_value_ = easyar_TargetTracker_attachStreamer(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline bool TargetTracker::start()
{
    auto _return_value_ = easyar_TargetTracker_start(cdata_.get());
    return _return_value_;
}
inline bool TargetTracker::stop()
{
    auto _return_value_ = easyar_TargetTracker_stop(cdata_.get());
    return _return_value_;
}
inline std::shared_ptr<TargetTracker> TargetTracker::tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_TargetTracker * cdata;
    easyar_tryCastFrameFilterToTargetTracker(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<TargetTracker>(std::shared_ptr<easyar_TargetTracker>(cdata, [](easyar_TargetTracker * ptr) { easyar_TargetTracker__dtor(ptr); }));
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPOINTEROFTARGETANDBOOL__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMPOINTEROFTARGETANDBOOL__
static void FunctorOfVoidFromPointerOfTargetAndBool_func(void * _state, easyar_Target * arg0, bool arg1)
{
    easyar_Target__retain(arg0, &arg0);
    std::shared_ptr<Target> cpparg0 = (arg0 == nullptr ? nullptr : std::make_shared<Target>(std::shared_ptr<easyar_Target>(arg0, [](easyar_Target * ptr) { easyar_Target__dtor(ptr); })));
    bool cpparg1 = arg1;
    auto f = reinterpret_cast<std::function<void(std::shared_ptr<Target>, bool)> *>(_state);
    (*f)(cpparg0, cpparg1);
}
static void FunctorOfVoidFromPointerOfTargetAndBool_destroy(void * _state)
{
    auto f = reinterpret_cast<std::function<void(std::shared_ptr<Target>, bool)> *>(_state);
    delete f;
}
static inline easyar_FunctorOfVoidFromPointerOfTargetAndBool FunctorOfVoidFromPointerOfTargetAndBool_to_c(std::function<void(std::shared_ptr<Target>, bool)> f)
{
    if (f == nullptr) { return easyar_FunctorOfVoidFromPointerOfTargetAndBool{nullptr, nullptr, nullptr}; }
    return easyar_FunctorOfVoidFromPointerOfTargetAndBool{new std::function<void(std::shared_ptr<Target>, bool)>(f), FunctorOfVoidFromPointerOfTargetAndBool_func, FunctorOfVoidFromPointerOfTargetAndBool_destroy};
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFTARGET__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFTARGET__
static inline std::shared_ptr<easyar_ListOfPointerOfTarget> std_vector_to_easyar_ListOfPointerOfTarget(std::vector<std::shared_ptr<Target>> l)
{
    std::vector<easyar_Target *> values;
    values.reserve(l.size());
    for (auto v : l) {
        auto cv = (v == nullptr ? nullptr : v->get_cdata().get());
        easyar_Target__retain(cv, &cv);
        values.push_back(cv);
    }
    easyar_ListOfPointerOfTarget * ptr;
    easyar_ListOfPointerOfTarget__ctor(values.data(), values.data() + values.size(), &ptr);
    return std::shared_ptr<easyar_ListOfPointerOfTarget>(ptr, [](easyar_ListOfPointerOfTarget * ptr) { easyar_ListOfPointerOfTarget__dtor(ptr); });
}
static inline std::vector<std::shared_ptr<Target>> std_vector_from_easyar_ListOfPointerOfTarget(std::shared_ptr<easyar_ListOfPointerOfTarget> pl)
{
    auto size = easyar_ListOfPointerOfTarget_size(pl.get());
    std::vector<std::shared_ptr<Target>> values;
    values.reserve(size);
    for (int k = 0; k < size; k += 1) {
        auto v = easyar_ListOfPointerOfTarget_at(pl.get(), k);
        easyar_Target__retain(v, &v);
        values.push_back((v == nullptr ? nullptr : std::make_shared<Target>(std::shared_ptr<easyar_Target>(v, [](easyar_Target * ptr) { easyar_Target__dtor(ptr); }))));
    }
    return values;
}
#endif

}

#endif
