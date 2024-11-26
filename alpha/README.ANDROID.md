# Android

Visit [official website](https://fazpass.com) for more information about the product and see documentation at [online documentation](https://doc.fazpass.com) for more technical details.

# Android OS

Minimum: Android 21
Maximum: Android 34

# Installation

## 1. Add Jitpack auth token in your gradle properties (*project*/gradle.properties)

```properties
# Project-wide Gradle settings.
# ...

# Add this at the bottom
fazpassAuthToken={{AUTH_TOKEN}}
```

## 2. Add Jitpack repo in your gradle repositories

If your gradle use buildscript syntax, add Jitpack repo in your root-level build.gradle (*project*/build.gradle):
```gradle
buildscript {
	//...
}

allprojects {
	repositories {
		// Another repo...

	        maven { 
	            url 'https://jitpack.io'
	            credentials { username fazpassAuthToken }
	        }
	}
}
```
If your gradle use plugin syntax, add Jitpack repo in your settings.gradle (*project*/settings.gradle):
```gradle
pluginManagement {
    repositories {
        // Another repo...
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        // Another repo...

        maven { 
            url 'https://jitpack.io'
            credentials { username fazpassAuthToken }
        }
    }
}
```

## 3. Add the dependency in your app-level build.gradle (*project*/app/build.gradle)

```gradle
dependencies {
	// Another dependencies...
	implementation 'com.github.fazpass-sdk:android-trusted-device-v2:Tag'
}
```

### Version tag

| Version 	| Tag 			| Release Date 	|
| -- 		| --	 		| --		|
| 2.1 (latest) 	| bengal-v2  		| Nov 5   	|
| 2.0	 	| bengal-v1  		| Nov 1   	|

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

Call `generateMeta()` method to automatically launch local authentication (biometric / password) and meta will be generated if authentication is success. 
Otherwise `BiometricAuthError` exception will occurs.

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
		fazpass.generateMeta(
      this@Activity,
      accountIndex = -1, 
      biometricAuth = true // set to false if you don't want to popup biometric
    ) { meta, exception ->
		    when (exception) {
		        is BiometricAuthError -> TODO()
		        is BiometricUnavailableError -> TODO()
		        is BiometricNoneEnrolledError -> TODO()
		        is BiometricSecurityUpdateRequiredError -> TODO()
		        is BiometricUnsupportedError -> TODO()
		        is EncryptionException -> TODO()
		        is PublicKeyNotExistException -> TODO()
		        is UninitializedException -> TODO()
		        null -> { 
		            print(meta) 
		        }
		    }
		}
	}
}
```

> [!TIP]
> If you use android jetpack compose for UI builder, it's okay to change `ComponentActivity` to one of these activities.
> Because `AppCompatActivity` extends `FragmentActivity`, which extends `ComponentActivity`.
> [See the reference here.](https://stackoverflow.com/a/67364675)