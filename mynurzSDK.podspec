Pod::Spec.new do |s|
s.name             = 'mynurzSDK'
s.version          = '0.1.2'
s.summary          = 'Software Development Kit for accessing Mynurz API'

s.homepage         = 'https://mynurz.com'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'roby.kronusasia@gmail.com' => 'roby.kronusasia@gmail.com' }
s.source           = { :git => 'https://github.com/robzimpulse/mynurzSDK', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
s.source_files = 'MynurzSDK/Classes/**/*'

s.dependency "AlamofireImage"
s.dependency "Alamofire"
s.dependency "RealmSwift"
s.dependency "SwiftyJSON"
s.dependency "EZSwiftExtensions"

end
