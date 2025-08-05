# Flutter

Visit [official website](https://keypaz.com) for more information about the product.

# OS Version

- Android
  - Minimum: 24
  - Maximum: 35

- iOS
  - Minimum: 14.0

# Installation

Run this command in your root project:

`$ flutter pub add device_intelligence_flutter`

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```yaml
dependencies:
  device_intelligence_flutter: ^<version>
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

Now in your Dart code, you can use:

```dart
import 'package:device_intelligence_flutter/device_intelligence_flutter.dart';
```

# Getting Started

Before using this SDK, make sure to get the merchant key and Merchant App ID from Keypaz Dashboard.

## Usage

Before analyzing, you have to initialize the sdk once.

<details>
<summary>Dart</summary>
 
```dart
// get keypaz instance
final keypaz = KeypazFactory.getInstance();

keypaz.initialize("YOUR_MERCHANT_KEY", "YOUR_MERCHANT_APP_ID");
```
 
</details>

Then call the analyze method like this.

<details>
<summary>Dart</summary>
 
```dart
AnalyzeResult? result = null;
try {
  result = await keypaz.setup().analyze();

  // your activity id
  final activityId = result.activityId;
} on KeypazException catch (e) {
  final exception = e;
  // handle error here
}
```
 
</details>
