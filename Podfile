platform :ios, '9.0'
use_frameworks!

target 'N3Restful-Swift' do

pod 'SwiftyJSON'
pod 'Alamofire'
pod 'ObjectMapper'
pod 'HTTPStatusCodes'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2'
            config.build_settings['ENABLE_BITCODE'] = 'YES'
        end
    end
end
