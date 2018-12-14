//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_OBJECTTRACKER_HPP__
#define __EASYAR_OBJECTTRACKER_HPP__

#include "easyar/types.hpp"
#include "easyar/targettracker.hpp"

namespace easyar {

class ObjectTracker : public TargetTracker
{
protected:
    std::shared_ptr<easyar_ObjectTracker> cdata_;
    void init_cdata(std::shared_ptr<easyar_ObjectTracker> cdata);
    ObjectTracker & operator=(const ObjectTracker & data) = delete;
public:
    ObjectTracker(std::shared_ptr<easyar_ObjectTracker> cdata);
    virtual ~ObjectTracker();

    std::shared_ptr<easyar_ObjectTracker> get_cdata();

    ObjectTracker();
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
    static std::shared_ptr<ObjectTracker> tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v);
    static std::shared_ptr<ObjectTracker> tryCastFromTargetTracker(std::shared_ptr<TargetTracker> v);
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
inline shared_ptr<easyar::ObjectTracker> dynamic_pointer_cast<easyar::ObjectTracker, easyar::FrameFilter>(const shared_ptr<easyar::FrameFilter> & r) noexcept
{
    return easyar::ObjectTracker::tryCastFromFrameFilter(r);
}
template<>
inline shared_ptr<easyar::ObjectTracker> dynamic_pointer_cast<easyar::ObjectTracker, easyar::TargetTracker>(const shared_ptr<easyar::TargetTracker> & r) noexcept
{
    return easyar::ObjectTracker::tryCastFromTargetTracker(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_OBJECTTRACKER_HPP__
#define __IMPLEMENTATION_EASYAR_OBJECTTRACKER_HPP__

#include "easyar/objecttracker.h"
#include "easyar/targettracker.hpp"
#include "easyar/target.hpp"
#include "easyar/framestreamer.hpp"

namespace easyar {

inline ObjectTracker::ObjectTracker(std::shared_ptr<easyar_ObjectTracker> cdata)
    :
    TargetTracker(std::shared_ptr<easyar_TargetTracker>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline ObjectTracker::~ObjectTracker()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_ObjectTracker> ObjectTracker::get_cdata()
{
    return cdata_;
}
inline void ObjectTracker::init_cdata(std::shared_ptr<easyar_ObjectTracker> cdata)
{
    cdata_ = cdata;
    {
        easyar_TargetTracker * ptr = nullptr;
        easyar_castObjectTrackerToTargetTracker(cdata_.get(), &ptr);
        TargetTracker::init_cdata(std::shared_ptr<easyar_TargetTracker>(ptr, [](easyar_TargetTracker * ptr) { easyar_TargetTracker__dtor(ptr); }));
    }
}
inline ObjectTracker::ObjectTracker()
    :
    TargetTracker(std::shared_ptr<easyar_TargetTracker>(nullptr)),
    cdata_(nullptr)
{
    easyar_ObjectTracker * _return_value_;
    easyar_ObjectTracker__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_ObjectTracker>(_return_value_, [](easyar_ObjectTracker * ptr) { easyar_ObjectTracker__dtor(ptr); }));
}
inline void ObjectTracker::loadTarget(std::shared_ptr<Target> arg0, std::function<void(std::shared_ptr<Target>, bool)> arg1)
{
    easyar_ObjectTracker_loadTarget(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), FunctorOfVoidFromPointerOfTargetAndBool_to_c(arg1));
}
inline void ObjectTracker::unloadTarget(std::shared_ptr<Target> arg0, std::function<void(std::shared_ptr<Target>, bool)> arg1)
{
    easyar_ObjectTracker_unloadTarget(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), FunctorOfVoidFromPointerOfTargetAndBool_to_c(arg1));
}
inline bool ObjectTracker::loadTargetBlocked(std::shared_ptr<Target> arg0)
{
    auto _return_value_ = easyar_ObjectTracker_loadTargetBlocked(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline bool ObjectTracker::unloadTargetBlocked(std::shared_ptr<Target> arg0)
{
    auto _return_value_ = easyar_ObjectTracker_unloadTargetBlocked(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline std::vector<std::shared_ptr<Target>> ObjectTracker::targets()
{
    easyar_ListOfPointerOfTarget * _return_value_;
    easyar_ObjectTracker_targets(cdata_.get(), &_return_value_);
    return std_vector_from_easyar_ListOfPointerOfTarget(std::shared_ptr<easyar_ListOfPointerOfTarget>(_return_value_, [](easyar_ListOfPointerOfTarget * ptr) { easyar_ListOfPointerOfTarget__dtor(ptr); }));
}
inline bool ObjectTracker::setSimultaneousNum(int arg0)
{
    auto _return_value_ = easyar_ObjectTracker_setSimultaneousNum(cdata_.get(), arg0);
    return _return_value_;
}
inline int ObjectTracker::simultaneousNum()
{
    auto _return_value_ = easyar_ObjectTracker_simultaneousNum(cdata_.get());
    return _return_value_;
}
inline bool ObjectTracker::attachStreamer(std::shared_ptr<FrameStreamer> arg0)
{
    auto _return_value_ = easyar_ObjectTracker_attachStreamer(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline bool ObjectTracker::start()
{
    auto _return_value_ = easyar_ObjectTracker_start(cdata_.get());
    return _return_value_;
}
inline bool ObjectTracker::stop()
{
    auto _return_value_ = easyar_ObjectTracker_stop(cdata_.get());
    return _return_value_;
}
inline std::shared_ptr<ObjectTracker> ObjectTracker::tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_ObjectTracker * cdata;
    easyar_tryCastFrameFilterToObjectTracker(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<ObjectTracker>(std::shared_ptr<easyar_ObjectTracker>(cdata, [](easyar_ObjectTracker * ptr) { easyar_ObjectTracker__dtor(ptr); }));
}
inline std::shared_ptr<ObjectTracker> ObjectTracker::tryCastFromTargetTracker(std::shared_ptr<TargetTracker> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_ObjectTracker * cdata;
    easyar_tryCastTargetTrackerToObjectTracker(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<ObjectTracker>(std::shared_ptr<easyar_ObjectTracker>(cdata, [](easyar_ObjectTracker * ptr) { easyar_ObjectTracker__dtor(ptr); }));
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
