# ios-trusted-device-v2

Visit [official website](https://fazpass.com) for more information about the product and see documentation at [online documentation](https://doc.fazpass.com) for more technical details.

## Minimum OS

iOS 13.0

## Installation

You can add this package into your project using swift package manager (SPM) or Cocoapods. Make sure you have prepared the access token by contacting Fazpass.

### Using Swift Package

1. Open Xcode, then open Xcode settings (Xcode -> Settings...)
2. In Accounts, press the + button on the bottom left, then pick GitHub
3. Fill the Account field with 'fazpass-sdk', then fill the Token field with the access token
4. Click Sign In
5. After github source control account is added successfully, close settings window. Then click File > Add Packages...
6. Enter this package URL: https://github.com/fazpass-sdk/ios-trusted-device-v2.git
7. If there is a prompt to login, pick the github account you just added
8. Click Add Package

### Using Cocoapods

1. Open terminal in your project directory
2. Run `pod repo add ios-trusted-device-v2 https://fazpass-sdk@github.com/fazpass-sdk/ios-trusted-device-v2.git`
3. If asked for credentials, use 'fazpass-sdk' as username, then use the access token as password
4. Then in your Podfile, add 'ios-trusted-device-v2' as a dependency pod in your target:

```Podfile
pod 'ios-trusted-device-v2', :git => 'https://github.com/fazpass-sdk/ios-trusted-device-v2.git'
```

## Getting Started

Before using this SDK, make sure to get the public key from Fazpass Dashboard's merchant app. Then, reference the public key in the Assets.

1. In your Xcode project, open Assets.
2. Add new asset as Data Set.
3. Reference your public key into this asset.
4. Name your asset.

Then, you have to declare NSFaceIDUsageDescription in your Info.plist file to be able to generate meta, because 
generating meta requires user to do biometry authentication.

![Xcode add capabilities in target app](xcode_capabilities.jpg)

## Usage

This package main purpose is to generate meta which you can use to communicate with Fazpass rest API. But
before calling generate meta method, you have to initialize it first by calling this method in your app delegate `didFinishLaunchingWithOptions`:
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // Initialize fazpass
    Fazpass.shared.`init`(
        publicAssetName: "YOUR_PUBLIC_KEY_ASSET_NAME",
        application: application
    )
    
    return true
}
```

Call `generateMeta()` method to automatically launch local authentication (biometric / password). 
If authentication is success, meta will be generated. Otherwise `biometricAuthFailed` error will occurs.

```swift
Fazpass.shared.generateMeta { meta, fazpassError in 
    guard let error = fazpassError else {
        print(meta)
    }
    
    switch (error) {
    case .biometricNoneEnrolled:
        // code...
    case .biometricAuthFailed:
        // code...
    case .biometricNotAvailable(let message):
        // code...
    case .biometricNotInteractive:
        // code...
    case .encryptionError(let message):
        // code...
    case .publicKeyNotExist:
        // code...
    case .uninitialized:
        // code...
    }
}
```
