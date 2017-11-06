//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_CLOUD_HXX__
#define __EASYAR_CLOUD_HXX__

#include "easyar/types.hxx"
#include "easyar/framefilter.hxx"

namespace easyar {

class CloudRecognizer : public FrameFilter
{
protected:
    easyar_CloudRecognizer * cdata_ ;
    void init_cdata(easyar_CloudRecognizer * cdata);
    virtual CloudRecognizer & operator=(const CloudRecognizer & data) { return *this; } //deleted
public:
    CloudRecognizer(easyar_CloudRecognizer * cdata);
    virtual ~CloudRecognizer();

    CloudRecognizer(const CloudRecognizer & data);
    const easyar_CloudRecognizer * get_cdata() const;
    easyar_CloudRecognizer * get_cdata();

    CloudRecognizer();
    void open(String * server, String * appKey, String * appSecret, FunctorOfVoidFromCloudStatus callback_open, FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget callback_recognize);
    bool close();
    bool attachStreamer(FrameStreamer * obj);
    bool start();
    bool stop();
    static void tryCastFromFrameFilter(FrameFilter * v, /* OUT */ CloudRecognizer * * Return);
};

#ifndef __EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUS__
#define __EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUS__
struct FunctorOfVoidFromCloudStatus
{
    void * _state;
    void (* func)(void * _state, CloudStatus);
    void (* destroy)(void * _state);
    FunctorOfVoidFromCloudStatus(void * _state, void (* func)(void * _state, CloudStatus), void (* destroy)(void * _state));
};

static void FunctorOfVoidFromCloudStatus_func(void * _state, easyar_CloudStatus);
static void FunctorOfVoidFromCloudStatus_destroy(void * _state);
static inline easyar_FunctorOfVoidFromCloudStatus FunctorOfVoidFromCloudStatus_to_c(FunctorOfVoidFromCloudStatus f);
#endif

#ifndef __EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUSANDLISTOFPOINTEROFTARGET__
#define __EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUSANDLISTOFPOINTEROFTARGET__
struct FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget
{
    void * _state;
    void (* func)(void * _state, CloudStatus, ListOfPointerOfTarget *);
    void (* destroy)(void * _state);
    FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget(void * _state, void (* func)(void * _state, CloudStatus, ListOfPointerOfTarget *), void (* destroy)(void * _state));
};

static void FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_func(void * _state, easyar_CloudStatus, easyar_ListOfPointerOfTarget *);
static void FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_destroy(void * _state);
static inline easyar_FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_to_c(FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget f);
#endif

#ifndef __EASYAR_LISTOFPOINTEROFTARGET__
#define __EASYAR_LISTOFPOINTEROFTARGET__
class ListOfPointerOfTarget
{
private:
    easyar_ListOfPointerOfTarget * cdata_;
    virtual ListOfPointerOfTarget & operator=(const ListOfPointerOfTarget & data) { return *this; } //deleted
public:
    ListOfPointerOfTarget(easyar_ListOfPointerOfTarget * cdata);
    virtual ~ListOfPointerOfTarget();

    ListOfPointerOfTarget(const ListOfPointerOfTarget & data);
    const easyar_ListOfPointerOfTarget * get_cdata() const;
    easyar_ListOfPointerOfTarget * get_cdata();

    ListOfPointerOfTarget(easyar_Target * * begin, easyar_Target * * end);
    int size() const;
    Target * at(int index) const;
};
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_CLOUD_HXX__
#define __IMPLEMENTATION_EASYAR_CLOUD_HXX__

#include "easyar/cloud.h"
#include "easyar/framefilter.hxx"
#include "easyar/target.hxx"
#include "easyar/framestreamer.hxx"

namespace easyar {

inline CloudRecognizer::CloudRecognizer(easyar_CloudRecognizer * cdata)
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline CloudRecognizer::~CloudRecognizer()
{
    if (cdata_) {
        easyar_CloudRecognizer__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline CloudRecognizer::CloudRecognizer(const CloudRecognizer & data)
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    easyar_CloudRecognizer * cdata = NULL;
    easyar_CloudRecognizer__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_CloudRecognizer * CloudRecognizer::get_cdata() const
{
    return cdata_;
}
inline easyar_CloudRecognizer * CloudRecognizer::get_cdata()
{
    return cdata_;
}
inline void CloudRecognizer::init_cdata(easyar_CloudRecognizer * cdata)
{
    cdata_ = cdata;
    {
        easyar_FrameFilter * cdata_inner = NULL;
        easyar_castCloudRecognizerToFrameFilter(cdata, &cdata_inner);
        FrameFilter::init_cdata(cdata_inner);
    }
}
inline CloudRecognizer::CloudRecognizer()
    :
    FrameFilter(static_cast<easyar_FrameFilter *>(NULL)),
    cdata_(NULL)
{
    easyar_CloudRecognizer * _return_value_ = NULL;
    easyar_CloudRecognizer__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline void CloudRecognizer::open(String * arg0, String * arg1, String * arg2, FunctorOfVoidFromCloudStatus arg3, FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget arg4)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_CloudRecognizer_open(cdata_, arg0->get_cdata(), arg1->get_cdata(), arg2->get_cdata(), FunctorOfVoidFromCloudStatus_to_c(arg3), FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_to_c(arg4));
}
inline bool CloudRecognizer::close()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CloudRecognizer_close(cdata_);
    return _return_value_;
}
inline bool CloudRecognizer::attachStreamer(FrameStreamer * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CloudRecognizer_attachStreamer(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()));
    return _return_value_;
}
inline bool CloudRecognizer::start()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CloudRecognizer_start(cdata_);
    return _return_value_;
}
inline bool CloudRecognizer::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_CloudRecognizer_stop(cdata_);
    return _return_value_;
}
inline void CloudRecognizer::tryCastFromFrameFilter(FrameFilter * v, /* OUT */ CloudRecognizer * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_CloudRecognizer * cdata = NULL;
    easyar_tryCastFrameFilterToCloudRecognizer(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new CloudRecognizer(cdata);
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUS__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUS__
inline FunctorOfVoidFromCloudStatus::FunctorOfVoidFromCloudStatus(void * _state, void (* func)(void * _state, CloudStatus), void (* destroy)(void * _state))
{
    this->_state = _state;
    this->func = func;
    this->destroy = destroy;
}
static void FunctorOfVoidFromCloudStatus_func(void * _state, easyar_CloudStatus arg0)
{
    CloudStatus cpparg0 = static_cast<CloudStatus>(arg0);
    FunctorOfVoidFromCloudStatus * f = reinterpret_cast<FunctorOfVoidFromCloudStatus *>(_state);
    f->func(f->_state, cpparg0);
}
static void FunctorOfVoidFromCloudStatus_destroy(void * _state)
{
    FunctorOfVoidFromCloudStatus * f = reinterpret_cast<FunctorOfVoidFromCloudStatus *>(_state);
    if (f->destroy) {
        f->destroy(f->_state);
    }
    delete f;
}
static inline easyar_FunctorOfVoidFromCloudStatus FunctorOfVoidFromCloudStatus_to_c(FunctorOfVoidFromCloudStatus f)
{
    easyar_FunctorOfVoidFromCloudStatus _return_value_ = {NULL, NULL, NULL};
    if ((f.func == NULL) && (f.destroy == NULL)) { return _return_value_; }
    _return_value_._state = new FunctorOfVoidFromCloudStatus(f._state, f.func, f.destroy);
    _return_value_.func = FunctorOfVoidFromCloudStatus_func;
    _return_value_.destroy = FunctorOfVoidFromCloudStatus_destroy;
    return _return_value_;
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUSANDLISTOFPOINTEROFTARGET__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMCLOUDSTATUSANDLISTOFPOINTEROFTARGET__
inline FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget::FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget(void * _state, void (* func)(void * _state, CloudStatus, ListOfPointerOfTarget *), void (* destroy)(void * _state))
{
    this->_state = _state;
    this->func = func;
    this->destroy = destroy;
}
static void FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_func(void * _state, easyar_CloudStatus arg0, easyar_ListOfPointerOfTarget * arg1)
{
    CloudStatus cpparg0 = static_cast<CloudStatus>(arg0);
    easyar_ListOfPointerOfTarget_copy(arg1, &arg1);
    ListOfPointerOfTarget * cpparg1 = new ListOfPointerOfTarget(arg1);
    FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget * f = reinterpret_cast<FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget *>(_state);
    f->func(f->_state, cpparg0, cpparg1);
    delete cpparg1;
}
static void FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_destroy(void * _state)
{
    FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget * f = reinterpret_cast<FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget *>(_state);
    if (f->destroy) {
        f->destroy(f->_state);
    }
    delete f;
}
static inline easyar_FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_to_c(FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget f)
{
    easyar_FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget _return_value_ = {NULL, NULL, NULL};
    if ((f.func == NULL) && (f.destroy == NULL)) { return _return_value_; }
    _return_value_._state = new FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget(f._state, f.func, f.destroy);
    _return_value_.func = FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_func;
    _return_value_.destroy = FunctorOfVoidFromCloudStatusAndListOfPointerOfTarget_destroy;
    return _return_value_;
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFTARGET__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFTARGET__
inline ListOfPointerOfTarget::ListOfPointerOfTarget(easyar_ListOfPointerOfTarget * cdata)
    : cdata_(cdata)
{
}
inline ListOfPointerOfTarget::~ListOfPointerOfTarget()
{
    if (cdata_) {
        easyar_ListOfPointerOfTarget__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ListOfPointerOfTarget::ListOfPointerOfTarget(const ListOfPointerOfTarget & data)
    : cdata_(static_cast<easyar_ListOfPointerOfTarget *>(NULL))
{
    easyar_ListOfPointerOfTarget_copy(data.cdata_, &cdata_);
}
inline const easyar_ListOfPointerOfTarget * ListOfPointerOfTarget::get_cdata() const
{
    return cdata_;
}
inline easyar_ListOfPointerOfTarget * ListOfPointerOfTarget::get_cdata()
{
    return cdata_;
}

inline ListOfPointerOfTarget::ListOfPointerOfTarget(easyar_Target * * begin, easyar_Target * * end)
    : cdata_(static_cast<easyar_ListOfPointerOfTarget *>(NULL))
{
    easyar_ListOfPointerOfTarget__ctor(begin, end, &cdata_);
}
inline int ListOfPointerOfTarget::size() const
{
    return easyar_ListOfPointerOfTarget_size(cdata_);
}
inline Target * ListOfPointerOfTarget::at(int index) const
{
    easyar_Target * _return_value_ = easyar_ListOfPointerOfTarget_at(cdata_, index);
    easyar_Target__retain(_return_value_, &_return_value_);
    return (_return_value_ == NULL ? NULL : new Target(_return_value_));
}
#endif

}

#endif
