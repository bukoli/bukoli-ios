Pod::Spec.new do |s|
  s.name             = 'Bukoli'
  s.version          = '0.2.0'
  s.summary          = 'Bukoli iOS SDK'
  s.homepage         = 'https://github.com/bukoli/bukoli-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bukoli' => 'http://www.bukoli.com' }
  s.source           = { :git => 'https://github.com/bukoli/bukoli-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Bukoli/Classes/**/*'

  s.resource_bundles = {
    'Bukoli' => ['Bukoli/Assets/{*.storyboard,*.xcassets,*.xib}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire', '~> 3.0'
  s.dependency 'AlamofireImage', '~> 2.0'
  s.dependency 'ObjectMapper', '~> 1.0'
end
