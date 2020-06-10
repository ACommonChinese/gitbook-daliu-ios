Pod::Spec.new do |s|
    s.name         = 'ZZQRManager'
    #本地引用的话，这埋在的version无关紧要，
    s.version      = '1.3'
    s.summary      = 'An easy way to use qr manage and generate'
    s.homepage     = 'https://github.com/ACommonChinese/ZZQRManager'
    s.license      = 'MIT'
    s.authors      = {'ACommonChinese' => 'liuxing8807@126.com'}
    s.platform     = :ios, '9.0'
    #本地引用的话，这里的.source可以随意填写，但由于语法要求，.source字段必须有，否则脚本出错
    #s.source       = {:git => "file://TODO://", :tag => "#{s.version}"} # source是必填参数,
    s.source       = { :git => "http://172.16.4.198/MP/ios/TODO", :tag => "#{s.version}" }
    s.source_files = "**/*.{h,m}"
    s.resource     = '*.{bundle}'
    s.requires_arc = true

    #s.dependency "XXX"
end