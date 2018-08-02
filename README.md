# MyWorldiOS

Create a POD File with following dependencies

source 'https://github.com/CocoaPods/Specs.git'
target 'MyWorld' do
    use_frameworks!
    pod 'Alamofire', '~> 4.5'
    pod 'SinchRTC'
    pod 'IQKeyboardManagerSwift', '5.0.0'
    pod 'SDWebImage', '~> 4.0'
    pod 'AFNetworking', '~> 3.0'
    pod 'Google/SignIn'
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'FacebookShare'
    pod 'SVProgressHUD'
    pod 'SwiftRangeSlider'
    pod 'Firebase'
    pod 'GooglePlacePicker'
    pod 'SwiftQRScanner'
    pod 'Instamojo', :git => 'https://github.com/Instamojo/ios-sdk.git', :tag => '1.0.12'
    pod 'InstaMojoiOS', '0.0.3'
    pod 'DCPathButton'
end


Do pod init and pod install
