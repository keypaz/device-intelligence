# iOS

Visit [official website](https://keypaz.com) for more information about the product.

# iOS OS

Minimum: iOS 14

# Installation

You can add this package into your project using swift package manager (SPM) or Cocoapods.

## Using Swift Package Manager (SPM)

1. In XCode, click File > Add Packages...
2. Enter this package URL: https://github.com/keypaz/keypaz-device-intelligence-ios.git
3. Click Add Package

## Using Cocoapods

1. Open your podfile
2. Add this line in your target app: `pod 'DeviceIntelligenceIOS'`
3. run `pod install`

# Getting Started

Before using this SDK, make sure to get the merchant key and Merchant App ID from Keypaz Dashboard.

## Usage

Before analyzing, you have to initialize the sdk once.

<details>
<summary>Swift</summary>
 
```swift
// get keypaz instance
let keypaz = KeypazFactory.getInstance()

keypaz.initialize("YOUR_MERCHANT_KEY", "YOUR_MERCHANT_APP_ID")
```
 
</details>

Then call the analyze method like this.

<details>
<summary>Swift</summary>
 
```swift
keypaz.setup().analyze { result in
  if (result.hasError) {
    let error = result.error
    // handle error here
    return
  }

  // your activity id
  let activityId = result.activityId
}
```
 
</details>
