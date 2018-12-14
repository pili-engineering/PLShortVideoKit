//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_BUFFER_HPP__
#define __EASYAR_BUFFER_HPP__

#include "easyar/types.hpp"

namespace easyar {

class Buffer
{
protected:
    std::shared_ptr<easyar_Buffer> cdata_;
    void init_cdata(std::shared_ptr<easyar_Buffer> cdata);
    Buffer & operator=(const Buffer & data) = delete;
public:
    Buffer(std::shared_ptr<easyar_Buffer> cdata);
    virtual ~Buffer();

    std::shared_ptr<easyar_Buffer> get_cdata();

    void * data();
    int size();
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_BUFFER_HPP__
#define __IMPLEMENTATION_EASYAR_BUFFER_HPP__

#include "easyar/buffer.h"

namespace easyar {

inline Buffer::Buffer(std::shared_ptr<easyar_Buffer> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline Buffer::~Buffer()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_Buffer> Buffer::get_cdata()
{
    return cdata_;
}
inline void Buffer::init_cdata(std::shared_ptr<easyar_Buffer> cdata)
{
    cdata_ = cdata;
}
inline void * Buffer::data()
{
    auto _return_value_ = easyar_Buffer_data(cdata_.get());
    return _return_value_;
}
inline int Buffer::size()
{
    auto _return_value_ = easyar_Buffer_size(cdata_.get());
    return _return_value_;
}

}

#endif
