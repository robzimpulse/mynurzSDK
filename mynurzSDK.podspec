Pod::Spec.new do |s|
s.name             = 'mynurzSDK'
s.version          = '0.2.8'
s.summary          = 'Software Development Kit for accessing Mynurz API'

s.homepage         = 'https://mynurz.com'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'roby.kronusasia@gmail.com' => 'roby.kronusasia@gmail.com' }
s.source           = { :git => 'https://github.com/robzimpulse/mynurzSDK', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'
s.pod_target_xcconfig = {
    "SWIFT_VERSION" => "3",
#   "OTHER_LDFLAGS" => '$(inherited) -framework "FirebaseCore" -framework "FirebaseMessaging"',
#   "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES",
#   "FRAMEWORK_SEARCH_PATHS" => '$(inherited) "${PODS_ROOT}/FirebaseCore/Frameworks" "${PODS_ROOT}/FirebaseMessaging/Frameworks"'
}
s.source_files = 'MynurzSDK/Classes/**/*'

s.dependency "AlamofireImage"
s.dependency "Alamofire"
s.dependency "RealmSwift"
s.dependency "SwiftyJSON"
s.dependency "EZSwiftExtensions"
s.dependency "PusherSwift"

end
