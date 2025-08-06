# React Native

Visit [official website](https://keypaz.com) for more information about the product.

# OS Version

- Android
  - Minimum: 24
  - Maximum: 35

- iOS
  - Minimum: 14.0

# Installation

Run this command in your root project:

`$ npm install device-intelligence-react`

# Getting Started

Before using this SDK, make sure to get the merchant key and Merchant App ID from Keypaz Dashboard.

## Usage

Before analyzing, you have to initialize the sdk once.

<details>
<summary>Typescript</summary>
 
```typescript
import KeypazFactory from 'device-intelligence-react'

// get keypaz instance
let keypaz = KeypazFactory.getInstance()

keypaz.initialize("YOUR_MERCHANT_KEY", "YOUR_MERCHANT_APP_ID")
```
 
</details>

Then call the analyze method like this.

<details>
<summary>Typescript</summary>
 
```typescript
import {AnalyzeResult, KeypazError} from 'device-intelligence-react'

let result: AnalyzeResult | undefined
try {
  result = await keypaz.setup().analyze()

  // your activity id
  const activityId = result.activityId
} catch (e) {
  if (e instanceof KeypazError) {
    const exception = e
    // handle error here
  }
}
```
 
</details>
