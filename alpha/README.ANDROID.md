# Android

Visit [official website](https://fazpass.com) for more information about the product and see documentation at [online documentation](https://doc.fazpass.com) for more technical details.

# Android OS

Minimum: Android 21
Maximum: Android 34

# Installation

## Add the dependency in your app-level build.gradle (*project*/app/build.gradle)

```gradle
dependencies {
	// Another dependencies...
	implementation 'com.keypaz:device-intelligence-android:1.0.0'
}
```

### Version tag

| Version 		|  Release Date 	|
| -- 			| --	 		|
| 1.0.0 (latest) 	| Nov 5   	|

## 4. Sync project with gradle files

### Getting Started

Before using this SDK, make sure to get the public key from Fazpass Dashboard's merchant app.
Then, put the public key into the assets folder.

1. Open your android root project, then go to app/src/main/assets/ (if assets folder doesn't exist, create a new one)
2. Put the public key in this folder

### Retrieving your application signatures

When creating a new merchant app in Fazpass Dashboard, there is a "signature" input.

Here's how to get this signature:

Put this line of code in your main activity
```kotlin
// get fazpass instance
val fazpass = FazpassFactory.getInstance()

Log.i("APPSGN", fazpass.getAppSignatures(this).toString())
```
Then build apk for release. Launch it while your device is still connected and debugging in your pc.
Open logcat and query for `APPSGN`. It's value is an array. it will looks like this: `[Gw+6AWbS7l7JQ7Umb1zcs1aNA8M=]`.
If there is more than one signature, pick the very first one. Copy the signature `Gw+6AWbS7l7JQ7Umb1zcs1aNA8M=` and fill the signature 
of your merchant app with this value.

After you uploaded your apk or abb into the playstore, download your app from the playstore then check your app's signatures again.
If it's different, make sure to update the signature value of your merchant app.

## Usage

This package main purpose is to generate meta which you can use to communicate with Fazpass rest API. But
before calling generate meta method, you have to initialize it first by calling this method:

```kotlin
// get fazpass instance
val fazpass = FazpassFactory.getInstance()

fazpass.init(this, "YOUR_PUBLIC_KEY_ASSET_NAME")
```

Call `meta().generate()` method to generate meta.

> [!CAUTION]
> You have to call generate meta method using `FragmentActivity` OR `AppCompatActivity` as context.
> Otherwise your app might crash.

```kotlin
import androidx.fragment.app.FragmentActivity
// OR import androidx.appcompat.app.AppCompatActivity

class Activity : FragmentActivity() {
// OR class Activity : AppCompatActivity() {

	// your activity fields & methods...

	fun generateMeta() {
		fazpass.meta().generate { meta, exception ->
		    if (exception != null) {
				TODO()
				return
			}
			println(meta)
		}
	}
}
```

> [!TIP]
> If you use android jetpack compose for UI builder, it's okay to change `ComponentActivity` to one of these activities.
> Because `AppCompatActivity` extends `FragmentActivity`, which extends `ComponentActivity`.
> [See the reference here.](https://stackoverflow.com/a/67364675)
