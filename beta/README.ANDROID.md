# Android

Visit [official website](https://keypaz.com) for more information about the product.

# Android OS

Minimum: Android 21
Maximum: Android 35

# Installation

## Add the dependency in your app-level build.gradle (*project*/app/build.gradle)

```gradle
dependencies {
	// Another dependencies...
	implementation 'com.keypaz:device-intelligence-android:1.0.5'
}
```

Then sync project with gradle files.

# Getting Started

Before using this SDK, make sure to get the merchant key and Merchant App ID from Keypaz Dashboard.

## Usage

Before analyzing, you have to initialize the sdk once.

<details>
<summary>Kotlin</summary>
 
```kotlin
// get keypaz instance
val keypaz = KeypazFactory.getInstance()

keypaz.initialize(this, "YOUR_MERCHANT_KEY", "YOUR_MERCHANT_APP_ID")
```
 
</details>

<details>
<summary>Java</summary>

```java
// get keypaz instance
Keypaz keypaz = KeypazFactory.getInstance();

keypaz.initialize(this, "YOUR_MERCHANT_KEY", "YOUR_MERCHANT_APP_ID");
```
 
</details>

Then call the analyze method like this.

<details>
<summary>Kotlin</summary>
 
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
 
</details>

<details>
<summary>Java</summary>

```java
keypaz.setup(this).analyze(result -> {
	if (result.getHasException()) {
		KeypazException exception = result.getException();
		// handle error here
		return null;
	}

	// your activity id
	String activityId = result.getActivityId();

	return null;
});
```
 
</details>

> [!CAUTION]
> You have to call analyze method using `FragmentActivity` OR `AppCompatActivity` as context.
> Otherwise your app might crash.

> [!TIP]
> If you use android jetpack compose for UI builder, it's okay to change `ComponentActivity` to one of these activities.
> Because `AppCompatActivity` extends `FragmentActivity`, which extends `ComponentActivity`.
> [See the reference here.](https://stackoverflow.com/a/67364675)
