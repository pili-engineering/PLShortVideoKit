//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_ARSCENE_HPP__
#define __EASYAR_ARSCENE_HPP__

#include "easyar/types.hpp"
#include "easyar/target.hpp"

namespace easyar {

class ARScene : public Target
{
protected:
    std::shared_ptr<easyar_ARScene> cdata_;
    void init_cdata(std::shared_ptr<easyar_ARScene> cdata);
    ARScene & operator=(const ARScene & data) = delete;
public:
    ARScene(std::shared_ptr<easyar_ARScene> cdata);
    virtual ~ARScene();

    std::shared_ptr<easyar_ARScene> get_cdata();

    ARScene();
    int runtimeID();
    std::string uid();
    std::string name();
    std::string meta();
    void setMeta(std::string data);
    static std::shared_ptr<ARScene> tryCastFromTarget(std::shared_ptr<Target> v);
};

}

namespace std {

template<>
inline shared_ptr<easyar::ARScene> dynamic_pointer_cast<easyar::ARScene, easyar::Target>(const shared_ptr<easyar::Target> & r) noexcept
{
    return easyar::ARScene::tryCastFromTarget(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_ARSCENE_HPP__
#define __IMPLEMENTATION_EASYAR_ARSCENE_HPP__

#include "easyar/arscene.h"
#include "easyar/target.hpp"

namespace easyar {

inline ARScene::ARScene(std::shared_ptr<easyar_ARScene> cdata)
    :
    Target(std::shared_ptr<easyar_Target>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline ARScene::~ARScene()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_ARScene> ARScene::get_cdata()
{
    return cdata_;
}
inline void ARScene::init_cdata(std::shared_ptr<easyar_ARScene> cdata)
{
    cdata_ = cdata;
    {
        easyar_Target * ptr = nullptr;
        easyar_castARSceneToTarget(cdata_.get(), &ptr);
        Target::init_cdata(std::shared_ptr<easyar_Target>(ptr, [](easyar_Target * ptr) { easyar_Target__dtor(ptr); }));
    }
}
inline ARScene::ARScene()
    :
    Target(std::shared_ptr<easyar_Target>(nullptr)),
    cdata_(nullptr)
{
    easyar_ARScene * _return_value_;
    easyar_ARScene__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_ARScene>(_return_value_, [](easyar_ARScene * ptr) { easyar_ARScene__dtor(ptr); }));
}
inline int ARScene::runtimeID()
{
    auto _return_value_ = easyar_ARScene_runtimeID(cdata_.get());
    return _return_value_;
}
inline std::string ARScene::uid()
{
    easyar_String * _return_value_;
    easyar_ARScene_uid(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::string ARScene::name()
{
    easyar_String * _return_value_;
    easyar_ARScene_name(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::string ARScene::meta()
{
    easyar_String * _return_value_;
    easyar_ARScene_meta(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline void ARScene::setMeta(std::string arg0)
{
    easyar_ARScene_setMeta(cdata_.get(), std_string_to_easyar_String(arg0).get());
}
inline std::shared_ptr<ARScene> ARScene::tryCastFromTarget(std::shared_ptr<Target> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_ARScene * cdata;
    easyar_tryCastTargetToARScene(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<ARScene>(std::shared_ptr<easyar_ARScene>(cdata, [](easyar_ARScene * ptr) { easyar_ARScene__dtor(ptr); }));
}

}

#endif
