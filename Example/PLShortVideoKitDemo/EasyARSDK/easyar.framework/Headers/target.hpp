//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_TARGET_HPP__
#define __EASYAR_TARGET_HPP__

#include "easyar/types.hpp"

namespace easyar {

class Target
{
protected:
    std::shared_ptr<easyar_Target> cdata_;
    void init_cdata(std::shared_ptr<easyar_Target> cdata);
    Target & operator=(const Target & data) = delete;
public:
    Target(std::shared_ptr<easyar_Target> cdata);
    virtual ~Target();

    std::shared_ptr<easyar_Target> get_cdata();

    int runtimeID();
    std::string uid();
    std::string name();
    std::string meta();
    void setMeta(std::string data);
};

class TargetInstance
{
protected:
    std::shared_ptr<easyar_TargetInstance> cdata_;
    void init_cdata(std::shared_ptr<easyar_TargetInstance> cdata);
    TargetInstance & operator=(const TargetInstance & data) = delete;
public:
    TargetInstance(std::shared_ptr<easyar_TargetInstance> cdata);
    virtual ~TargetInstance();

    std::shared_ptr<easyar_TargetInstance> get_cdata();

    TargetInstance();
    TargetStatus status();
    std::shared_ptr<Target> target();
    Matrix34F pose();
    Matrix44F poseGL();
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_TARGET_HPP__
#define __IMPLEMENTATION_EASYAR_TARGET_HPP__

#include "easyar/target.h"
#include "easyar/matrix.hpp"

namespace easyar {

inline Target::Target(std::shared_ptr<easyar_Target> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline Target::~Target()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_Target> Target::get_cdata()
{
    return cdata_;
}
inline void Target::init_cdata(std::shared_ptr<easyar_Target> cdata)
{
    cdata_ = cdata;
}
inline int Target::runtimeID()
{
    auto _return_value_ = easyar_Target_runtimeID(cdata_.get());
    return _return_value_;
}
inline std::string Target::uid()
{
    easyar_String * _return_value_;
    easyar_Target_uid(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::string Target::name()
{
    easyar_String * _return_value_;
    easyar_Target_name(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::string Target::meta()
{
    easyar_String * _return_value_;
    easyar_Target_meta(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline void Target::setMeta(std::string arg0)
{
    easyar_Target_setMeta(cdata_.get(), std_string_to_easyar_String(arg0).get());
}

inline TargetInstance::TargetInstance(std::shared_ptr<easyar_TargetInstance> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline TargetInstance::~TargetInstance()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_TargetInstance> TargetInstance::get_cdata()
{
    return cdata_;
}
inline void TargetInstance::init_cdata(std::shared_ptr<easyar_TargetInstance> cdata)
{
    cdata_ = cdata;
}
inline TargetInstance::TargetInstance()
    :
    cdata_(nullptr)
{
    easyar_TargetInstance * _return_value_;
    easyar_TargetInstance__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_TargetInstance>(_return_value_, [](easyar_TargetInstance * ptr) { easyar_TargetInstance__dtor(ptr); }));
}
inline TargetStatus TargetInstance::status()
{
    auto _return_value_ = easyar_TargetInstance_status(cdata_.get());
    return static_cast<TargetStatus>(_return_value_);
}
inline std::shared_ptr<Target> TargetInstance::target()
{
    easyar_Target * _return_value_;
    easyar_TargetInstance_target(cdata_.get(), &_return_value_);
    return (_return_value_ == nullptr ? nullptr : std::make_shared<Target>(std::shared_ptr<easyar_Target>(_return_value_, [](easyar_Target * ptr) { easyar_Target__dtor(ptr); })));
}
inline Matrix34F TargetInstance::pose()
{
    auto _return_value_ = easyar_TargetInstance_pose(cdata_.get());
    return Matrix34F{{{_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11]}}};
}
inline Matrix44F TargetInstance::poseGL()
{
    auto _return_value_ = easyar_TargetInstance_poseGL(cdata_.get());
    return Matrix44F{{{_return_value_.data[0], _return_value_.data[1], _return_value_.data[2], _return_value_.data[3], _return_value_.data[4], _return_value_.data[5], _return_value_.data[6], _return_value_.data[7], _return_value_.data[8], _return_value_.data[9], _return_value_.data[10], _return_value_.data[11], _return_value_.data[12], _return_value_.data[13], _return_value_.data[14], _return_value_.data[15]}}};
}

}

#endif
