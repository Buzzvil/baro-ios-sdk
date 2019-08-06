# BARO-iOS-SDK Integration Guide

1. [Requirements](#requirements)
2. [Integration](#integration)
3. [Usage](#usage)
    1. [Swift](#swift)
    2. [Objective-C](#objective-c)
4. [Mediation](#mediation)

## Requirements
- iOS 8 or higher
- Both Swift and Objective-C are supported

## Integration
1. Add this line to your Podfile.
```
pod 'BARO', '~> 2.3.0'
```

2. Add following properties to your `info.plist` to allow ads to be served via HTTP on iOS 9 or higher.
```
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```


## Usage

### Swift

#### Step 1: Initialize BARO

In AppDelegate's `application:didFinishLaunchingWithOptions`
```swift
import BARO

BARO.configure(BAROEnvProduction, mediationAdapterClasses: [], logging: true)
```

#### Step 2: Prepare BAROAdView

1. Add a BAROAdView to your view.
2. Design your BAROAdView in your Storyboard or Interface Builder. Or by code.
3. Be sure that `titleLabel`, `descriptionLabel`, `ctaButton`, `imageView`, `iconImageView`, `adchoiceButton` components in BAROAdView are connected properly.

![Image of BAROAdView] (https://github.com/Buzzvil/baro-ios-sdk/blob/master/BAROAdView_example.png)

#### Step 3: Fetch and Render Ad

```swift
let adLoader = BAROAdLoader(unitId: "your_unit_id", preloadEnabled: false)
adLoader.loadAd(
  with: BAROUserProfile(birthday: birthday, gender: BAROUserGenderMale), // optional 
  location: BAROLocation(latitude: 37.53457, longitude: 128.23423) // optional
  ) { [weak self] (ad, error) in
    if let ad = ad {
      self?.adView.delegate = self // optional
      self?.adView.renderAd(ad)
    } else {
      // Handle error
    }
}
```

> Note: Use `adView.isPresentingAd()` to check BAROAdView is currently presenting an ad or not

#### Step 4: Handle ad events (optional)

```swift
// BAROAdViewDelegate
func adViewDidImpressed(adView: BAROAdView) {
  // Impressed!
}

func adViewDidClicked(adView: BAROAdView) {
  // Clicked!
}
```
&nbsp;
### Objective-C

#### Step 1: Initialize BARO

In AppDelegate's `application:didFinishLaunchingWithOptions`

```objc
#import <BARO/BARO.h>

[BARO configure:BAROEnvProduction mediationAdapterClasses:@[] logging:YES];
```
#### Step 2: Prepare BAROAdView

1. Add a BAROAdView to your view.
2. Design your BAROAdView in your Storyboard or Interface Builder. Or by code.
3. Be sure that `titleLabel`, `descriptionLabel`, `ctaButton`, `imageView`, `iconImageView`, `adchoiceButton` components in BAROAdView are connected properly.

![Image of BAROAdView] (https://github.com/Buzzvil/baro-ios-sdk/blob/master/BAROAdView_example.png)

#### Step 3: Fetch and Render Ad

```objc
BAROAdLoader *adLoader = [[BAROAdLoader alloc] initWithUnitId:@"your_unit_id" preloadEnabled: NO];
BAROUserProfile *userProfile = [[BAROUserProfile alloc] initWithBirthday:birthday gender:BAROUserGenderMale];
BAROLocation *location = [[BAROLocation alloc] initWithLatitude: 37.53457 longitude: 128.23423];

__weak YourClass *weakSelf = self;
[adLoader 
  loadAdWithUserProfile:userProfile // or nil
  location:location // or nil
  completion:^(BAROAd * _Nullable ad, NSError * _Nullable error) {
    if (ad) {
        [weakSelf.adView renderAd:ad];
    } else {
      // Handle error
    }
}];
```
> Note: Use `[adView isPresentingAd]` to check BAROAdView is currently presenting an ad or not

#### Step 4: Handle ad events (optional)

```objc
// BAROAdViewDelegate
- (void)adViewDidImpressed:(BAROAdView *)adView {
  // Impressed!
}

- (void)adViewDidClicked:(BAROAdView *)adView {
  // Clicked
}
```

## Mediation
1. Add the following lines to your Podfile to enable mediation.

  - AdMob: `pod 'BARO/AdmobMediation'`
  - MoPub: `pod 'BARO/MopubMediation'`
  - Baidu: `pod 'BARO/BaiduMediation'`

2. In your AppDelegate, pass desired mediation adapters when initializing BARO.

Swift
```swift
import BAROAdmobMediation
import BAROBaiduMediation
import BAROMopubMediation

BARO.configure(BAROEnvProduction, mediationAdapterClasses: [BAROAdmobMediationAdapter.self, BAROMopubMediationAdapter.self, BAROBaiduMediationAdapter.self], logging: true)
```

Objective-C
```objc
#import <BAROAdmobMediation/BAROAdmobMediation.h>
#import <BAROBaiduMediation/BAROBaiduMediation.h>
#import <BAROMopubMediation/BAROMopubMediation.h>

[BARO configure:BAROEnvProduction mediationAdapterClasses:@[BAROAdmobMediationAdapter.class, BAROBaiduMediationAdapter.class, BAROMopubMediationAdapter.class] logging:YES];
```

