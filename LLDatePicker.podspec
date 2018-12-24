#
# Be sure to run `pod lib lint LLDatePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LLDatePicker'
  s.version          = '0.0.1'
  s.summary          = '时间选择器'
  s.homepage         = 'https://github.com/Niday/LLDatePicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LL' => '1833900456@qq.com' }
  s.source           = { :git => 'https://github.com/Niday/LLDatePicker.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'LLDatePicker/Classes/**/*.{h,m}'
  s.dependency 'DateTools'
end
