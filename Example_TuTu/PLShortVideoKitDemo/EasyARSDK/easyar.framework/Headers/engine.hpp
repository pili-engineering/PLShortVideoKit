//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_ENGINE_HPP__
#define __EASYAR_ENGINE_HPP__

#include "easyar/types.hpp"

namespace easyar {

class Engine
{
public:
    static bool initialize(std::string key);
    static void onPause();
    static void onResume();
    static void setRotation(int rotation);
    static std::string versionString();
    static std::string name();
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_ENGINE_HPP__
#define __IMPLEMENTATION_EASYAR_ENGINE_HPP__

#include "easyar/engine.h"

namespace easyar {

inline bool Engine::initialize(std::string arg0)
{
    auto _return_value_ = easyar_Engine_initialize(std_string_to_easyar_String(arg0).get());
    return _return_value_;
}
inline void Engine::onPause()
{
    easyar_Engine_onPause();
}
inline void Engine::onResume()
{
    easyar_Engine_onResume();
}
inline void Engine::setRotation(int arg0)
{
    easyar_Engine_setRotation(arg0);
}
inline std::string Engine::versionString()
{
    easyar_String * _return_value_;
    easyar_Engine_versionString(&_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::string Engine::name()
{
    easyar_String * _return_value_;
    easyar_Engine_name(&_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}

}

#endif
