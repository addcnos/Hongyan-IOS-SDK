# execute time: 2021-01-13 18:59:43
#
# Be sure to run `pod lib lint TWSRIMProject.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'TWSRIMProject'
    s.version          = '1.0.0'
    s.summary          = '数睿IM核心基础组件库'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = '数睿IM核心基础库'
    
    s.homepage         = 'https://github.com/addcnos/Hongyan-IOS-SDK'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'addcnos' => '' }
    s.source           = { :git => 'https://github.com/addcnos/Hongyan-IOS-SDK.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    # 支持的版本号
    s.platform      = :ios, '9.0'
    # pod 支持的开源库语言最低版本号
    s.ios.deployment_target = '9.0'
    # 开放共用头文件地址
    s.public_header_files = 'TWSRIMProject/Classes/SRIMProject.h'
    # 头文件地址
    s.source_files = 'TWSRIMProject/Classes/SRIMProject.h'
    # s.source_files = 'TWSRIMProject/Classes/**/*'
    # 遵循的公共头文件
    s.prefix_header_contents = '#import <UIKit/UIKit.h>', '#import <Foundation/Foundation.h>'
    
    # 图片资源
    s.resource_bundles = {
        'TWSRIMProject' => ['TWSRIMProject/Assets/*']
    }
    
    s.subspec 'SRIMCommonHeaders' do |ss|
        ss.source_files = 'TWSRIMProject/Classes/SRIMCommonHeaders/*.{h}'
    end
    
    s.subspec 'SRIMExtension' do |ss|
        ss.source_files = 'TWSRIMProject/Classes/SRIMExtension/*.{h,m}'
    end
    
    s.subspec 'SRIMNetworkManager' do |ss|
        ss.source_files = 'TWSRIMProject/Classes/SRIMNetworkManager/**/*.{h,m}'
        ss.dependency 'TWSRIMProject/SRIMCommonHeaders'
        ss.dependency 'TWSRIMProject/SRIMExtension'
        ss.dependency 'TWSRIMProject/TWSecurityUtil'
    end
    
    s.subspec 'SRIMNotification' do |ss|
        ss.source_files = 'TWSRIMProject/Classes/SRIMNotification/*.{h,m}'
        ss.dependency 'TWSRIMProject/SRIMCommonHeaders'
    end
    
    s.subspec 'SRIMClient' do |ss|
        ss.source_files = 'TWSRIMProject/Classes/SRIMClient/*.{h,m}'
        ss.dependency 'TWSRIMProject/SRIMNotification'
        ss.dependency 'TWSRIMProject/SRIMCommonHeaders'
        ss.dependency 'TWSRIMProject/SRIMNetworkManager'
    end
    
    s.subspec 'SRIMUI' do |ss|
        ss.source_files = 'TWSRIMProject/Classes/SRIMUI/*.{h,m}'
        ss.dependency 'TWSRIMProject/SRIMClient'
        ss.dependency 'TWSRIMProject/SRIMCommonHeaders'
        ss.dependency 'TWSRIMProject/SRIMNetworkManager'
        ss.dependency 'TWSRIMProject/SRIMExtension'
        ss.dependency 'TWSRIMProject/ZQAlertController'
    end
    
    s.subspec 'TWSecurityUtil' do |ss|
        ss.source_files = 'TWSRIMProject/Classes/TWSecurityUtil/*.{h,m}'
    end
    
    s.subspec 'ZQAlertController' do |ss|
        ss.source_files = 'TWSRIMProject/Classes/ZQAlertController/*.{h,m}'
    end
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'AFNetworking', '~> 3.0'
    s.dependency 'UITableView+FDTemplateLayoutCell', '1.4'
    s.dependency 'SocketRocket'
    s.dependency 'Masonry'
    s.dependency 'SDWebImage'
    s.dependency 'PINCache'
    s.dependency 'TTTAttributedLabel'
    s.dependency 'MJExtension'
    s.dependency 'MJRefresh'
#    s.dependency 'ZQAlertController', '2.0.0-alpha'
    
end
