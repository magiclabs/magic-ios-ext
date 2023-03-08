#
# Local Podspec for building local target
#

Pod::Spec.new do |s|
  s.name             = 'MagicExt-OIDC'
  s.version          = '2.0.0'
  s.summary          = 'Magic IOS Extension - OIDC'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/magicLabs/magic-ios-ext'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jerry Liu' => 'jerry@magic.link' }
  s.source           = { :git => 'https://github.com/magicLabs/magic-ios-ext.git', :tag => s.version.to_s }
  s.swift_version = '5.0'
  s.ios.deployment_target = '13.0'
#   s.osx.deployment_target  = '10.15'

  s.source_files = 'Sources/MagicExt-OIDC/**/*'

  s.dependency 'MagicSDK', '~> 7.0'

  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
