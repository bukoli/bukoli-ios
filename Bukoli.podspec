Pod::Spec.new do |s|
  s.name             = 'Bukoli'
  s.version          = '1.0.4'
  s.summary          = 'Bukoli iOS SDK'
  s.homepage         = 'https://github.com/bukoli/bukoli-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bukoli' => 'http://www.bukoli.com' }
  s.source           = { :git => 'https://github.com/bukoli/bukoli-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Bukoli/Classes/**/*'
  
  s.resource_bundles = {
    'Bukoli' => ['Bukoli/Assets/{*.storyboard,*.xcassets,*.xib}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire', '~> 4.0'
  s.dependency 'ObjectMapper', '~> 2.0'
  s.dependency 'AlamofireImage', '~> 3.0'
end
