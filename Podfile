# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'KTGoa' do
  use_frameworks!
  inhibit_all_warnings!

  # NIMSDK_LITE
  pod 'NIMSDK_LITE'
  # Kingfisher
  pod 'Kingfisher'
  # KingfisherWebP
  pod 'KingfisherWebP'
  # SnapKit
  pod 'SnapKit'
  # Alamofire
  pod 'Alamofire'
  # HandyJSON
  pod 'HandyJSON', :git => 'https://github.com/Miles-Matheson/HandyJSON.git'
  # AppsFlyerFramework
  pod 'AppsFlyerFramework'
  # JXSegmentedView
  pod 'JXSegmentedView'
  pod 'JXPagingView/Paging'
  # IQKeyboardManagerSwift
  pod 'IQKeyboardManagerSwift'
  # AliyunOSSiOS
  pod 'AliyunOSSiOS', '~> 2.10.16'
  # SVGAPlayer
  pod 'SVGAPlayer'
  # KeychainSwift
  pod 'KeychainSwift'

end

# 系统适配iOS 12.0
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO' # 解决Rosetta报错问题
    end
  end
end
