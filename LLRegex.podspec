Pod::Spec.new do |s|
  s.name             = 'LLRegex'
  s.version          = '1.0.0'
  s.summary          = 'Regular expression library in Swift, wrapping NSRegularExpression.'
  s.homepage         = 'https://github.com/LittleRockInGitHub/LLRegex'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rocke Young' => 'rockforcareer@icloud.com' }
  s.source           = { :git => 'https://github.com/Rocke Young/LLRegex.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'Project/LLRegex/LLRegex/*.swift'
end
