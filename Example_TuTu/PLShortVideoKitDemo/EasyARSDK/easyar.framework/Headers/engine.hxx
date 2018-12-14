//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_ENGINE_HXX__
#define __EASYAR_ENGINE_HXX__

#include "easyar/types.hxx"

namespace easyar {

class Engine
{
public:
    static bool initialize(String * key);
    static void onPause();
    static void onResume();
    static void setRotation(int rotation);
    static void versionString(/* OUT */ String * * Return);
    static void name(/* OUT */ String * * Return);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_ENGINE_HXX__
#define __IMPLEMENTATION_EASYAR_ENGINE_HXX__

#include "easyar/engine.h"

namespace easyar {

inline bool Engine::initialize(String * arg0)
{
    bool _return_value_ = easyar_Engine_initialize(arg0->get_cdata());
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
inline void Engine::versionString(/* OUT */ String * * Return)
{
    easyar_String * _return_value_ = NULL;
    easyar_Engine_versionString(&_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void Engine::name(/* OUT */ String * * Return)
{
    easyar_String * _return_value_ = NULL;
    easyar_Engine_name(&_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}

}

#endif
