#
#  Be sure to run `pod spec lint PLShortVideoKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "PLShortVideoKit"
  s.version      = "1.6.0"
  s.summary      = "PILI iOS short video record SDK"
  s.homepage     = "https://github.com/pili-engineering/PLShortVideoKit"
  s.license      = "Apache License 2.0"
  s.author       = { "pili" => "pili@qiniu.com" }
  s.source       = { :git => "https://github.com/pili-engineering/PLShortVideoKit.git", :tag => "v#{s.version}" }
  s.platform     = :ios
  s.requires_arc = true

  s.ios.deployment_target	= "8.0"
 
  s.dependency 'Qiniu', '7.1.7'


  s.subspec "ex-libMuseProcessor" do |ss1|
    ss1.vendored_framework		= "Pod/Library/PLShortVideoKit.framework"
  end


  s.subspec "libMuseProcessor" do |ss2|
    ss2.vendored_libraries		= 'Pod/Library/*.a'
  end

end
