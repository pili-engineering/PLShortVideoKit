//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_RENDERER_HPP__
#define __EASYAR_RENDERER_HPP__

#include "easyar/types.hpp"

namespace easyar {

class Renderer
{
protected:
    std::shared_ptr<easyar_Renderer> cdata_;
    void init_cdata(std::shared_ptr<easyar_Renderer> cdata);
    Renderer & operator=(const Renderer & data) = delete;
public:
    Renderer(std::shared_ptr<easyar_Renderer> cdata);
    virtual ~Renderer();

    std::shared_ptr<easyar_Renderer> get_cdata();

    Renderer();
    void chooseAPI(RendererAPI api);
    void setDevice(void * device);
    bool render(std::shared_ptr<Drawable> frame, Vec4I viewport);
    bool renderToTexture(std::shared_ptr<Drawable> frame, void * texture);
    bool renderErrorMessage(Vec4I viewport);
    bool renderErrorMessageToTexture(void * texture);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_RENDERER_HPP__
#define __IMPLEMENTATION_EASYAR_RENDERER_HPP__

#include "easyar/renderer.h"
#include "easyar/drawable.hpp"
#include "easyar/vector.hpp"

namespace easyar {

inline Renderer::Renderer(std::shared_ptr<easyar_Renderer> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline Renderer::~Renderer()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_Renderer> Renderer::get_cdata()
{
    return cdata_;
}
inline void Renderer::init_cdata(std::shared_ptr<easyar_Renderer> cdata)
{
    cdata_ = cdata;
}
inline Renderer::Renderer()
    :
    cdata_(nullptr)
{
    easyar_Renderer * _return_value_;
    easyar_Renderer__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_Renderer>(_return_value_, [](easyar_Renderer * ptr) { easyar_Renderer__dtor(ptr); }));
}
inline void Renderer::chooseAPI(RendererAPI arg0)
{
    easyar_Renderer_chooseAPI(cdata_.get(), static_cast<easyar_RendererAPI>(arg0));
}
inline void Renderer::setDevice(void * arg0)
{
    easyar_Renderer_setDevice(cdata_.get(), arg0);
}
inline bool Renderer::render(std::shared_ptr<Drawable> arg0, Vec4I arg1)
{
    auto _return_value_ = easyar_Renderer_render(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), easyar_Vec4I{{arg1.data[0], arg1.data[1], arg1.data[2], arg1.data[3]}});
    return _return_value_;
}
inline bool Renderer::renderToTexture(std::shared_ptr<Drawable> arg0, void * arg1)
{
    auto _return_value_ = easyar_Renderer_renderToTexture(cdata_.get(), (arg0 == nullptr ? nullptr : arg0->get_cdata().get()), arg1);
    return _return_value_;
}
inline bool Renderer::renderErrorMessage(Vec4I arg0)
{
    auto _return_value_ = easyar_Renderer_renderErrorMessage(cdata_.get(), easyar_Vec4I{{arg0.data[0], arg0.data[1], arg0.data[2], arg0.data[3]}});
    return _return_value_;
}
inline bool Renderer::renderErrorMessageToTexture(void * arg0)
{
    auto _return_value_ = easyar_Renderer_renderErrorMessageToTexture(cdata_.get(), arg0);
    return _return_value_;
}

}

#endif
