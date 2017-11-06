//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_IMAGETARGET_HPP__
#define __EASYAR_IMAGETARGET_HPP__

#include "easyar/types.hpp"
#include "easyar/target.hpp"

namespace easyar {

class ImageTarget : public Target
{
protected:
    std::shared_ptr<easyar_ImageTarget> cdata_;
    void init_cdata(std::shared_ptr<easyar_ImageTarget> cdata);
    ImageTarget & operator=(const ImageTarget & data) = delete;
public:
    ImageTarget(std::shared_ptr<easyar_ImageTarget> cdata);
    virtual ~ImageTarget();

    std::shared_ptr<easyar_ImageTarget> get_cdata();

    ImageTarget();
    bool setup(std::string path, int storageType, std::string name);
    static std::vector<std::shared_ptr<ImageTarget>> setupAll(std::string path, int storageType);
    Vec2F size();
    bool setSize(Vec2F size);
    std::vector<std::shared_ptr<Image>> images();
    int runtimeID();
    std::string uid();
    std::string name();
    std::string meta();
    void setMeta(std::string data);
    static std::shared_ptr<ImageTarget> tryCastFromTarget(std::shared_ptr<Target> v);
};

#ifndef __EASYAR_LISTOFPOINTEROFIMAGETARGET__
#define __EASYAR_LISTOFPOINTEROFIMAGETARGET__
static inline std::shared_ptr<easyar_ListOfPointerOfImageTarget> std_vector_to_easyar_ListOfPointerOfImageTarget(std::vector<std::shared_ptr<ImageTarget>> l);
static inline std::vector<std::shared_ptr<ImageTarget>> std_vector_from_easyar_ListOfPointerOfImageTarget(std::shared_ptr<easyar_ListOfPointerOfImageTarget> pl);
#endif

#ifndef __EASYAR_LISTOFPOINTEROFIMAGE__
#define __EASYAR_LISTOFPOINTEROFIMAGE__
static inline std::shared_ptr<easyar_ListOfPointerOfImage> std_vector_to_easyar_ListOfPointerOfImage(std::vector<std::shared_ptr<Image>> l);
static inline std::vector<std::shared_ptr<Image>> std_vector_from_easyar_ListOfPointerOfImage(std::shared_ptr<easyar_ListOfPointerOfImage> pl);
#endif

}

namespace std {

template<>
inline shared_ptr<easyar::ImageTarget> dynamic_pointer_cast<easyar::ImageTarget, easyar::Target>(const shared_ptr<easyar::Target> & r) noexcept
{
    return easyar::ImageTarget::tryCastFromTarget(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_IMAGETARGET_HPP__
#define __IMPLEMENTATION_EASYAR_IMAGETARGET_HPP__

#include "easyar/imagetarget.h"
#include "easyar/target.hpp"
#include "easyar/vector.hpp"
#include "easyar/image.hpp"

namespace easyar {

inline ImageTarget::ImageTarget(std::shared_ptr<easyar_ImageTarget> cdata)
    :
    Target(std::shared_ptr<easyar_Target>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline ImageTarget::~ImageTarget()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_ImageTarget> ImageTarget::get_cdata()
{
    return cdata_;
}
inline void ImageTarget::init_cdata(std::shared_ptr<easyar_ImageTarget> cdata)
{
    cdata_ = cdata;
    {
        easyar_Target * ptr = nullptr;
        easyar_castImageTargetToTarget(cdata_.get(), &ptr);
        Target::init_cdata(std::shared_ptr<easyar_Target>(ptr, [](easyar_Target * ptr) { easyar_Target__dtor(ptr); }));
    }
}
inline ImageTarget::ImageTarget()
    :
    Target(std::shared_ptr<easyar_Target>(nullptr)),
    cdata_(nullptr)
{
    easyar_ImageTarget * _return_value_;
    easyar_ImageTarget__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_ImageTarget>(_return_value_, [](easyar_ImageTarget * ptr) { easyar_ImageTarget__dtor(ptr); }));
}
inline bool ImageTarget::setup(std::string arg0, int arg1, std::string arg2)
{
    auto _return_value_ = easyar_ImageTarget_setup(cdata_.get(), std_string_to_easyar_String(arg0).get(), arg1, std_string_to_easyar_String(arg2).get());
    return _return_value_;
}
inline std::vector<std::shared_ptr<ImageTarget>> ImageTarget::setupAll(std::string arg0, int arg1)
{
    easyar_ListOfPointerOfImageTarget * _return_value_;
    easyar_ImageTarget_setupAll(std_string_to_easyar_String(arg0).get(), arg1, &_return_value_);
    return std_vector_from_easyar_ListOfPointerOfImageTarget(std::shared_ptr<easyar_ListOfPointerOfImageTarget>(_return_value_, [](easyar_ListOfPointerOfImageTarget * ptr) { easyar_ListOfPointerOfImageTarget__dtor(ptr); }));
}
inline Vec2F ImageTarget::size()
{
    auto _return_value_ = easyar_ImageTarget_size(cdata_.get());
    return Vec2F{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline bool ImageTarget::setSize(Vec2F arg0)
{
    auto _return_value_ = easyar_ImageTarget_setSize(cdata_.get(), easyar_Vec2F{{arg0.data[0], arg0.data[1]}});
    return _return_value_;
}
inline std::vector<std::shared_ptr<Image>> ImageTarget::images()
{
    easyar_ListOfPointerOfImage * _return_value_;
    easyar_ImageTarget_images(cdata_.get(), &_return_value_);
    return std_vector_from_easyar_ListOfPointerOfImage(std::shared_ptr<easyar_ListOfPointerOfImage>(_return_value_, [](easyar_ListOfPointerOfImage * ptr) { easyar_ListOfPointerOfImage__dtor(ptr); }));
}
inline int ImageTarget::runtimeID()
{
    auto _return_value_ = easyar_ImageTarget_runtimeID(cdata_.get());
    return _return_value_;
}
inline std::string ImageTarget::uid()
{
    easyar_String * _return_value_;
    easyar_ImageTarget_uid(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::string ImageTarget::name()
{
    easyar_String * _return_value_;
    easyar_ImageTarget_name(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::string ImageTarget::meta()
{
    easyar_String * _return_value_;
    easyar_ImageTarget_meta(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline void ImageTarget::setMeta(std::string arg0)
{
    easyar_ImageTarget_setMeta(cdata_.get(), std_string_to_easyar_String(arg0).get());
}
inline std::shared_ptr<ImageTarget> ImageTarget::tryCastFromTarget(std::shared_ptr<Target> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_ImageTarget * cdata;
    easyar_tryCastTargetToImageTarget(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<ImageTarget>(std::shared_ptr<easyar_ImageTarget>(cdata, [](easyar_ImageTarget * ptr) { easyar_ImageTarget__dtor(ptr); }));
}

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFIMAGETARGET__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFIMAGETARGET__
static inline std::shared_ptr<easyar_ListOfPointerOfImageTarget> std_vector_to_easyar_ListOfPointerOfImageTarget(std::vector<std::shared_ptr<ImageTarget>> l)
{
    std::vector<easyar_ImageTarget *> values;
    values.reserve(l.size());
    for (auto v : l) {
        auto cv = (v == nullptr ? nullptr : v->get_cdata().get());
        easyar_ImageTarget__retain(cv, &cv);
        values.push_back(cv);
    }
    easyar_ListOfPointerOfImageTarget * ptr;
    easyar_ListOfPointerOfImageTarget__ctor(values.data(), values.data() + values.size(), &ptr);
    return std::shared_ptr<easyar_ListOfPointerOfImageTarget>(ptr, [](easyar_ListOfPointerOfImageTarget * ptr) { easyar_ListOfPointerOfImageTarget__dtor(ptr); });
}
static inline std::vector<std::shared_ptr<ImageTarget>> std_vector_from_easyar_ListOfPointerOfImageTarget(std::shared_ptr<easyar_ListOfPointerOfImageTarget> pl)
{
    auto size = easyar_ListOfPointerOfImageTarget_size(pl.get());
    std::vector<std::shared_ptr<ImageTarget>> values;
    values.reserve(size);
    for (int k = 0; k < size; k += 1) {
        auto v = easyar_ListOfPointerOfImageTarget_at(pl.get(), k);
        easyar_ImageTarget__retain(v, &v);
        values.push_back((v == nullptr ? nullptr : std::make_shared<ImageTarget>(std::shared_ptr<easyar_ImageTarget>(v, [](easyar_ImageTarget * ptr) { easyar_ImageTarget__dtor(ptr); }))));
    }
    return values;
}
#endif

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

}

#endif
