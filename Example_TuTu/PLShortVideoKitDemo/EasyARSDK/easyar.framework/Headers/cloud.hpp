//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_CLOUD_HPP__
#define __EASYAR_CLOUD_HPP__

#include "easyar/types.hpp"
#include "easyar/framefilter.hpp"

namespace easyar {

class CloudRecognizer : public FrameFilter
{
protected:
    std::shared_ptr<easyar_CloudRecognizer> cdata_;
    void init_cdata(std::shared_ptr<easyar_CloudRecognizer> cdata);
    CloudRecognizer & operator=(const CloudRecognizer & data) = delete;
public:
    CloudRecognizer(std::shared_ptr<easyar_CloudRecognizer> cdata);
    virtual ~CloudRecognizer();

    std::shared_ptr<easyar_CloudRecognizer> get_cdata();

    CloudRecognizer();
    void open(std::string server, std::string appKey, std::string appSecret, std::function<void(CloudStatus)> callback_open, std::function<void(CloudStatus, std::vector<std::shared_ptr<Target>>)> callback_recognize);
    bool close();
    bool attachStreamer(std::shared_ptr<FrameStreamer> obj);
    bool start();
    bool stop();
    static std::shared_ptr<CloudRecognizer> tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v);
};

#ifndef __EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUS__
#define __EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUS__
static void FunctorOfVoidFromCloudStatus_func(void * _state, easyar_CloudStatus);
static void FunctorOfVoidFromCloudStatus_destroy(void * _state);
static inline easyar_FunctorOfVoidFromCloudStatus FunctorOfVoidFromCloudStatus_to_c(std::function<void(CloudStatus)> f);
#endif

#ifndef __EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUSANDLISTOFPOINTEROFTARGET__
#define __EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUSANDLISTOFPOINTEROFTARGET__
static void FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_func(void * _state, easyar_CloudStatus, easyar_ListOfPointerOfTarget *);
static void FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_destroy(void * _state);
static inline easyar_FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_to_c(std::function<void(CloudStatus, std::vector<std::shared_ptr<Target>>)> f);
#endif

#ifndef __EASYAR_LISTOFPOINTEROFTARGET__
#define __EASYAR_LISTOFPOINTEROFTARGET__
static inline std::shared_ptr<easyar_ListOfPointerOfTarget> std_vector_to_easyar_ListOfPointerOfTarget(std::vector<std::shared_ptr<Target>> l);
static inline std::vector<std::shared_ptr<Target>> std_vector_from_easyar_ListOfPointerOfTarget(std::shared_ptr<easyar_ListOfPointerOfTarget> pl);
#endif

}

namespace std {

template<>
inline shared_ptr<easyar::CloudRecognizer> dynamic_pointer_cast<easyar::CloudRecognizer, easyar::FrameFilter>(const shared_ptr<easyar::FrameFilter> & r) noexcept
{
    return easyar::CloudRecognizer::tryCastFromFrameFilter(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_CLOUD_HPP__
#define __IMPLEMENTATION_EASYAR_CLOUD_HPP__

#include "easyar/cloud.h"
#include "easyar/framefilter.hpp"
#include "easyar/target.hpp"
#include "easyar/framestreamer.hpp"

namespace easyar {

inline CloudRecognizer::CloudRecognizer(std::shared_ptr<easyar_CloudRecognizer> cdata)
    :
    FrameFilter(std::shared_ptr<easyar_FrameFilter>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline CloudRecognizer::~CloudRecognizer()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_CloudRecognizer> CloudRecognizer::get_cdata()
{
    return cdata_;
}
inline void CloudRecognizer::init_cdata(std::shared_ptr<easyar_CloudRecognizer> cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameFilter * ptr = nullptr;
        easyar_castCloudRecognizerToFrameFilter(cdata_.get(), &ptr);
        FrameFilter::init_cdata(std::shared_ptr<easyar_FrameFilter>(ptr, [](easyar_FrameFilter * ptr) { easyar_FrameFilter__dtor(ptr); }));
    }
}
inline CloudRecognizer::CloudRecognizer()
    :
    FrameFilter(std::shared_ptr<easyar_FrameFilter>(nullptr)),
    cdata_(nullptr)
{
    easyar_CloudRecognizer * _return_value_;
    easyar_CloudRecognizer__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_CloudRecognizer>(_return_value_, [](easyar_CloudRecognizer * ptr) { easyar_CloudRecognizer__dtor(ptr); }));
}
inline void CloudRecognizer::open(std::string arg0, std::string arg1, std::string arg2, std::function<void(CloudStatus)> arg3, std::function<void(CloudStatus, std::vector<std::shared_ptr<Target>>)> arg4)
{
    easyar_CloudRecognizer_open(cdata_.get(), std_string_to_easyar_String(arg0).get(), std_string_to_easyar_String(arg1).get(), std_string_to_easyar_String(arg2).get(), FunctorOfVoidFromCloudStatus_to_c(arg3), FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_to_c(arg4));
}
inline bool CloudRecognizer::close()
{
    auto _return_value_ = easyar_CloudRecognizer_close(cdata_.get());
    return _return_value_;
}
inline bool CloudRecognizer::attachStreamer(std::shared_ptr<FrameStreamer> arg0)
{
    auto _return_value_ = easyar_CloudRecognizer_attachStreamer(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()));
    return _return_value_;
}
inline bool CloudRecognizer::start()
{
    auto _return_value_ = easyar_CloudRecognizer_start(cdata_.get());
    return _return_value_;
}
inline bool CloudRecognizer::stop()
{
    auto _return_value_ = easyar_CloudRecognizer_stop(cdata_.get());
    return _return_value_;
}
inline std::shared_ptr<CloudRecognizer> CloudRecognizer::tryCastFromFrameFilter(std::shared_ptr<FrameFilter> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_CloudRecognizer * cdata;
    easyar_tryCastFrameFilterToCloudRecognizer(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<CloudRecognizer>(std::shared_ptr<easyar_CloudRecognizer>(cdata, [](easyar_CloudRecognizer * ptr) { easyar_CloudRecognizer__dtor(ptr); }));
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUS__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUS__
static void FunctorOfVoidFromCloudStatus_func(void * _state, easyar_CloudStatus arg0)
{
    CloudStatus cpparg0 = static_cast<CloudStatus>(arg0);
    auto f = reinterpret_cast<std::function<void(CloudStatus)> *>(_state);
    (*f)(cpparg0);
}
static void FunctorOfVoidFromCloudStatus_destroy(void * _state)
{
    auto f = reinterpret_cast<std::function<void(CloudStatus)> *>(_state);
    delete f;
}
static inline easyar_FunctorOfVoidFromCloudStatus FunctorOfVoidFromCloudStatus_to_c(std::function<void(CloudStatus)> f)
{
    if (f == nullptr) { return easyar_FunctorOfVoidFromCloudStatus{nullptr, nullptr, nullptr}; }
    return easyar_FunctorOfVoidFromCloudStatus{new std::function<void(CloudStatus)>(f), FunctorOfVoidFromCloudStatus_func, FunctorOfVoidFromCloudStatus_destroy};
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUSANDLISTOFPOINTEROFTARGET__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUSANDLISTOFPOINTEROFTARGET__
static void FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_func(void * _state, easyar_CloudStatus arg0, easyar_ListOfPointerOfTarget * arg1)
{
    CloudStatus cpparg0 = static_cast<CloudStatus>(arg0);
    easyar_ListOfPointerOfTarget_copy(arg1, &arg1);
    std::vector<std::shared_ptr<Target>> cpparg1 = std_vector_from_easyar_ListOfPointerOfTarget(std::shared_ptr<easyar_ListOfPointerOfTarget>(arg1, [](easyar_ListOfPointerOfTarget * ptr) { easyar_ListOfPointerOfTarget__dtor(ptr); }));
    auto f = reinterpret_cast<std::function<void(CloudStatus, std::vector<std::shared_ptr<Target>>)> *>(_state);
    (*f)(cpparg0, cpparg1);
}
static void FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_destroy(void * _state)
{
    auto f = reinterpret_cast<std::function<void(CloudStatus, std::vector<std::shared_ptr<Target>>)> *>(_state);
    delete f;
}
static inline easyar_FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_to_c(std::function<void(CloudStatus, std::vector<std::shared_ptr<Target>>)> f)
{
    if (f == nullptr) { return easyar_FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget{nullptr, nullptr, nullptr}; }
    return easyar_FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget{new std::function<void(CloudStatus, std::vector<std::shared_ptr<Target>>)>(f), FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_func, FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_destroy};
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
