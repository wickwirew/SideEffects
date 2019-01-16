Pod::Spec.new do |s|
  s.name          = "SideEffects"
  s.version       = "0.1"
  s.summary       = "A µFramework for handling side effects in a ReSwift applcation."
  s.homepage      = "https://github.com/wickwirew/SideEffects"
  s.source        = { :git => "https://github.com/wickwirew/SideEffects.git", :tag => s.version }
  s.license       = { :type => "MIT", :file => "LICENSE" }
  
  s.author        = { "Wes Wickwire" => "wickwirew@gmail.com" }
  
  s.swift_version = '4.2'
  s.platform      = :ios
  s.ios.deployment_target = "10.0"

  s.source_files  = "SideEffects/**/*.swift"
end
