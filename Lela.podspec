Pod::Spec.new do |s|
  s.name         = "Lela"
  s.version      = "0.2.0"
  s.summary      = "Provides perceptial difference screen testing within KIF."
  s.homepage     = "https://github.com/bnickel/Lela/"
  s.license      = 'GPL 3.0'
  s.authors      = { 'Brian Nickel' => 'brian.nickel@gmail.com' }
  s.source       = { :git => "https://github.com/bnickel/Lela.git", :tag => "v0.2.0" }
  s.platform     = :ios, '5.0'
  s.source_files = 'Lela/**/*.{h,m,mm}'
  s.public_header_files = 'Lela/Lela.h', 'Lela/KIFUITestActor+Lela.h'
  s.frameworks   = 'UIKit', 'QuartzCore', 'CoreGraphics'
  s.libraries    = 'c++', 'stdc++'
  s.dependency 'KIF', '~> 3.0.4'
  s.requires_arc = true
end
