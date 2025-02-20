# react-native-trusted-device-v2

Visit [official website](https://fazpass.com) for more information about the product and see documentation at [online documentation](https://doc.fazpass.com) for more technical details.

## Minimum OS

Android 24, IOS 13.0

## Installation

For installation, please refer to these documentation:

Android: https://github.com/fazpass/seamless-documentation/blob/main/README.Android.md#installation <br>
IOS (Use Cocoapods Intallation): https://github.com/fazpass/seamless-documentation/blob/main/README.iOS.md#installation <br>

After the installation is finished, go back immediately to this documentation.

## Bridging between native SDK and React Native Application

To use native SDK on your react native application, you have to bridge it by writing native code in your native project, then import it in your react native project.

<details>

<summary>How to write native code in android</summary>

### Writing Native Code in Android

Make sure Fazpass SDK is installed correctly by importing the SDK in your android project. If there is no error, then continue reading.

1. Open your android project, then find your main application file (app/src/main/"java/kotlin"/<app_package>/MainApplication.kt). Then add FazpassPackage in getPackages() function:

```kotlin
class MainApplication : Application(), ReactApplication {

  override val reactNativeHost: ReactNativeHost =
      object : DefaultReactNativeHost(this) {
        override fun getPackages(): List<ReactPackage> =
            PackageList(this).packages.apply {
              // Packages that cannot be autolinked yet can be added manually here, for example:
              // add(MyReactNativePackage())

                // Add Fazpass Package
                add(FazpassPackage())
            }

        override fun getJSMainModuleName(): String = "index"

        override fun getUseDeveloperSupport(): Boolean = BuildConfig.DEBUG

        override val isNewArchEnabled: Boolean = BuildConfig.IS_NEW_ARCHITECTURE_ENABLED
        override val isHermesEnabled: Boolean = BuildConfig.IS_HERMES_ENABLED
      }

  override val reactHost: ReactHost
    get() = getDefaultReactHost(applicationContext, reactNativeHost)

  override fun onCreate() {
    super.onCreate()
    SoLoader.init(this, false)
    if (BuildConfig.IS_NEW_ARCHITECTURE_ENABLED) {
      // If you opted-in for the New Architecture, we load the native entry point for this app.
      load()
    }
  }
}
```

2. Create the FazpassPackage class:

```kotlin
class FazpassPackage: ReactPackage {

    private val fazpass = FazpassFactory.getInstance()

    override fun createNativeModules(context: ReactApplicationContext): MutableList<NativeModule> {
        fazpass.init(context.applicationContext, YOUR-PUBLIC-KEY.pub)
        return listOf(FazpassModule(context, fazpass), CrossDeviceModule(context, fazpass)).toMutableList()
    }

    override fun createViewManagers(p0: ReactApplicationContext): MutableList<ViewManager<View, ReactShadowNode<*>>> =
        mutableListOf()
}
```

3. Create the FazpassModule class:

```kotlin
class FazpassModule(context: ReactApplicationContext, private val fazpass: Fazpass): ReactContextBaseJavaModule(context) {

    override fun getName(): String = "TrustedDeviceV2"

    @ReactMethod
    fun generateMeta(accountIndex: Double, promise: Promise) {
        val activity = reactApplicationContext.currentActivity
        if (activity == null) {
            promise.reject(NullPointerException("Activity not found!"))
            return
        }

        UiThreadUtil.runOnUiThread {
            fazpass.generateMeta(activity, accountIndex.toInt()) { meta, e ->
                if (e != null) {
                    promise.reject(e.name)
                    return@generateMeta
                }

                promise.resolve(meta)
            }
        }
    }

    @ReactMethod
    fun generateNewSecretKey(promise: Promise) {
        fazpass.generateNewSecretKey(reactApplicationContext.applicationContext)
        promise.resolve(null)
    }

    @ReactMethod
    fun setSettings(accountIndex: Double, settingsString: String?, promise: Promise) {
        val settings = if (settingsString != null) FazpassSettings.fromString(settingsString) else null
        fazpass.setSettings(reactApplicationContext.applicationContext, accountIndex.toInt(), settings)
        promise.resolve(null)
    }

    @ReactMethod
    fun getSettings(accountIndex: Double, promise: Promise) {
        val settings = fazpass.getSettings(accountIndex.toInt())
        promise.resolve(settings?.toString())
    }

    @ReactMethod
    fun getCrossDeviceDataFromNotification(promise: Promise) {
        val activity = reactApplicationContext.currentActivity
        if (activity == null) {
            promise.reject(NullPointerException("Activity not found!"))
            return
        }

        val data = fazpass.getCrossDeviceDataFromNotification(activity.intent)
        val map = if (data != null) Arguments.makeNativeMap(data.toMap()) else null
        promise.resolve(map)
    }

    @ReactMethod
    fun getAppSignatures(promise: Promise) {
        val activity = reactApplicationContext.currentActivity
        if (activity == null) {
            promise.reject(NullPointerException("Activity not found!"))
            return
        }

        val signatures = fazpass.getAppSignatures(activity)
        val array = Arguments.createArray()
        signatures.forEach { item -> array.pushString(item) }
        promise.resolve(array)
    }
}
```

4. Create the CrossDeviceModule class:

```kotlin
class CrossDeviceModule(reactContext: ReactApplicationContext, fazpass: Fazpass): ReactContextBaseJavaModule(reactContext) {

    companion object {
        const val NAME = "CrossDevice"
    }

    override fun getName(): String = NAME

    private val streamInstance: CrossDeviceDataStream =
        fazpass.getCrossDeviceDataStreamInstance(reactApplicationContext.applicationContext)

    private var listenerCount = 0

    private fun sendEvent(reactContext: ReactContext, eventName: String, params: WritableMap?) {
        reactContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(eventName, params)
    }

    @ReactMethod
    fun addListener(eventName: String) {
        if (listenerCount == 0) {
            // Set up any upstream listeners or background tasks as necessary
            streamInstance.listen {
                sendEvent(
                    reactApplicationContext,
                    eventName,
                    Arguments.makeNativeMap(it.toMap())
                )
            }
        }

        listenerCount += 1
    }

    @ReactMethod
    fun removeListeners(count: Int) {
        listenerCount -= count
        if (listenerCount == 0) {
            streamInstance.close()
        }
    }
}
```

</details>

<details>

<summary>How to use written native code in react native</summary>

### Using Written Native Code in React Native

1. In your root project, create a fazpass module directory (modules/fazpass)
2. Create index.tsx file:

```ts
import { NativeModules, Platform } from 'react-native';
import { SensitiveData } from './sensitive-data.tsx';
import FazpassSettings, { FazpassSettingsBuilder } from './fazpass-settings.tsx';
import CrossDeviceDataStream from './cross-device-data-stream.tsx';
import CrossDeviceData from './cross-device-data.tsx';
import type FazpassInterface from './fazpass-interface.tsx';

const LINKING_ERROR =
  'The package \'react-native-trusted-device-v2\' doesn\'t seem to be linked. Make sure: \n\n' +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const TrustedDeviceV2 = NativeModules.TrustedDeviceV2
  ? NativeModules.TrustedDeviceV2
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

const CrossDevice = NativeModules.CrossDevice
  ? NativeModules.CrossDevice
  : new Proxy(
    {},
    {
      get() {
        throw new Error(LINKING_ERROR);
      },
    }
  );

export default class Fazpass implements FazpassInterface {

  static instance = new Fazpass();

  #getCrossDeviceDataStream: CrossDeviceDataStream;

  private constructor() {
    this.#getCrossDeviceDataStream = new CrossDeviceDataStream(CrossDevice);
  }

  generateMeta(accountIndex: number = -1): Promise<string> {
    return TrustedDeviceV2.generateMeta(accountIndex);
  }

  generateNewSecretKey(): Promise<void> {
    return TrustedDeviceV2.generateNewSecretKey();
  }

  setSettings(accountIndex: number, settings?: FazpassSettings | undefined): Promise<void> {
    return TrustedDeviceV2.setSettings(accountIndex, settings?.toString());
  }

  async getSettings(accountIndex: number): Promise<FazpassSettings | undefined> {
    const settingsString = await (TrustedDeviceV2.getSettings(accountIndex) as Promise<string | undefined>);
    return settingsString ? FazpassSettings.fromString(settingsString) : undefined;
  }

  getCrossDeviceDataStreamInstance(): CrossDeviceDataStream {
    return this.#getCrossDeviceDataStream;
  }

  async getCrossDeviceDataFromNotification(): Promise<CrossDeviceData | undefined> {
    const data = await (TrustedDeviceV2.getCrossDeviceRequestFromNotification() as Promise<any>);
    return data ? new CrossDeviceData(data) : undefined;
  }

  async getAppSignatures(): Promise<Array<string>> {
    if (Platform.OS === 'android') {
      return await TrustedDeviceV2.getAppSignatures();
    }

    return [];
  }
}

export { SensitiveData };
export { FazpassSettings, FazpassSettingsBuilder };
export { CrossDeviceData };
export { CrossDeviceDataStream };
```

3. Create fazpass-interface.tsx file:

```ts
import { CrossDeviceData, CrossDeviceDataStream, FazpassSettings } from '.';

export default interface FazpassInterface {

  /**
   * Retrieves application signatures.
   *
   * Only works in android. Will return empty list in iOS.
   */
  getAppSignatures(): Promise<Array<string> | undefined>;

  /**
   * Collects specific data according to settings and generate meta from it as Base64 string.
   *
   * You can use this meta to hit Fazpass API endpoint. Calling this method will automatically launch
   * local authentication (biometric / password). Any rules that have been set in method {@link Fazpass.setSettings()}
   * will be applied according to the `accountIndex` parameter.
   *
   * Throws any {@link FazpassException} if an error occurred.
   */
  generateMeta(accountIndex: number): Promise<string>;

  /**
   * Generates new secret key for high level biometric settings.
   *
   * Before generating meta with "High Level Biometric" settings, You have to generate secret key first by
   * calling this method. This secret key will be invalidated when there is a new biometric enrolled or all
   * biometric is cleared, which makes your active fazpass id to get revoked when you hit Fazpass Check API
   * using meta generated with "High Level Biometric" settings. When secret key has been invalidated, you have
   * to call this method to generate new secret key and enroll your device with Fazpass Enroll API to make
   * your device trusted again.
   *
   * Might throws exception when generating new secret key. Report this exception as a bug when that happens.
   */
  generateNewSecretKey(): Promise<void>;

  /**
   * Sets rules for data collection in{@link Fazpass.generateMeta()} method.
   *
   * Sets which sensitive information is collected in {@link Fazpass.generateMeta()} method
   * and applies them according to `accountIndex` parameter. Accepts {@link FazpassSettings} for `settings`
   * parameter. Settings will be stored in SharedPreferences (UserDefaults in iOS), so it will
   * not persist when application data is cleared / application is uninstalled. To delete
   * stored settings, pass undefined on `settings` parameter.
   */
  setSettings(accountIndex: number, settings?: FazpassSettings): Promise<void>;

  /**
   * Retrieves the rules that has been set in {@link Fazpass.setSettings()} method.
   *
   * Retrieves a stored {@link FazpassSettings} object based on the `accountIndex` parameter.
   * Returns null if there is no stored settings for this `accountIndex`.
   */
  getSettings(accountIndex: number): Promise<FazpassSettings | undefined>;

  /**
   * Retrieves the stream instance of cross device notification data.
   */
  getCrossDeviceDataStreamInstance(): CrossDeviceDataStream;

  /**
   * Retrieves a {@link CrossDeviceData} object obtained from notification.
   *
   * If user launched the application from notification, this method will return data
   * contained in that notification. Will return undefined if user launched the application
   * normally.
   */
  getCrossDeviceDataFromNotification(): Promise<CrossDeviceData | undefined>;

}
```

4. Create sensitive-data.tsx file:

```ts
/**
 * Sensitive data requires the user to grant certain permissions so they could be collected.
 * All sensitive data collection is disabled by default, which means you have to enable each of
 * them manually. Until their required permissions are granted, sensitive data won't
 * be collected even if they have been enabled. Required permissions for each sensitive data have been
 * listed in this member's documentation.
 */
export enum SensitiveData {
    /**
     * AVAILABILITY: ANDROID, IOS
     *
     * To enable location on android, make sure you ask user for these permissions:
     * - android.permission.ACCESS_COARSE_LOCATION or android.permission.ACCESS_FINE_LOCATION
     * - android.permission.FOREGROUND_SERVICE
     *
     * To enable location on ios, declare NSLocationWhenInUseUsageDescription in your Info.plist file
     */
    location = 'location',

    /**
     * AVAILABILITY: IOS
     *
     * To enable vpn on ios, add Network Extensions capability in your project.
     */
    vpn = 'vpn',

    /**
     * AVAILABILITY: ANDROID
     *
     * To enable sim numbers and operators on android, make sure you ask user for these permissions:
     * - android.permission.READ_PHONE_NUMBERS
     * - android.permission.READ_PHONE_STATE
     */
    simOperatorsAndNumbers = 'simOperatorsAndNumbers'
}
```

5. Create fazpass-settings.tsx file:

```ts
import { SensitiveData } from './sensitive-data';

/**
 * An object to be used as settings for {@link Fazpass.setSettings()} method.
 *
 * To construct this object, use it's builder class.
 *
 * @see {@link FazpassSettingsBuilder} for implementation details.
 */
export default class FazpassSettings {
    readonly sensitiveData: SensitiveData[];
    readonly isBiometricLevelHigh: boolean;

    private constructor(sensitiveData: SensitiveData[],  isBiometricLevelHigh: boolean) {
        this.sensitiveData = sensitiveData;
        this.isBiometricLevelHigh = isBiometricLevelHigh;
    }

    static fromBuilder(builder: FazpassSettingsBuilder): FazpassSettings {
        return new FazpassSettings(builder.sensitiveData, builder.isBiometricLevelHigh)
    }

    static fromString(settingsString: string): FazpassSettings {
        const splitter = settingsString.split(";");
        const sensitiveData = splitter[0]!.split(",")
            .filter((it) => it != "")
            .map<SensitiveData>((it) => SensitiveData[it as keyof typeof SensitiveData]);
        const isBiometricLevelHigh = splitter[1] === 'true';

        return new FazpassSettings(sensitiveData ?? [], isBiometricLevelHigh);
    }

    toString(): string {
        return this.sensitiveData.map<string>((it) => it).join(',') + ';' + (this.isBiometricLevelHigh === true ? 'true' : 'false');
    }
}

/**
 * A builder to create {@link FazpassSettings} object.
 *
 * To enable specific sensitive data collection, call `enableSelectedSensitiveData` method
 * and specify which data you want to collect.
 * Otherwise call `disableSelectedSensitiveData` method
 * and specify which data you don't want to collect.
 * To set biometric level to high, call `setBiometricLevelToHigh`. Otherwise call
 * `setBiometricLevelToLow`.
 * To create {@link FazpassSettings} object with this builder configuration, use {@link FazpassSettings.fromBuilder()} method.
 * ```typescript
 * // create builder
 * const builder: FazpassSettingsBuilder = FazpassSettingsBuilder()
 *   .enableSelectedSensitiveData([SensitiveData.location])
 *   .setBiometricLevelToHigh();
 *
 * // construct FazpassSettings with the builder
 * const settings: FazpassSettings = FazpassSettings.fromBuilder(builder);
 * ```
 *
 * You can also copy settings from {@link FazpassSettings} by using the secondary constructor.
 * ```typescript
 * const builder: FazpassSettingsBuilder =
 *   FazpassSettingsBuilder(settings);
 * ```
 */
export class FazpassSettingsBuilder {
   #sensitiveData: SensitiveData[];
   #isBiometricLevelHigh: boolean;

   get sensitiveData() {
       return this.#sensitiveData.map((v) => v);
   }
   get isBiometricLevelHigh() { 
       return this.#isBiometricLevelHigh;
   }

   constructor(settings?: FazpassSettings) {
       this.#sensitiveData = settings ? [...settings.sensitiveData] : [];
       this.#isBiometricLevelHigh = settings?.isBiometricLevelHigh ?? false;
   }

   enableSelectedSensitiveData(sensitiveData: SensitiveData[]): this  {
       for (const data in sensitiveData) {
           const key = data as keyof typeof SensitiveData;
           if (this.#sensitiveData.includes(SensitiveData[key])) {
               continue;
           } else {
               this.#sensitiveData.push(SensitiveData[key]);
           }
       }
       return this;
   }

   disableSelectedSensitiveData(sensitiveData: SensitiveData[]): this {
       for (const data in sensitiveData) {
           const key = data as keyof typeof SensitiveData;
           const willRemoveIndex = this.#sensitiveData.indexOf(SensitiveData[key], 0);
           if (willRemoveIndex > -1) {
               this.#sensitiveData.splice(willRemoveIndex, 1);
           } else {
               continue;
           }
       }
       return this;
   }

   setBiometricLevelToHigh(): this {
       this.#isBiometricLevelHigh = true;
       return this;
   }

   setBiometricLevelToLow(): this {
       this.#isBiometricLevelHigh = false;
       return this;
   }
}
```

6. Create cross-device-data.tsx file:

```ts
/**
 * An object containing data from cross device notification data.
 *
 * This object is only used as data retrieved from {@link Fazpass.getCrossDeviceDataStreamInstance()}
 * and {@link Fazpass.getCrossDeviceDataFromNotification()}.
 */
export default class CrossDeviceData {
    readonly merchantAppId : string;
    readonly deviceReceive : string;
    readonly deviceRequest : string;
    readonly deviceIdReceive : string;
    readonly deviceIdRequest : string;
    readonly expired : string;
    readonly status : string;
    readonly notificationId: string | null;
    readonly action: string | null;

    constructor(data: any) {
        this.merchantAppId = data.merchant_app_id as string;
        this.deviceReceive = data.device_receive as string;
        this.deviceRequest = data.device_request as string;
        this.deviceIdReceive = data.device_id_receive as string;
        this.deviceIdRequest = data.device_id_request as string;
        this.expired = data.expired as string;
        this.status = data.status as string;
        this.notificationId = data.notification_id as string | null;
        this.action = data.action as string | null;
    }
}
```

7. Create cross-device-data-stream.tsx file:

```ts
import { NativeEventEmitter, type EmitterSubscription } from 'react-native';
import CrossDeviceData from './cross-device-data';

/**
 * An instance acquired from {@link Fazpass.getCrossDeviceDataStreamInstance()} to start listening for
 * incoming cross device request notification.
 *
 * call `listen` method to start listening, and call `close` to stop.
 */
export default class CrossDeviceDataStream {
    private static eventType = 'com.fazpass.trusted-device-cd';

    #emitter: NativeEventEmitter;
    #listener: EmitterSubscription | undefined;

    constructor(module: any) {
        this.#emitter = new NativeEventEmitter(module);
    }

    listen(callback: (request: CrossDeviceData) => void) {
        if (this.#listener !== undefined) {
            this.close();
        }
        this.#listener = this.#emitter.addListener(CrossDeviceDataStream.eventType, (event) => {
            const data = new CrossDeviceData(event);
            callback(data);
        });
    }

    close() {
        this.#listener?.remove();
        this.#listener = undefined;
    }
}
```

</details>

## Getting Started

Before using this package, make sure to contact us first to get a public key and an FCM App ID (iOS only).

This package main purpose is to generate meta which you can use to communicate with Fazpass rest API. But
before calling generate meta method, you have to initialize it first by calling this method:

```js
Fazpass.instance.init(
    androidAssetName: 'AndroidAssetName.pub',
    iosAssetName: 'iosAssetName',
    iosFcmAppId: 'iosFcmAppId'
);
```

### Getting Started on Android

Setup your public key:

1. Open your android folder, then go to app/src/main/assets/ (if assets folder doesn't exist, create a new one)
2. Put the public key in this folder

#### Retrieving your application signatures

When creating a new merchant app in Fazpass Dashboard, there is a "signature" input.

Here's how to get this signature:

Add this line of code in your main screen React.useEffect() method

```js
Fazpass.instance.getAppSignatures().then((value) => print("APPSGN: $value"));
```

Then build apk for release. Launch it while your device is still connected and debugging in your pc.
Open logcat and query for `APPSGN`. It's value is an array, will look something like this: `[Gw+6AWbS7l7JQ7Umb1zcs1aNA8M=]`.
If item is more than one, pick just one of them. Copy the signature `Gw+6AWbS7l7JQ7Umb1zcs1aNA8M=` and fill the signature
of your merchant app with this value.

After you uploaded your apk or abb into the playstore, download your app from the playstore then check your app's signatures again.
If it's different, make sure to update the signature value of your merchant app.

### Getting Started on iOS

Setup your public key:

1. In your XCode project, open Assets.
2. Add new asset as Data Set.
3. Reference your public key into this asset.
4. Name your asset.

Then, you have to declare NSFaceIDUsageDescription in your Info.plist file to be able to generate meta, because generating meta requires user to do biometry authentication.

Then, in your AppDelegate.swift file in your XCode project, override your `didReceiveRemoteNotification` function.

```swift
override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
  
  // add this line
  Fazpass.shared.getCrossDeviceDataFromNotification(userInfo: userInfo)

  completionHandler(UIBackgroundFetchResult.newData)
}
```

## Usage

Call `generateMeta()` method to launch local authentication (biometric / password) and generate meta
if local authentication is success. Otherwise throws `BiometricAuthFailedError`.

```js
try {
  let meta = await Fazpass.instance.generateMeta();
} catch (e) {
  // on error...
}
```
