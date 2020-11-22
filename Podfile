source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

platform :ios, '13.0'

# ignore all warnings from all pods
inhibit_all_warnings!

def main_pods
  pod 'Alamofire', '5.3.0'
  pod 'AlamofireImage', '4.1'
  pod 'SwiftLint', '0.41.0'
  rx_pods
end

def rx_pods
  pod 'RxSwift', '6.0.0-rc.2'
  pod 'RxCocoa', '6.0.0-rc.2'
end

target 'NYTimes' do
  project 'NYTimes.xcodeproj'
  workspace 'NYTimes'
  
  main_pods
end

target 'NYTimesTests' do
    rx_pods
    pod 'RxBlocking', '6.0.0-rc.2'
    pod 'RxTest', '6.0.0-rc.2'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      
      if config.name == 'Debug' || config.name == 'Development'
        config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)', '-D DEBUG']
      end
    end
  end
end

