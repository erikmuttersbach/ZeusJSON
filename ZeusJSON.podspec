Pod::Spec.new do |s|
  s.name             = "ZeusJSON"
  s.version          = "0.1.0"
  s.summary          = "Deserialize JSON objects to Objective-C model objects."
  s.description		 = "ZeusJSON deserialized complex JSON objects to Objective-C models. It supports side-loaded (id references) objects, custom transformers and does not require a change of the model classes."
  s.homepage         = "https://github.com/erikmuttersbach/ZeusJSON"
  s.license          = 'MIT'
  s.author           = { "Erik Muttersbach" => "erik@muttersbach.net" }
  s.source           = { :git => "https://github.com/erikmuttersbach/ZeusJSON.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  non_arc_files = 'ZeusJSON/NSString+Inflections.{h,m}'
  s.subspec 'arc' do |sp|
    sp.source_files = 'ZeusJSON/*.{h,m}'
    sp.exclude_files = non_arc_files
    sp.requires_arc = true
    sp.prefix_header_file = 'ZeusJSON/ZeusJSON-Prefix.pch'
  end
  
  s.subspec 'no-arc' do |sp|
    sp.source_files = non_arc_files
    sp.requires_arc = false
  end
  
  s.framework     = 'Foundation'
  s.dependency 'RegexKitLite', '~> 4.0'
  s.dependency 'CocoaLumberjack'
  s.dependency 'MYSRuntime'
end
