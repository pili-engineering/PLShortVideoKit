//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_OBJECTTARGET_HPP__
#define __EASYAR_OBJECTTARGET_HPP__

#include "easyar/types.hpp"
#include "easyar/target.hpp"

namespace easyar {

class ObjectTarget : public Target
{
protected:
    std::shared_ptr<easyar_ObjectTarget> cdata_;
    void init_cdata(std::shared_ptr<easyar_ObjectTarget> cdata);
    ObjectTarget & operator=(const ObjectTarget & data) = delete;
public:
    ObjectTarget(std::shared_ptr<easyar_ObjectTarget> cdata);
    virtual ~ObjectTarget();

    std::shared_ptr<easyar_ObjectTarget> get_cdata();

    ObjectTarget();
    bool setup(std::string path, int storageType, std::string name);
    static std::vector<std::shared_ptr<ObjectTarget>> setupAll(std::string path, int storageType);
    float scale();
    std::vector<Vec3F> boundingBox();
    std::vector<Vec3F> boundingBoxGL();
    bool setScale(float scale);
    int runtimeID();
    std::string uid();
    std::string name();
    std::string meta();
    void setMeta(std::string data);
    static std::shared_ptr<ObjectTarget> tryCastFromTarget(std::shared_ptr<Target> v);
};

#ifndef __EASYAR_LISTOFPOINTEROFOBJECTTARGET__
#define __EASYAR_LISTOFPOINTEROFOBJECTTARGET__
static inline std::shared_ptr<easyar_ListOfPointerOfObjectTarget> std_vector_to_easyar_ListOfPointerOfObjectTarget(std::vector<std::shared_ptr<ObjectTarget>> l);
static inline std::vector<std::shared_ptr<ObjectTarget>> std_vector_from_easyar_ListOfPointerOfObjectTarget(std::shared_ptr<easyar_ListOfPointerOfObjectTarget> pl);
#endif

#ifndef __EASYAR_LISTOFVEC_F__
#define __EASYAR_LISTOFVEC_F__
static inline std::shared_ptr<easyar_ListOfVec3F> std_vector_to_easyar_ListOfVec3F(std::vector<Vec3F> l);
static inline std::vector<Vec3F> std_vector_from_easyar_ListOfVec3F(std::shared_ptr<easyar_ListOfVec3F> pl);
#endif

}

namespace std {

template<>
inline shared_ptr<easyar::ObjectTarget> dynamic_pointer_cast<easyar::ObjectTarget, easyar::Target>(const shared_ptr<easyar::Target> & r) noexcept
{
    return easyar::ObjectTarget::tryCastFromTarget(r);
}

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_OBJECTTARGET_HPP__
#define __IMPLEMENTATION_EASYAR_OBJECTTARGET_HPP__

#include "easyar/objecttarget.h"
#include "easyar/target.hpp"
#include "easyar/vector.hpp"

namespace easyar {

inline ObjectTarget::ObjectTarget(std::shared_ptr<easyar_ObjectTarget> cdata)
    :
    Target(std::shared_ptr<easyar_Target>(nullptr)),
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline ObjectTarget::~ObjectTarget()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_ObjectTarget> ObjectTarget::get_cdata()
{
    return cdata_;
}
inline void ObjectTarget::init_cdata(std::shared_ptr<easyar_ObjectTarget> cdata)
{
    cdata_ = cdata;
    {
        easyar_Target * ptr = nullptr;
        easyar_castObjectTargetToTarget(cdata_.get(), &ptr);
        Target::init_cdata(std::shared_ptr<easyar_Target>(ptr, [](easyar_Target * ptr) { easyar_Target__dtor(ptr); }));
    }
}
inline ObjectTarget::ObjectTarget()
    :
    Target(std::shared_ptr<easyar_Target>(nullptr)),
    cdata_(nullptr)
{
    easyar_ObjectTarget * _return_value_;
    easyar_ObjectTarget__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_ObjectTarget>(_return_value_, [](easyar_ObjectTarget * ptr) { easyar_ObjectTarget__dtor(ptr); }));
}
inline bool ObjectTarget::setup(std::string arg0, int arg1, std::string arg2)
{
    auto _return_value_ = easyar_ObjectTarget_setup(cdata_.get(), std_string_to_easyar_String(arg0).get(), arg1, std_string_to_easyar_String(arg2).get());
    return _return_value_;
}
inline std::vector<std::shared_ptr<ObjectTarget>> ObjectTarget::setupAll(std::string arg0, int arg1)
{
    easyar_ListOfPointerOfObjectTarget * _return_value_;
    easyar_ObjectTarget_setupAll(std_string_to_easyar_String(arg0).get(), arg1, &_return_value_);
    return std_vector_from_easyar_ListOfPointerOfObjectTarget(std::shared_ptr<easyar_ListOfPointerOfObjectTarget>(_return_value_, [](easyar_ListOfPointerOfObjectTarget * ptr) { easyar_ListOfPointerOfObjectTarget__dtor(ptr); }));
}
inline float ObjectTarget::scale()
{
    auto _return_value_ = easyar_ObjectTarget_scale(cdata_.get());
    return _return_value_;
}
inline std::vector<Vec3F> ObjectTarget::boundingBox()
{
    easyar_ListOfVec3F * _return_value_;
    easyar_ObjectTarget_boundingBox(cdata_.get(), &_return_value_);
    return std_vector_from_easyar_ListOfVec3F(std::shared_ptr<easyar_ListOfVec3F>(_return_value_, [](easyar_ListOfVec3F * ptr) { easyar_ListOfVec3F__dtor(ptr); }));
}
inline std::vector<Vec3F> ObjectTarget::boundingBoxGL()
{
    easyar_ListOfVec3F * _return_value_;
    easyar_ObjectTarget_boundingBoxGL(cdata_.get(), &_return_value_);
    return std_vector_from_easyar_ListOfVec3F(std::shared_ptr<easyar_ListOfVec3F>(_return_value_, [](easyar_ListOfVec3F * ptr) { easyar_ListOfVec3F__dtor(ptr); }));
}
inline bool ObjectTarget::setScale(float arg0)
{
    auto _return_value_ = easyar_ObjectTarget_setScale(cdata_.get(), arg0);
    return _return_value_;
}
inline int ObjectTarget::runtimeID()
{
    auto _return_value_ = easyar_ObjectTarget_runtimeID(cdata_.get());
    return _return_value_;
}
inline std::string ObjectTarget::uid()
{
    easyar_String * _return_value_;
    easyar_ObjectTarget_uid(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::string ObjectTarget::name()
{
    easyar_String * _return_value_;
    easyar_ObjectTarget_name(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline std::string ObjectTarget::meta()
{
    easyar_String * _return_value_;
    easyar_ObjectTarget_meta(cdata_.get(), &_return_value_);
    return std_string_from_easyar_String(std::shared_ptr<easyar_String>(_return_value_, [](easyar_String * ptr) { easyar_String__dtor(ptr); }));
}
inline void ObjectTarget::setMeta(std::string arg0)
{
    easyar_ObjectTarget_setMeta(cdata_.get(), std_string_to_easyar_String(arg0).get());
}
inline std::shared_ptr<ObjectTarget> ObjectTarget::tryCastFromTarget(std::shared_ptr<Target> v)
{
    if (v == nullptr) {
        return nullptr;
    }
    easyar_ObjectTarget * cdata;
    easyar_tryCastTargetToObjectTarget(v->get_cdata().get(), &cdata);
    if (cdata == nullptr) {
        return nullptr;
    }
    return std::make_shared<ObjectTarget>(std::shared_ptr<easyar_ObjectTarget>(cdata, [](easyar_ObjectTarget * ptr) { easyar_ObjectTarget__dtor(ptr); }));
}

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFOBJECTTARGET__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFOBJECTTARGET__
static inline std::shared_ptr<easyar_ListOfPointerOfObjectTarget> std_vector_to_easyar_ListOfPointerOfObjectTarget(std::vector<std::shared_ptr<ObjectTarget>> l)
{
    std::vector<easyar_ObjectTarget *> values;
    values.reserve(l.size());
    for (auto v : l) {
        auto cv = (v == nullptr ? nullptr : v->get_cdata().get());
        easyar_ObjectTarget__retain(cv, &cv);
        values.push_back(cv);
    }
    easyar_ListOfPointerOfObjectTarget * ptr;
    easyar_ListOfPointerOfObjectTarget__ctor(values.data(), values.data() + values.size(), &ptr);
    return std::shared_ptr<easyar_ListOfPointerOfObjectTarget>(ptr, [](easyar_ListOfPointerOfObjectTarget * ptr) { easyar_ListOfPointerOfObjectTarget__dtor(ptr); });
}
static inline std::vector<std::shared_ptr<ObjectTarget>> std_vector_from_easyar_ListOfPointerOfObjectTarget(std::shared_ptr<easyar_ListOfPointerOfObjectTarget> pl)
{
    auto size = easyar_ListOfPointerOfObjectTarget_size(pl.get());
    std::vector<std::shared_ptr<ObjectTarget>> values;
    values.reserve(size);
    for (int k = 0; k < size; k += 1) {
        auto v = easyar_ListOfPointerOfObjectTarget_at(pl.get(), k);
        easyar_ObjectTarget__retain(v, &v);
        values.push_back((v == nullptr ? nullptr : std::make_shared<ObjectTarget>(std::shared_ptr<easyar_ObjectTarget>(v, [](easyar_ObjectTarget * ptr) { easyar_ObjectTarget__dtor(ptr); }))));
    }
    return values;
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_LISTOFVEC_F__
#define __IMPLEMENTATION_EASYAR_LISTOFVEC_F__
static inline std::shared_ptr<easyar_ListOfVec3F> std_vector_to_easyar_ListOfVec3F(std::vector<Vec3F> l)
{
    std::vector<easyar_Vec3F> values;
    values.reserve(l.size());
    for (auto v : l) {
        auto cv = easyar_Vec3F{{v.data[0], v.data[1], v.data[2]}};
        values.push_back(cv);
    }
    easyar_ListOfVec3F * ptr;
    easyar_ListOfVec3F__ctor(values.data(), values.data() + values.size(), &ptr);
    return std::shared_ptr<easyar_ListOfVec3F>(ptr, [](easyar_ListOfVec3F * ptr) { easyar_ListOfVec3F__dtor(ptr); });
}
static inline std::vector<Vec3F> std_vector_from_easyar_ListOfVec3F(std::shared_ptr<easyar_ListOfVec3F> pl)
{
    auto size = easyar_ListOfVec3F_size(pl.get());
    std::vector<Vec3F> values;
    values.reserve(size);
    for (int k = 0; k < size; k += 1) {
        auto v = easyar_ListOfVec3F_at(pl.get(), k);
        values.push_back(Vec3F{{{v.data[0], v.data[1], v.data[2]}}});
    }
    return values;
}
#endif

}

#endif
