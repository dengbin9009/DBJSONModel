

Pod::Spec.new do |s|
  s.name         = 'DBJSONModel'
  s.summary      = 'A light model framework for iOS.'
  s.version      = '0.5.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'dengbin9009' => 'dengbin9009@126.com' }
  s.social_media_url = 'http://www.jianshu.com/p/fafffd478134'
  s.homepage     = 'https://github.com/dengbin9009/DBJSONModel'

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.7'
  s.watchos.deployment_target = '2.0'

  s.source       = { :git => 'https://github.com/dengbin9009/DBJSONModel.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.source_files = 'DBJSONModel/DBModel/*.{h,m}'
  s.public_header_files = 'DBJSONModel/DBModel/*.{h}'

  s.frameworks = 'Foundation', 'CoreFoundation'

end
