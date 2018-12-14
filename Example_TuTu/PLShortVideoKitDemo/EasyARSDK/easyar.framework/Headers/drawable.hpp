//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_DRAWABLE_HPP__
#define __EASYAR_DRAWABLE_HPP__

#include "easyar/types.hpp"

namespace easyar {

class Drawable
{
protected:
    std::shared_ptr<easyar_Drawable> cdata_;
    void init_cdata(std::shared_ptr<easyar_Drawable> cdata);
    Drawable & operator=(const Drawable & data) = delete;
public:
    Drawable(std::shared_ptr<easyar_Drawable> cdata);
    virtual ~Drawable();

    std::shared_ptr<easyar_Drawable> get_cdata();

};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_DRAWABLE_HPP__
#define __IMPLEMENTATION_EASYAR_DRAWABLE_HPP__

#include "easyar/drawable.h"

namespace easyar {

inline Drawable::Drawable(std::shared_ptr<easyar_Drawable> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline Drawable::~Drawable()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_Drawable> Drawable::get_cdata()
{
    return cdata_;
}
inline void Drawable::init_cdata(std::shared_ptr<easyar_Drawable> cdata)
{
    cdata_ = cdata;
}

}

#endif
