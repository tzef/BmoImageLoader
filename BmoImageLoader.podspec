Pod::Spec.new do |s|
  s.name             = 'BmoImageLoader'
  s.version          = '0.1.0'
  s.summary          = 'A short description of BmoImageLoader.'
  s.description      = <<-DESC
BmoImageLoader is a progress animated component for UIImageView
Image downloadder implementation and cache manager use AlamofireImage
                       DESC
  s.homepage         = 'https://github.com/tzef/BmoImageLoader'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LEE ZHE YU' => 'admin@bunbunu.com' }
  s.source           = { :git => 'https://github.com/tzef/BmoImageLoader.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'BmoImageLoader/Classes/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'AlamofireImage', '~> 2.0'
end
