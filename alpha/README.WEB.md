# web-trusted-device-v2

## Installation

Load the script in your html like this:

```html
<script src="http://seamless-web-notification.fazpass.com/bundle.js" defer onload="onloadFazpass()"></script>

<script>
    function onloadFazpass() {
        // get fazpass instance after script has been loaded
        let fazpass = window.Fazpass;
    }
</script>
```
## Getting Started

Before using this SDK, make sure to contact us first to get a public key.

This package main purpose is to generate meta which you can use to communicate with Fazpass rest API. But before calling generate meta method, you have to initialize it first by calling this method:

```js
fazpass.init(
    'YOUR_PUBLIC_KEY_FILE', 
    'YOUR_SERVICE_WORKER_FILE'
)
```

Then you have to ask user for notification permission. Note: you should spawn notifications in response to a user gesture.

```html
<!-- Copied examples from: https://developer.mozilla.org/en-US/docs/Web/API/Notification/requestPermission_static -->

<button onclick="askNotificationPermission()">Allow Notification</button>

<script>
    function askNotificationPermission() {
        if (!("Notification" in window)) {
            // Check if the browser supports notifications
            alert("This browser does not support desktop notification");
        } else if (Notification.permission === "granted") {
            // Check whether notification permissions have already been granted;
            // if so, create a notification
            const notification = new Notification("Hi there!");
            // …
        } else if (Notification.permission !== "denied") {
            // We need to ask the user for permission
            Notification.requestPermission().then((permission) => {
            // If the user accepts, let's create a notification
            if (permission === "granted") {
                const notification = new Notification("Hi there!");
                // …
            }
            });

            // At last, if the user has denied notifications, and you want to be respectful there is no need to bother them anymore.
        }
    }
</script>
```

### Serving required files in your website

To initialize this SDK correctly, you have to serve these required files:

1. Your public key
2. Fazpass service worker

You can get the public key file by downloading it from your fazpass dashboard, then change it's extension from *.pub* to *.txt*. For the Fazpass service worker file, you can download it here: [Fazpass Service Worker]("") `TODO: Put the download link here`

Once you have obtained these required files, the easiest way to serve them is to put them in your static folder. Then `init()` method will look like this:

```js
fazpass.init(
    '/files/public-key.txt', // If your public key is served at https://www.yourdomain.com/files/public-key.txt
    '/sw/fazpass-service-worker.js' // If your fazpass service worker is served at https://www.yourdomain.com/sw/my-service-worker.js
)
```

## Usage

Call `generateMeta()` method to generate meta.

```js
// synchronous example
fazpass.generateMeta()
    .then((meta) => {
        console.log(meta)
    })
    .catch((err) => {
        if (err instanceof fazpass.UninitializedError) {
          console.error("UninitializedError: "+err.message)
        }
        if (err instanceof fazpass.PublicKeyNotExistError) {
          console.error("PublicKeyNotExistError: "+err.message)
        }
        if (err instanceof fazpass.EncryptionError) {
          console.error("EncryptionError: "+err.message)
        }
    })

// asynchronous example
try {
    let meta = await fazpass.generateMeta()
    console.log(meta)
} catch (err) {
    // handle on error...
}
```
