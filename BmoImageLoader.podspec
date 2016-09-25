Pod::Spec.new do |s|
  s.name             = 'BmoImageLoader'
  s.version          = '0.4.0'
  s.summary          = 'A progress animated component for UIImageView'
  s.description      = <<-DESC
BmoImageLoader is a progress animated component for UIImageView
Image downloader implementation and cache manager use AlamofireImage
                       DESC
  s.homepage         = 'https://github.com/tzef/BmoImageLoader'
  s.screenshots      = 'https://raw.githubusercontent.com/tzef/BmoImageLoader/master/Screenshot/animationStyle.png', 'https://raw.githubusercontent.com/tzef/BmoImageLoader/master/Screenshot/progressControl.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LEE ZHE YU' => 'admin@bunbunu.com' }
  s.source           = { :git => 'https://github.com/tzef/BmoImageLoader.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'BmoImageLoader/Classes/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'AlamofireImage', '~> 2.5.0'
end
