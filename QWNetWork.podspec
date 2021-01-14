#
# Be sure to run `pod lib lint QWNetWork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QWNetWork'
  s.version          = '0.1.3'
  s.summary          = '基于AFNetWorking封装,个人使用,有兴趣可以告一哈！'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/qingweiiOS/QWNetWork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mr.Q' => 'qingwei2013@foxmail.com' }
  s.source           = { :git => 'https://github.com/qingweiiOS/QWNetWork.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'
   s.source_files = 'QWNetWork/Classes/**/*'
   s.dependency   'AFNetworking'
   s.dependency   'YYModel'
   s.dependency   'QWProgressHUD'
end
