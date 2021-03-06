Pod::Spec.new do |s|

    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.name = "SwiftBaseViews"
    s.summary = "A collection of base view/view controller classes for Swift."
    s.requires_arc = true
    s.version = "1.2.0"
    s.license = { :type => "Apache-2.0", :file => "LICENSE" }
    s.author = { "Hai Pham" => "swiften.svc@gmail.com" }
    s.homepage = "https://github.com/protoman92/SwiftBaseViews.git"
    s.source = { :git => "https://github.com/protoman92/SwiftBaseViews.git", :tag => "#{s.version}"}
    s.framework = "UIKit"
    s.dependency 'SwiftUIUtilities/Main'

    s.subspec 'Main' do |main|
        main.source_files = "SwiftBaseViews/**/*.{swift}"
    end

end
