#
# Be sure to run `pod lib lint sdk-objectmodel-swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'mod-ble-swift'
  s.version          = '0.1.1-beta.1'
  s.summary          = 'A short description of mod-ble-swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/XYOracleNetwork/mod-ble-swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author           = { 'Carter Harrison' => 'carterjharrison@gmail.com' }
  s.source           = { :git => 'https://github.com/XYOracleNetwork/mod-ble-swift', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'mod-ble-swift/**/*.{swift}'
  
  # s.resource_bundles = {
  #   'sdk-objectmodel-swift' => ['sdk-objectmodel-swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'PromisesSwift', '~> 1.2.4'

  s.dependency 'sdk-objectmodel-swift',  '~> 0.1.2-beta.1'
  s.dependency 'sdk-core-swift', '~> 0.1.2-beta.5'
  s.dependency 'XyBleSdk'

  s.subspec 'XyBleSdk' do |ss|
      ss.source_files         = '../../sdk-ble-swift/Source/**/*.{swift}'
  end


end
