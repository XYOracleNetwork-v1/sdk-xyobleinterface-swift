#
# Be sure to run `pod lib lint sdk-objectmodel-swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'sdk-xyobleinterface-swift'
  s.version          = '3.0.5'
  s.summary          = 'A short description of sdk-xyobleinterface-swift'
  s.swift_version    = '5.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
XYO Ble Interface
                       DESC

  s.homepage         = 'https://github.com/XYOracleNetwork/sdk-xyobleinterface-swift.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'LGPL3', :file => 'LICENSE' }
  s.author           = { 'Carter Harrison' => 'carterjharrison@gmail.com' }
  s.source           = { :git => 'https://github.com/XYOracleNetwork/sdk-xyobleinterface-swift', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'sdk-xyobleinterface-swift/**/*.{swift}'
  
  s.dependency 'PromisesSwift', '~> 1.2.4'

  s.dependency 'sdk-objectmodel-swift',  '~> 3.0'
  s.dependency 'sdk-core-swift', '~> 3.0.1'
  s.dependency 'XyBleSdk', '~> 3.0.3'

end
