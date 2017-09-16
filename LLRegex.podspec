Pod::Spec.new do |s|
  s.name             = 'LLRegex'
  s.version          = '1.2.2-alpha'
  s.summary          = 'Regular expression library in Swift, wrapping NSRegularExpression.'
  s.homepage         = 'https://github.com/LittleRockInGitHub/LLRegex'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rocke Young' => 'rockforcareer@icloud.com' }
  s.source           = { :git => 'https://github.com/LittleRockInGitHub/LLRegex.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Sources/*.swift'
end
