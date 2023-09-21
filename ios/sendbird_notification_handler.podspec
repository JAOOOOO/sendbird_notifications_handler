#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sendbird_notification_handler.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sendbird_notification_handler'
  s.version          = '0.0.1'
  s.summary          = 'A handler to be able to get sendbird notifications for IOS and Anrdoid'
  s.description      = <<-DESC
A handler to be able to get sendbird notifications for IOS and Anrdoid
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'JAOOOOO' => 'jalalokbi.dev@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
