# MagicExt-OAuth
[![CI Status](https://img.shields.io/travis/Ethella/MagicExt-OAuth.svg?style=flat)](https://travis-ci.org/Ethella/MagicExt-OAuth)
[![Version](https://img.shields.io/cocoapods/v/MagicExt-OAuth.svg?style=flat)](https://cocoapods.org/pods/MagicExt-OAuth)
[![License](https://img.shields.io/cocoapods/l/MagicExt-OAuth.svg?style=flat)](https://cocoapods.org/pods/MagicExt-OAuth)
[![Platform](https://img.shields.io/cocoapods/p/MagicExt-OAuth.svg?style=flat)](https://cocoapods.org/pods/MagicExt-OAuth)

Cocoapods
---
## Set up the local development env
1. To start the demo app with local development SDK, download following projects
```bash
# demo app
$ git clone https://github.com/magiclabs/magic-ios-demo
# ios SDK
$ git clone https://github.com/magiclabs/magic-ios
$ git clone https://github.com/magiclabs/magic-ios-ext
```

2. To enable the demo use the local development SDK. Navigate to `magic-ios-demo/Podfile` and edit the following lines.
   This will make pod file install local dependencies instead of the ones distributed.

```ruby 
# Distributed Library on Cocoapods
# pod 'MagicSDK', '~> 3.0'
# pod 'MagicExt-OAuth', '~> 1.0'
    
#   Local development library
pod 'MagicSDK', :path => '../magic-ios/MagicSDK.podspec'
pod 'MagicExt-OAuth', :path => '../magic-ios-ext/MagicExt-OAuth.podspec'
```

```bash
$ cd /YOUR/PATH/TO/magic-ios-demo

# Install dependencies
$ pod install
```

3. Open `/YOUR/PATH/TO/magic-ios-demo/magic-ios-demo.xcworkspace` with XCode and try it out!

---

