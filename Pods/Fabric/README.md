Fabric
======
This repository contains CocoaPod for Fabric (https://fabric.io).

### Current versions:
* Fabric.framework v1.2.8
* Crashlytics.framework v3.0.11
* TwitterKit.framework v1.8.1
* TwitterCore.framework v1.8.1
* DigitsKit.framework v1.8.1
* MoPub.framework v3.8.0

## Installing
1. Use Fabric Mac app to configure the components you need (required for this pod to work).
2. Remove all frameworks from project which were added by Fabric app.
3. Add pods to Podfile

  ```ruby
pod 'Fabric', '~> 1.3.2' # required
pod 'Fabric/Crashlytics', '~> 1.3.2'
pod 'Fabric/MoPub', '~> 1.3.2'
pod 'Fabric/Twitter', '~> 1.3.2'
```

  Then run `pod install`.

4. Change the path in Run Script Build command to:

  `./Pods/Fabric/Fabric.framework/run YOUR_API_KEY YOUR_BUILD_SECRET`

5. Ensure that modules are enabled in project settings

![Project Settings](http://i.imgur.com/frp4NiM.png)

## Known issues

1. If you declare a dependency on a subspec but don't `#import` a corresponding module for that subspec your project might fail to build.
2. Using `Fabric/MoPub` or `Fabric/Twitter` subpecs result in project failing to build if `use_frameworks!` is set.
