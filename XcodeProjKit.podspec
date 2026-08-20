Pod::Spec.new do |s|
  s.name             = "XcodeProjKit"
  s.version          = "3.0.6"
  s.license          = "MIT"
  s.homepage         = "https://github.com/phimage/XcodeProjKit/"
  s.summary          = "Read, edit and serialize Xcode project into open step file format."
  s.author             = { "phimage" => "eric.marchand.n7@gmail.com" }

  s.source           = { :git => "https://github.com/phimage/XcodeProjKit.git", :tag => s.version }

  s.swift_version = '5.0'
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.13'

  s.source_files = "Sources/*.swift"

end
