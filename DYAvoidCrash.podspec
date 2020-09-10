Pod::Spec.new do |s|
  s.name         = "DYAvoidCrash"
  s.version      = "0.1.1"
  s.summary      = "avoid crash."
  s.description  = <<-DESC
  avoid crash.
DESC
  s.homepage         = 'https://github.com/ZeroDY/DYAvoidCrashDemo'
  s.license          = {:type=>"MIT",:file=>"LICENSE"}
  s.author           = {"zdy" => "deyi233@gmail.com"}
  s.source           = { :git => 'https://github.com/ZeroDY/DYAvoidCrashDemo.git', :tag => s.version.to_s }
  s.platform         = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.public_header_files   = 'DYAvoidCrash/*.h'
  s.private_header_files  = 'DYAvoidCrash/template/*.h'
  s.source_files          = ['DYAvoidCrash/*.{h,m}','DYAvoidCrash/**/*.{h,m,mm}']
  s.requires_arc =
  ['DYAvoidCrash/*.m',
  'DYAvoidCrash/Container/*.m',
  'DYAvoidCrash/KVO/*.m',
  'DYAvoidCrash/NSTimer/*.m',
  'DYAvoidCrash/Notification/*.m',
  'DYAvoidCrash/NSNull/*.m',
  'DYAvoidCrash/SmartKit/*.m',
  'DYAvoidCrash/Swizzling/*.m',
  'DYAvoidCrash/DanglingPointer/DYDanglingPointStub.m',
  'DYAvoidCrash/DanglingPointer/DYDanglingPonterService.m'
  ]
  s.libraries = 'c++'
  s.pod_target_xcconfig = {
    'CLANG_WARN_STRICT_PROTOTYPES' => 'NO',
    'DEFINES_MODULE' => 'YES'
  }
end