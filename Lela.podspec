Pod::Spec.new do |s|
  s.name         = "Lela"
  s.version      = "0.2.0"
  s.summary      = "Provides perceptial difference screen testing within KIF."
  s.homepage     = "https://github.com/bnickel/Lela/"
  s.license      = 'GPL 3.0'
  s.authors      = { 'Brian Nickel' => 'brian.nickel@gmail.com' }
  s.source       = { :git => "https://github.com/bnickel/Lela.git", :tag => "v0.2.0" }
  s.platform     = :ios, '5.1'
  s.public_header_files = 'Lela/Lela.h', 'Lela/KIFUITestActor+Lela.h'
  s.frameworks   = 'UIKit', 'QuartzCore', 'CoreGraphics'
  s.libraries    = 'c++', 'stdc++'
  s.requires_arc = true

  s.default_subspec = 'XCTest'

  s.subspec 'OCUnit' do |sentest|
    sentest.source_files = 'Lela/**/*.{h,m,mm}'
    sentest.dependency 'KIF/OCUnit', '~> 3.0'

    # I would expect the following to be inherited but lint disagrees.
    sentest.framework = 'SenTestingKit'
    sentest.xcconfig = { 'OTHER_CFLAGS' => '-DKIF_SENTEST' }
  end

  s.subspec 'XCTest' do |xctest|
    xctest.source_files = 'Lela/**/*.{h,m,mm}'
    xctest.dependency 'KIF/XCTest', '~> 3.0'

    # I would expect the following to be inherited but lint disagrees.
    xctest.framework = 'XCTest'
    xctest.xcconfig = { 'OTHER_CFLAGS' => '-DKIF_XCTEST' }
  end

end
