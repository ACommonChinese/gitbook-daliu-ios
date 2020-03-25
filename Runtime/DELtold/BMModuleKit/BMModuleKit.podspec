Pod::Spec.new do |s|
  s.name         = "BMModuleKit"
  s.version      = "1.0.0"
  s.summary      = "BMModuleKit Framework."

  s.description  = <<-DESC
	This is a component framework
                   DESC

  s.homepage     = "https://www.hellobanma.com"
  s.license      = "Banma-Inc copyright"
  s.author             = { "Chris" => "xiantong.cxt@alibaba-inc.com" }
  s.platform     = :ios, "9.0"

  s.source       = { :http => "https://mp-zxq.oss-cn-shanghai.aliyuncs.com/pod/BMModuleKit/1.0.0/BMModuleKit.zip" }

  s.vendored_frameworks = "BMModuleKit.framework"
end
