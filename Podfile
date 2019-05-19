platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

target 'Restful-Swift' do

pod 'SwiftyJSON'
pod 'Alamofire'
pod 'ObjectMapper'
pod 'HTTPStatusCodes'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
            config.build_settings['ENABLE_BITCODE'] = 'YES'
        end
    end
end
