# TWSecurityUtil

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TWSecurityUtil is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
source 'https://www.example.com/app/iOS/SRIMProjectSpec'
target 'TestDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TestDemo
  pod 'TWSecurityUtil'

end
```

## Author

addcnos

## Usage

```objc
// 1.配置
TWSecurityConfig *config = [[TWSecurityConfig alloc] init];
config.appId = @"换成自己的appid";
config.sercret = @"换成自己的sercret";
config.refreshTime = 10; // 设置有效期和定时刷新时间，不设置，则默认是3600秒
config.isDebug = YES; // 开启调试模式
self.securityConfig = config;

// 2.进行签名，获取添加了签名数据的字典
NSMutableDictionary *flagDic = [NSMutableDictionary dictionary];
NSDictionary *params = [SRIMSecurityHandler getSignatureParameters:@{@"name": @"addcnos"}
                                                               url:@"https://www.baidu.com"
                                                       isSignature:YES
                                                            method:TWSRequestGet
                                                           flagDic:flagDic
                                                            config:config];
NSLog(@"params -- %@", params);
NSLog(@"flagDic -- %@", flagDic);

// 3.定时刷新
[TWCoreSecurityUtil startRefreshTimeTimerWithConfig:config refreshHandler:^{
    NSLog(@"获取时间戳");
    // 请求接口，拿到时间戳后，调用 cacheSingntureServiceTime 更新时间戳
    // [SRIMSecurityHandler refreshSignatureServiceTime:@"请求服务器时间戳的地址" config:config];
}];
```

Handler 与业务相关，下面以591的处理方式为例。

\- 如果使用者也是一样的处理逻辑，则可以直接拿去使用

\- 如果不同，则自定义Handler



## License

TWSecurityUtil is available under the MIT license. See the LICENSE file for more info.
