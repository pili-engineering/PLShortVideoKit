#
#  Be sure to run `pod spec lint PLShortVideoKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "PLShortVideoKit"
  s.version      = "3.2.5"
  s.summary      = "PILI iOS short video record SDK"
  s.homepage     = "https://github.com/pili-engineering/PLShortVideoKit"
  s.license      = "Apache License 2.0"
  s.author       = { "pili" => "pili@qiniu.com" }
  s.source       = { :http => "https://sdk-release.qnsdk.com/PLShortVideoKit-advanced-v#{s.version}.zip"}
  s.platform     = :ios
  s.requires_arc = true

  s.ios.deployment_target	= "8.0"
 
  s.dependency 'Qiniu', '8.2.0'

  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.subspec "ex-libMuseProcessor" do |ss1|
    ss1.vendored_framework		= "Pod/Library/Advanced/PLShortVideoKit.framework"
  end


  s.subspec "libMuseProcessor" do |ss2|
    ss2.vendored_libraries		= 'Pod/Library/Advanced/*.a'
  end

end
