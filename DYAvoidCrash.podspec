Pod::Spec.new do |s|
    s.name         = "DYAvoidCrash"
    s.version      = "0.1.0"
    s.summary      = "avoid crash."
    s.homepage     = "https://github.com/ZeroDY/DYAvoidCrashDemo"
    s.license      = {:type=>"MIT",:file=>"LICENSE"}
    s.authors      = {"zdy" => "deyi233@gmail.com"}
    s.platform     = :ios, "9.0"
    s.source       = {:git => "https://github.com/ZeroDY/DYAvoidCrashDemo.git", :tag => s.version}
    s.source_files = "DYAvoidCrash/**/*.{h,m,mm}"
    s.requires_arc = true
    non_arc_files  = "DYAvoidCrash/**/*.mm"
    s.exclude_files = non_arc_files
    s.subspec 'no-arc' do |sp|
      sp.source_files = non_arc_files
      sp.requires_arc = false
    end
end