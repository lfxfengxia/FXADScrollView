#
# Be sure to run `pod lib lint FXADScrollView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FXADScrollView'
  s.version          = '0.1.0'
  s.summary          = 'swift 写的一个广告轮播图.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
			swift 写的一个广告轮播图，可以设置默认图片，pageControl的位置.
                       DESC

  s.homepage         = 'https://github.com/lfxfengxia/FXADScrollView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lfxfengxia' => 'sayingwhy@163.com' }
  s.source           = { :git => 'https://github.com/lfxfengxia/FXADScrollView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FXADScrollView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FXADScrollView' => ['FXADScrollView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
