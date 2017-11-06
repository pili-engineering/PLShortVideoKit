//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_PLAYER_HPP__
#define __EASYAR_PLAYER_HPP__

#include "easyar/types.hpp"

namespace easyar {

class VideoPlayer
{
protected:
    std::shared_ptr<easyar_VideoPlayer> cdata_;
    void init_cdata(std::shared_ptr<easyar_VideoPlayer> cdata);
    VideoPlayer & operator=(const VideoPlayer & data) = delete;
public:
    VideoPlayer(std::shared_ptr<easyar_VideoPlayer> cdata);
    virtual ~VideoPlayer();

    std::shared_ptr<easyar_VideoPlayer> get_cdata();

    VideoPlayer();
    void setVideoType(VideoType videoType);
    void setRenderTexture(void * texture);
    void open(std::string path, StorageType storageType, std::function<void(VideoStatus)> callback);
    void close();
    bool play();
    bool stop();
    bool pause();
    bool isRenderTextureAvailable();
    void updateFrame();
    int duration();
    int currentPosition();
    bool seek(int position);
    Vec2I size();
    float volume();
    bool setVolume(float volume);
};

#ifndef __EASYAR_FUNCTOROFVOIDFROMVIDEOSTATUS__
#define __EASYAR_FUNCTOROFVOIDFROMVIDEOSTATUS__
static void FunctorOfVoidFromVideoStatus_func(void * _state, easyar_VideoStatus);
static void FunctorOfVoidFromVideoStatus_destroy(void * _state);
static inline easyar_FunctorOfVoidFromVideoStatus FunctorOfVoidFromVideoStatus_to_c(std::function<void(VideoStatus)> f);
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_PLAYER_HPP__
#define __IMPLEMENTATION_EASYAR_PLAYER_HPP__

#include "easyar/player.h"
#include "easyar/vector.hpp"

namespace easyar {

inline VideoPlayer::VideoPlayer(std::shared_ptr<easyar_VideoPlayer> cdata)
    :
    cdata_(nullptr)
{
    init_cdata(cdata);
}
inline VideoPlayer::~VideoPlayer()
{
    cdata_ = nullptr;
}

inline std::shared_ptr<easyar_VideoPlayer> VideoPlayer::get_cdata()
{
    return cdata_;
}
inline void VideoPlayer::init_cdata(std::shared_ptr<easyar_VideoPlayer> cdata)
{
    cdata_ = cdata;
}
inline VideoPlayer::VideoPlayer()
    :
    cdata_(nullptr)
{
    easyar_VideoPlayer * _return_value_;
    easyar_VideoPlayer__ctor(&_return_value_);
    init_cdata(std::shared_ptr<easyar_VideoPlayer>(_return_value_, [](easyar_VideoPlayer * ptr) { easyar_VideoPlayer__dtor(ptr); }));
}
inline void VideoPlayer::setVideoType(VideoType arg0)
{
    easyar_VideoPlayer_setVideoType(cdata_.get(), static_cast<easyar_VideoType>(arg0));
}
inline void VideoPlayer::setRenderTexture(void * arg0)
{
    easyar_VideoPlayer_setRenderTexture(cdata_.get(), arg0);
}
inline void VideoPlayer::open(std::string arg0, StorageType arg1, std::function<void(VideoStatus)> arg2)
{
    easyar_VideoPlayer_open(cdata_.get(), std_string_to_easyar_String(arg0).get(), static_cast<easyar_StorageType>(arg1), FunctorOfVoidFromVideoStatus_to_c(arg2));
}
inline void VideoPlayer::close()
{
    easyar_VideoPlayer_close(cdata_.get());
}
inline bool VideoPlayer::play()
{
    auto _return_value_ = easyar_VideoPlayer_play(cdata_.get());
    return _return_value_;
}
inline bool VideoPlayer::stop()
{
    auto _return_value_ = easyar_VideoPlayer_stop(cdata_.get());
    return _return_value_;
}
inline bool VideoPlayer::pause()
{
    auto _return_value_ = easyar_VideoPlayer_pause(cdata_.get());
    return _return_value_;
}
inline bool VideoPlayer::isRenderTextureAvailable()
{
    auto _return_value_ = easyar_VideoPlayer_isRenderTextureAvailable(cdata_.get());
    return _return_value_;
}
inline void VideoPlayer::updateFrame()
{
    easyar_VideoPlayer_updateFrame(cdata_.get());
}
inline int VideoPlayer::duration()
{
    auto _return_value_ = easyar_VideoPlayer_duration(cdata_.get());
    return _return_value_;
}
inline int VideoPlayer::currentPosition()
{
    auto _return_value_ = easyar_VideoPlayer_currentPosition(cdata_.get());
    return _return_value_;
}
inline bool VideoPlayer::seek(int arg0)
{
    auto _return_value_ = easyar_VideoPlayer_seek(cdata_.get(), arg0);
    return _return_value_;
}
inline Vec2I VideoPlayer::size()
{
    auto _return_value_ = easyar_VideoPlayer_size(cdata_.get());
    return Vec2I{{{_return_value_.data[0], _return_value_.data[1]}}};
}
inline float VideoPlayer::volume()
{
    auto _return_value_ = easyar_VideoPlayer_volume(cdata_.get());
    return _return_value_;
}
inline bool VideoPlayer::setVolume(float arg0)
{
    auto _return_value_ = easyar_VideoPlayer_setVolume(cdata_.get(), arg0);
    return _return_value_;
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMVIDEOSTATUS__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMVIDEOSTATUS__
static void FunctorOfVoidFromVideoStatus_func(void * _state, easyar_VideoStatus arg0)
{
    VideoStatus cpparg0 = static_cast<VideoStatus>(arg0);
    auto f = reinterpret_cast<std::function<void(VideoStatus)> *>(_state);
    (*f)(cpparg0);
}
static void FunctorOfVoidFromVideoStatus_destroy(void * _state)
{
    auto f = reinterpret_cast<std::function<void(VideoStatus)> *>(_state);
    delete f;
}
static inline easyar_FunctorOfVoidFromVideoStatus FunctorOfVoidFromVideoStatus_to_c(std::function<void(VideoStatus)> f)
{
    if (f == nullptr) { return easyar_FunctorOfVoidFromVideoStatus{nullptr, nullptr, nullptr}; }
    return easyar_FunctorOfVoidFromVideoStatus{new std::function<void(VideoStatus)>(f), FunctorOfVoidFromVideoStatus_func, FunctorOfVoidFromVideoStatus_destroy};
}
#endif

}

#endif
