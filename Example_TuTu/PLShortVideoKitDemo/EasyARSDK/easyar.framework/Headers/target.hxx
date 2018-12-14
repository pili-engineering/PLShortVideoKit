//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_TARGET_HXX__
#define __EASYAR_TARGET_HXX__

#include "easyar/types.hxx"

namespace easyar {

class Target
{
protected:
    easyar_Target * cdata_ ;
    void init_cdata(easyar_Target * cdata);
    virtual Target & operator=(const Target & data) { return *this; } //deleted
public:
    Target(easyar_Target * cdata);
    virtual ~Target();

    Target(const Target & data);
    const easyar_Target * get_cdata() const;
    easyar_Target * get_cdata();

    int runtimeID();
    void uid(/* OUT */ String * * Return);
    void name(/* OUT */ String * * Return);
    void meta(/* OUT */ String * * Return);
    void setMeta(String * data);
};

class TargetInstance
{
protected:
    easyar_TargetInstance * cdata_ ;
    void init_cdata(easyar_TargetInstance * cdata);
    virtual TargetInstance & operator=(const TargetInstance & data) { return *this; } //deleted
public:
    TargetInstance(easyar_TargetInstance * cdata);
    virtual ~TargetInstance();

    TargetInstance(const TargetInstance & data);
    const easyar_TargetInstance * get_cdata() const;
    easyar_TargetInstance * get_cdata();

    TargetInstance();
    TargetStatus status();
    void target(/* OUT */ Target * * Return);
    Matrix34F pose();
    Matrix44F poseGL();
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_TARGET_HXX__
#define __IMPLEMENTATION_EASYAR_TARGET_HXX__

#include "easyar/target.h"
#include "easyar/matrix.hxx"

namespace easyar {

inline Target::Target(easyar_Target * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline Target::~Target()
{
    if (cdata_) {
        easyar_Target__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline Target::Target(const Target & data)
    :
    cdata_(NULL)
{
    easyar_Target * cdata = NULL;
    easyar_Target__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_Target * Target::get_cdata() const
{
    return cdata_;
}
inline easyar_Target * Target::get_cdata()
{
    return cdata_;
}
inline void Target::init_cdata(easyar_Target * cdata)
{
    cdata_ = cdata;
}
inline int Target::runtimeID()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_Target_runtimeID(cdata_);
    return _return_value_;
}
inline void Target::uid(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_Target_uid(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void Target::name(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_Target_name(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void Target::meta(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_Target_meta(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void Target::setMeta(String * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Target_setMeta(cdata_, arg0->get_cdata());
}

inline TargetInstance::TargetInstance(easyar_TargetInstance * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline TargetInstance::~TargetInstance()
{
    if (cdata_) {
        easyar_TargetInstance__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline TargetInstance::TargetInstance(const TargetInstance & data)
    :
    cdata_(NULL)
{
    easyar_TargetInstance * cdata = NULL;
    easyar_TargetInstance__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_TargetInstance * TargetInstance::get_cdata() const
{
    return cdata_;
}
inline easyar_TargetInstance * TargetInstance::get_cdata()
{
    return cdata_;
}
inline void TargetInstance::init_cdata(easyar_TargetInstance * cdata)
{
    cdata_ = cdata;
}
inline TargetInstance::TargetInstance()
    :
    cdata_(NULL)
{
    easyar_TargetInstance * _return_value_ = NULL;
    easyar_TargetInstance__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline TargetStatus TargetInstance::status()
{
    if (cdata_ == NULL) {
        return TargetStatus();
    }
    easyar_TargetStatus _return_value_ = easyar_TargetInstance_status(cdata_);
    return static_cast<TargetStatus>(_return_value_);
}
inline void TargetInstance::target(/* OUT */ Target * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_Target * _return_value_ = NULL;
    easyar_TargetInstance_target(cdata_, &_return_value_);
    *Return = (_return_value_ == NULL ? NULL : new Target(_return_value_));
}
inline Matrix34F TargetInstance::pose()
{
    if (cdata_ == NULL) {
        return Matrix34F();
    }
    easyar_Matrix34F _return_value_ = easyar_TargetInstance_pose(cdata_);
    return Matrix34F(_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11]);
}
inline Matrix44F TargetInstance::poseGL()
{
    if (cdata_ == NULL) {
        return Matrix44F();
    }
    easyar_Matrix44F _return_value_ = easyar_TargetInstance_poseGL(cdata_);
    return Matrix44F(_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11], _return_value_.data[12], _return_value_.data[13], _return_value_.data[14], _return_value_.data[15]);
}

}

#endif
