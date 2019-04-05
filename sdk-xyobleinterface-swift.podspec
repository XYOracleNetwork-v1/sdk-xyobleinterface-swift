#
# Be sure to run `pod lib lint sdk-objectmodel-swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'sdk-xyobleinterface-swift'
  s.version          = '0.1.4-beta.5'
  s.summary          = 'A short description of sdk-xyobleinterface-swift'


  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/XYOracleNetwork/sdk-xyobleinterface-swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author           = { 'Carter Harrison' => 'carterjharrison@gmail.com' }
  s.source           = { :git => 'https://github.com/XYOracleNetwork/sdk-xyobleinterface-swift', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'sdk-xyobleinterface-swift/**/*.{swift}'
  
  s.dependency 'PromisesSwift', '~> 1.2.4'

  s.dependency 'sdk-objectmodel-swift',  '~> 0.1.2-beta.3'
  s.dependency 'sdk-core-swift', '~> 0.1.5-beta.2'
  s.dependency 'XyBleSdk', '~> 0.0.1'


end
