# BuzzNative-SDK-iOS Integration Guide

1. [Requirements](#requirements)
2. [Integration](#integration)
3. [Usage](#usage)
    1. [Swift](#swift)
    2. [Objective-C](#objective-c)

## Requirements
- iOS 8 or higher
- Both Swift and Objective-C are supported

## Integration

In your `Build Phase` setting,
1. Add `BuzzNative.framework` to `Embed Frameworks`.
2. Add the script below to a new `Run Script`.
```sh
APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK; do
FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"

EXTRACTED_ARCHS=()

for ARCH in $ARCHS; do
echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
done

echo "Merging extracted architectures: ${ARCHS}"
lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
rm "${EXTRACTED_ARCHS[@]}"

echo "Replacing original executable with thinned version"
rm "$FRAMEWORK_EXECUTABLE_PATH"
mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"

done
```

> Note: We provide SDK as an universal framework which is compatible with both device and simulator. This script strips out unnecessary architectures with your current build target. 

3. Add the script below to a new `Run Script`
```sh
pushd ${TARGET_BUILD_DIR}/${PRODUCT_NAME}.app/Frameworks/BuzzNative.framework/Frameworks
for EACH in *.framework; do
echo "-- signing ${EACH}"
/usr/bin/codesign --force --deep --sign "${EXPANDED_CODE_SIGN_IDENTITY}" --preserve-metadata=identifier,entitlements --timestamp=none $EACH
done
popd
```

> Note: This script is required to code sign nested frameworks inside SDK.


## Usage

### Swift

#### Step 1: Initialize BuzzNative

In AppDelegate's `application:didFinishLaunchingWithOptions`
```swift
BuzzNative.configure(environment: "test", logging: true)
```

#### Step 2: Prepare BNAdView

1. Add a BNAdView to your view.
2. Design your BNAdView in your Storyboard or Interface Builder. Or by code.

#### Step 3A: Fetch and Render Ad with Block

```swift
let adLoader = BNAdLoader(unitId: "your_unit_id")
adLoader.loadAd(
  userProfile: BNUserProfile(birthday: birthday, gender: .male), // optional 
  location: BNLocation(latitude: 37.53457, longitude: 128.23423) // optional
  ) { [weak self] (ad, error) in
    if let ad = ad {
      self?.adView.delegate = self // optional
      self?.adView.renderAd(ad)
    } else {
      // Handle error
    }
}
```

#### Step 3B: Fetch and Render Ad with Delegate

```swift
let adLoader = BNAdLoader(unitId: "your_unit_id", delegate: self)
adLoader.loadAd(
  userProfile: BNUserProfile(birthday: birthday, gender: .male), // optional 
  location: BNLocation(latitude: 37.53457, longitude: 128.23423) // optional
)

// BNAdLoaderDelegate
func adLoader(_ adLoader: BNAdLoader, didReceiveAd ad: BNAd) {
  adView.delegate = self // optional
  adView.renderAd(ad)
}

func adLoader(_adLoader: BNAdLoader, didFailWithError error: Error?) {
  // Handle error
}
```

> Note: Use `adView.isPresentingAd()` to check BNAdView is currently presenting an ad or not

#### Step 4: Handle ad events (optional)

```swift
func adViewDidImpressed(adView: BNAdView) {
  // Impressed!
}

func adViewDidClicked(adView: BNAdView) {
  // Clicked!
}
```
&nbsp;
### Objective-C

#### Step 1: Initialize BuzzNative

In AppDelegate's `application:didFinishLaunchingWithOptions`

```objc
[BuzzNative configureWithEnvironment:BNEnvTest logging:YES];
```
#### Step 2: Prepare BNAdView

1. Add a BNAdView to your view.
2. Design your BNAdView in your Storyboard or Interface Builder. Or by code.

#### Step 3A: Fetch and Render Ad with Block

```objc
BNAdLoader *adLoader = [[BNAdLoader alloc] initWithUnitId:@"your_unit_id" delegate:nil];
BNUserProfile *userProfile = [[BNUserProfile alloc] initWithBirthday:birthday gender:BNUserGenderMale];
BNLocation *location = [[BNLocation alloc] initWithLatitude: 37.53457 longitude: 128.23423];

__weak YourClass *weakSelf = self;
[adLoader 
  loadAdWithUserProfile:userProfile // or nil
  location:location // or nil
  completion:^(BNAd * _Nullable ad, NSError * _Nullable error) {
    if (ad) {
        [weakSelf.adView renderAd:ad];
    } else {
      // Handle error
    }
}];
```

#### Step 3B: Fetch and Render Ad with Delegate

```objc
BNAdLoader *adLoader = [[BNAdLoader alloc] initWithUnitId:@"your_unit_id" delegate:self];
BNUserProfile *userProfile = [[BNUserProfile alloc] initWithBirthday:birthday gender:BNUserGenderMale];
BNLocation *location = [[BNLocation alloc] initWithLatitude: 37.53457 longitude: 128.23423];

[adLoader loadAdWithUserProfile:userProfile location:location completion:nil];


// BNAdLoaderDelegate
- (void)adLoader:(BNAdLoader *)adLoader didReceiveAd:(BNAd *)ad {
    [self.adView renderAd:ad];
}

- (void)adLoader:(BNAdLoader *)adLoader didFailWithError:(NSError *)error {
  // Handler error
}

```

> Note: Use `[adView isPresentingAd]` to check BNAdView is currently presenting an ad or not

#### Step 4: Handle ad events (optional)

```objc
// BNAdViewDelegate
- (void)adViewDidImpressed:(BNAdView *)adView {
  // Impressed!
}

- (void)adViewDidClicked:(BNAdView *)adView {
  // Clicked
}
```
