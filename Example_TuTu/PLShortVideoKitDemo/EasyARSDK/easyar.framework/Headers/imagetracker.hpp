//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_IMAGETRACKER_HPP__
#define __EASYAR_IMAGETRACKER_HPP__

#include "easyar/types.hpp"
#include "easyar/targettracker.hpp"

namespace easyar {

class ImageTracker : public TargetTracker
{
protected:
    std::shared_ptr<easyar_ImageTracker> cdata_;
    void init_cdata(std::shared_ptr<easyar_ImageTracker> cdata);
    ImageTracker & operator=(const ImageTracker & data) = delete;
public:
    ImageTracker(std::shared_ptr<easyar_ImageTracker> cdata);
    virtual ~ImageTracker();

    std::shared_ptr<easyar_ImageTracker> get_cdata();

    ImageTracker();
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
    static std::shared_ptr<ImageTracker> tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v);
    static std::shared_ptr<ImageTracker> tryCastFromTargetTracker(std::shared_ptr<TargetTracker> v);
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
inline shared_ptr<easyar::ImageTracker> dynamic_pointer_cast<easyar::ImageTracker, easyar::FrameFilter>(const shared_ptr<easyar::FrameFilter> & r) noexcept
{
    return easyar::ImageTracker::tryCastFromFrameFilter(r);
}
template<>
inline shared_ptr<easyar::ImageTracker> dynamic_pointer_cast<easyar::ImageTracker, easyar::TargetTracker>(const shared_ptr<easyar::TargetTracker> & r) noexcept
{
    return easyar::ImageTracker::tryCastFromTargetTracker(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_IMAGETRACKER_HPP__
#define __IMPLEMENTATION_EASYAR_IMAGETRACKER_HPP__

#include "easyar/imagetracker.h"
#include "easyar/targettracker.hpp"
#include "easyar/target.hpp"
#include "easyar/framestreamer.hpp"

namespace easyar {

inline ImageTracker::ImageTracker(std::shared_ptr<easyar_ImageTracker> cdata)
    :
    TargetTracker(std::shared_ptr<easyar_TargetTracker>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline ImageTracker::~ImageTracker()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_ImageTracker> ImageTracker::get_cdata()
{
    return cdata_;
}
inline void ImageTracker::init_cdata(std::shared_ptr<easyar_ImageTracker> cdata)
{
    cdata_ = cdata;
    {
        easyar_TargetTracker * ptr = nullptr;
        easyar_castImageTrackerToTargetTracker(cdata_.get(), &ptr);
        TargetTracker::init_cdata(std::shared_ptr<easyar_TargetTracker>(ptr, [](easyar_TargetTracker * ptr) { easyar_TargetTracker__dtor(ptr); }));
    }
}
inline ImageTracker::ImageTracker()
    :
    TargetTracker(std::shared_ptr<easyar_TargetTracker>(nullptr)),
    cdata_(nullptr)
{
    easyar_ImageTracker * _return_value_;
    easyar_ImageTracker__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_ImageTracker>(_return_value_, [](easyar_ImageTracker * ptr) { easyar_ImageTracker__dtor(ptr); }));
}
inline void ImageTracker::loadTarget(std::shared_ptr<Target> arg0, std::function<void(std::shared_ptr<Target>, bool)> arg1)
{
    easyar_ImageTracker_loadTarget(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), FunctorOfVoidFromPointerOfTargetAndBool_to_c(arg1));
}
inline void ImageTracker::unloadTarget(std::shared_ptr<Target> arg0, std::function<void(std::shared_ptr<Target>, bool)> arg1)
{
    easyar_ImageTracker_unloadTarget(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), FunctorOfVoidFromPointerOfTargetAndBool_to_c(arg1));
}
inline bool ImageTracker::loadTargetBlocked(std::shared_ptr<Target> arg0)
{
    auto _return_value_ = easyar_ImageTracker_loadTargetBlocked(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline bool ImageTracker::unloadTargetBlocked(std::shared_ptr<Target> arg0)
{
    auto _return_value_ = easyar_ImageTracker_unloadTargetBlocked(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline std::vector<std::shared_ptr<Target>> ImageTracker::targets()
{
    easyar_ListOfPointerOfTarget * _return_value_;
    easyar_ImageTracker_targets(cdata_.get(), &_return_value_);
    return std_vector_from_easyar_ListOfPointerOfTarget(std::shared_ptr<easyar_ListOfPointerOfTarget>(_return_value_, [](easyar_ListOfPointerOfTarget * ptr) { easyar_ListOfPointerOfTarget__dtor(ptr); }));
}
inline bool ImageTracker::setSimultaneousNum(int arg0)
{
    auto _return_value_ = easyar_ImageTracker_setSimultaneousNum(cdata_.get(), arg0);
    return _return_value_;
}
inline int ImageTracker::simultaneousNum()
{
    auto _return_value_ = easyar_ImageTracker_simultaneousNum(cdata_.get());
    return _return_value_;
}
inline bool ImageTracker::attachStreamer(std::shared_ptr<FrameStreamer> arg0)
{
    auto _return_value_ = easyar_ImageTracker_attachStreamer(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline bool ImageTracker::start()
{
    auto _return_value_ = easyar_ImageTracker_start(cdata_.get());
    return _return_value_;
}
inline bool ImageTracker::stop()
{
    auto _return_value_ = easyar_ImageTracker_stop(cdata_.get());
    return _return_value_;
}
inline std::shared_ptr<ImageTracker> ImageTracker::tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_ImageTracker * cdata;
    easyar_tryCastFrameFilterToImageTracker(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<ImageTracker>(std::shared_ptr<easyar_ImageTracker>(cdata, [](easyar_ImageTracker * ptr) { easyar_ImageTracker__dtor(ptr); }));
}
inline std::shared_ptr<ImageTracker> ImageTracker::tryCastFromTargetTracker(std::shared_ptr<TargetTracker> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_ImageTracker * cdata;
    easyar_tryCastTargetTrackerToImageTracker(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<ImageTracker>(std::shared_ptr<easyar_ImageTracker>(cdata, [](easyar_ImageTracker * ptr) { easyar_ImageTracker__dtor(ptr); }));
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
