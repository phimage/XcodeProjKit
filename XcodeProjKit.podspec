Pod::Spec.new do |s|
  s.name             = "XcodeProjKit"
  s.version          = "1.0.0"
  s.license          = "MIT"
  s.homepage         = "https://github.com/phimage/XcodeProjKit/"
  s.summary          = "Read, edit and serialize Xcode projet into open step file format."
  s.author             = { "phimage" => "eric.marchand.n7@gmail.com" }

  s.source           = { :git => "https://github.com/phimage/XcodeProjKit.git", :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'

  s.source_files = "Sources/*.swift"

end
