#
# Be sure to run `pod lib lint LvAddressPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LvAddressPicker'
  s.version          = '0.1.1'
  s.summary          = 'Address Picker.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/krisouljz/LvAddressPicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'krisouljz' => '1435073930@qq.com' }
  s.source           = { :git => 'https://github.com/krisouljz/LvAddressPicker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'LvAddressPicker/Classes/**/*'
   s.resource_bundles = {
     'LvAddressPicker' => ['LvAddressPicker/Assets/*.png','LvAddressPicker/Assets/*.json']
   }

end
