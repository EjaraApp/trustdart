#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint trustdart.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'trustdart'
  s.version          = '0.0.1'
  s.summary          = 'A dart library that can interact with the trust wallet core library.'
  s.description      = <<-DESC
  A dart library that can interact with the trust wallet core library.
                       DESC
  s.homepage         = 'https://github.com/EjaraApp/trustdart'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Ejara' => 'baah.kusi@ejara.africa' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'TrustWalletCore'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
