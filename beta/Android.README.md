# Android

Visit [official website](https://keypaz.com) for more information about the product.

# Android OS

Minimum: Android 21
Maximum: Android 34

# Installation

## Add the dependency in your app-level build.gradle (*project*/app/build.gradle)

```gradle
dependencies {
	// Another dependencies...
	implementation 'com.keypaz:device-intelligence-android:1.0.2-alpha.1'
}
```

Then sync project with gradle files.

# Getting Started

Before using this SDK, make sure to get the merchant key from Keypaz Dashboard.

## Usage

Before analyzing, you have to initialize the sdk once.

```kotlin
// get fazpass instance
val keypaz = KeypazFactory.getInstance()

keypaz.init(this, "YOUR_MERCHANT_KEY")
```

Then call the analyze method like this.

```kotlin
keypaz.setup(this).analyze { result ->
  if (result.hasException) {
    val exception = result.exception
    // handle error here
    return
  }

  // your activity id
  val activityId = result.activityId
}
```

> [!CAUTION]
> You have to call analyze method using `FragmentActivity` OR `AppCompatActivity` as context.
> Otherwise your app might crash.

> [!TIP]
> If you use android jetpack compose for UI builder, it's okay to change `ComponentActivity` to one of these activities.
> Because `AppCompatActivity` extends `FragmentActivity`, which extends `ComponentActivity`.
> [See the reference here.](https://stackoverflow.com/a/67364675)
