Pod::Spec.new do |s|
  s.name             = 'ZegoExpressEngine'
  s.version          = '3.0.0'  # Match your SDK version
  s.summary          = 'Zego Express Audio/Video Live SDK'
  s.homepage         = 'https://www.zegocloud.com'
  s.license          = { :type => 'Copyright', :text => 'Copyright © 2018-2023 ZEGO' }
  s.author           = { 'ZEGOCLOUND' => 'xxxx@zegocloud.com' }
  s.source           = { :path => '.' }
  s.platform         = :ios, '11.0'
  s.ios.deployment_target = '11.0'
  s.vendored_frameworks = 'ZegoExpressEngine.xcframework'
end