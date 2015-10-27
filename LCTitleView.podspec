Pod::Spec.new do |s|
  s.name             = "LCTitleView"
  s.version          = "1.0.0"
  s.summary          = "常用的标题视图 Simple title view"
  s.homepage         = "https://github.com/bawn/LCTitleView"
  s.license          = 'MIT'
  s.author           = { "bawn" => "lc5491137@gmail.com" }
  s.source           = { :git => "https://github.com/bawn/LCTitleView.git", :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files     = 'LCTitleView/*.{h,m}'
  s.dependency       "Masonry", "~> 0.6.0"
end
