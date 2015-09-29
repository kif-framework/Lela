Pod::Spec.new do |s|
  s.name         = "Lela"
  s.version      = "0.2.1"
  s.summary      = "Provides perceptial difference screen testing within KIF."
  s.homepage     = "https://github.com/kif-framework/Lela/"
  s.license      = 'GPL 3.0'
  s.authors      = { 'Brian Nickel' => 'brian.nickel@gmail.com' }
  s.source       = { :git => "https://github.com/kif-framework/Lela.git", :tag => "v0.2.1" }
  s.platform     = :ios, '5.1'
  s.public_header_files = 'Lela/Lela.h', 'Lela/KIFUITestActor+Lela.h'
  s.frameworks   = 'UIKit', 'QuartzCore', 'CoreGraphics', 'XCTest'
  s.libraries    = 'c++', 'stdc++'
  s.requires_arc = true

  s.source_files = 'Lela/**/*.{h,m,mm}'
  s.dependency 'KIF', '~> 3.3'
end
