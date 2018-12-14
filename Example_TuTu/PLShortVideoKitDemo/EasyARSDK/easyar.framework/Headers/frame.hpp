//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_FRAME_HPP__
#define __EASYAR_FRAME_HPP__

#include "easyar/types.hpp"
#include "easyar/drawable.hpp"

namespace easyar {

class Frame : public Drawable
{
protected:
    std::shared_ptr<easyar_Frame> cdata_;
    void init_cdata(std::shared_ptr<easyar_Frame> cdata);
    Frame & operator=(const Frame & data) = delete;
public:
    Frame(std::shared_ptr<easyar_Frame> cdata);
    virtual ~Frame();

    std::shared_ptr<easyar_Frame> get_cdata();

    Frame();
    Vec2I size();
    double timestamp();
    int index();
    std::vector<std::shared_ptr<Image>> images();
    std::vector<std::shared_ptr<TargetInstance>> targetInstances();
    std::string text();
    static std::shared_ptr<Frame> tryCastFromDrawable(std::shared_ptr<Drawable> v);
};

#ifndef __EASYAR_LISTOFPOINTEROFIMAGE__
#define __EASYAR_LISTOFPOINTEROFIMAGE__
static inline std::shared_ptr<easyar_ListOfPointerOfImage> std_vector_to_easyar_ListOfPointerOfImage(std::vector<std::shared_ptr<Image>> l);
static inline std::vector<std::shared_ptr<Image>> std_vector_from_easyar_ListOfPointerOfImage(std::shared_ptr<easyar_ListOfPointerOfImage> pl);
#endif

#ifndef __EASYAR_LISTOFPOINTEROFTARGETINSTANCE__
#define __EASYAR_LISTOFPOINTEROFTARGETINSTANCE__
static inline std::shared_ptr<easyar_ListOfPointerOfTargetInstance> std_vector_to_easyar_ListOfPointerOfTargetInstance(std::vector<std::shared_ptr<TargetInstance>> l);
static inline std::vector<std::shared_ptr<TargetInstance>> std_vector_from_easyar_ListOfPointerOfTargetInstance(std::shared_ptr<easyar_ListOfPointerOfTargetInstance> pl);
#endif

}

namespace std {

template<>
inline shared_ptr<easyar::Frame> dynamic_pointer_cast<easyar::Frame, easyar::Drawable>(const shared_ptr<easyar::Drawable> & r) noexcept
{
    return easyar::Frame::tryCastFromDrawable(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_FRAME_HPP__
#define __IMPLEMENTATION_EASYAR_FRAME_HPP__

#include "easyar/frame.h"
#include "easyar/drawable.hpp"
#include "easyar/vector.hpp"
#include "easyar/image.hpp"
#include "easyar/target.hpp"

namespace easyar {

inline Frame::Frame(std::shared_ptr<easyar_Frame> cdata)
    :
    Drawable(std::shared_ptr<easyar_Drawable>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline Frame::~Frame()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_Frame> Frame::get_cdata()
{
    return cdata_;
}
inline void Frame::init_cdata(std::shared_ptr<easyar_Frame> cdata)
{
    cdata_ = cdata;
    {
        easyar_Drawable * ptr = nullptr;
        easyar_castFrameToDrawable(cdata_.get(), &ptr);
        Drawable::init_cdata(std::shared_ptr<easyar_Drawable>(ptr, [](easyar_Drawable * ptr) { easyar_Drawable__dtor(ptr); }));
    }
}
inline Frame::Frame()
    :
    Drawable(std::shared_ptr<easyar_Drawable>(nullptr)),
    cdata_(nullptr)
{
    easyar_Frame * _return_value_;
    easyar_Frame__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_Frame>(_return_value_, [](easyar_Frame * ptr) { easyar_Frame__dtor(ptr); }));
}
inline Vec2I Frame::size()
{
    auto _return_value_ = easyar_Frame_size(cdata_.get());
    return Vec2I{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline double Frame::timestamp()
{
    auto _return_value_ = easyar_Frame_timestamp(cdata_.get());
    return _return_value_;
}
inline int Frame::index()
{
    auto _return_value_ = easyar_Frame_index(cdata_.get());
    return _return_value_;
}
inline std::vector<std::shared_ptr<Image>> Frame::images()
{
    easyar_ListOfPointerOfImage * _return_value_;
    easyar_Frame_images(cdata_.get(), &_return_value_);
    return std_vector_from_easyar_ListOfPointerOfImage(std::shared_ptr<easyar_ListOfPointerOfImage>(_return_value_, [](easyar_ListOfPointerOfImage * ptr) { easyar_ListOfPointerOfImage__dtor(ptr); }));
}
inline std::vector<std::shared_ptr<TargetInstance>> Frame::targetInstances()
{
    easyar_ListOfPointerOfTargetInstance * _return_value_;
    easyar_Frame_targetInstances(cdata_.get(), &_return_value_);
    return std_vector_from_easyar_ListOfPointerOfTargetInstance(std::shared_ptr<easyar_ListOfPointerOfTargetInstance>(_return_value_, [](easyar_ListOfPointerOfTargetInstance * ptr) { easyar_ListOfPointerOfTargetInstance__dtor(ptr); }));
}
inline std::string Frame::text()
{
    easyar_String * _return_value_;
    easyar_Frame_text(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::shared_ptr<Frame> Frame::tryCastFromDrawable(std::shared_ptr<Drawable> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_Frame * cdata;
    easyar_tryCastDrawableToFrame(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<Frame>(std::shared_ptr<easyar_Frame>(cdata, [](easyar_Frame * ptr) { easyar_Frame__dtor(ptr); }));
}

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFIMAGE__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFIMAGE__
static inline std::shared_ptr<easyar_ListOfPointerOfImage> std_vector_to_easyar_ListOfPointerOfImage(std::vector<std::shared_ptr<Image>> l)
{
    std::vector<easyar_Image *> values;
    values.reserve(l.size());
    for (auto v : l) {
        auto cv = (v == nullptr ? nullptr : v->get_cdata().get());
        easyar_Image__retain(cv, &cv);
        values.push_back(cv);
    }
    easyar_ListOfPointerOfImage * ptr;
    easyar_ListOfPointerOfImage__ctor(values.data(), values.data() + values.size(), &ptr);
    return std::shared_ptr<easyar_ListOfPointerOfImage>(ptr, [](easyar_ListOfPointerOfImage * ptr) { easyar_ListOfPointerOfImage__dtor(ptr); });
}
static inline std::vector<std::shared_ptr<Image>> std_vector_from_easyar_ListOfPointerOfImage(std::shared_ptr<easyar_ListOfPointerOfImage> pl)
{
    auto size = easyar_ListOfPointerOfImage_size(pl.get());
    std::vector<std::shared_ptr<Image>> values;
    values.reserve(size);
    for (int k = 0; k < size; k += 1) {
        auto v = easyar_ListOfPointerOfImage_at(pl.get(), k);
        easyar_Image__retain(v, &v);
        values.push_back((v == nullptr ? nullptr : std::make_shared<Image>(std::shared_ptr<easyar_Image>(v, [](easyar_Image * ptr) { easyar_Image__dtor(ptr); }))));
    }
    return values;
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFTARGETINSTANCE__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFTARGETINSTANCE__
static inline std::shared_ptr<easyar_ListOfPointerOfTargetInstance> std_vector_to_easyar_ListOfPointerOfTargetInstance(std::vector<std::shared_ptr<TargetInstance>> l)
{
    std::vector<easyar_TargetInstance *> values;
    values.reserve(l.size());
    for (auto v : l) {
        auto cv = (v == nullptr ? nullptr : v->get_cdata().get());
        easyar_TargetInstance__retain(cv, &cv);
        values.push_back(cv);
    }
    easyar_ListOfPointerOfTargetInstance * ptr;
    easyar_ListOfPointerOfTargetInstance__ctor(values.data(), values.data() + values.size(), &ptr);
    return std::shared_ptr<easyar_ListOfPointerOfTargetInstance>(ptr, [](easyar_ListOfPointerOfTargetInstance * ptr) { easyar_ListOfPointerOfTargetInstance__dtor(ptr); });
}
static inline std::vector<std::shared_ptr<TargetInstance>> std_vector_from_easyar_ListOfPointerOfTargetInstance(std::shared_ptr<easyar_ListOfPointerOfTargetInstance> pl)
{
    auto size = easyar_ListOfPointerOfTargetInstance_size(pl.get());
    std::vector<std::shared_ptr<TargetInstance>> values;
    values.reserve(size);
    for (int k = 0; k < size; k += 1) {
        auto v = easyar_ListOfPointerOfTargetInstance_at(pl.get(), k);
        easyar_TargetInstance__retain(v, &v);
        values.push_back((v == nullptr ? nullptr : std::make_shared<TargetInstance>(std::shared_ptr<easyar_TargetInstance>(v, [](easyar_TargetInstance * ptr) { easyar_TargetInstance__dtor(ptr); }))));
    }
    return values;
}
#endif

}

#endif
