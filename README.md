**We have decided to temporarily archive this repository and place it into maintenance mode. This decision allows us to focus our efforts and resources on advancing our core product line. During this period, active development and the addition of new features will be paused. We value the contributions of the community and appreciate your understanding as we prioritize our main projects. We look forward to resuming development in the future and will keep you updated on any changes.**

## Solana and Bitcoin

Solana and Bitcoin work like the `@magic-ext/solana` and `@magic-ext/bitcoin` packages in magic-js. They need a version of [magic-ios](https://github.com/magiclabs/magic-ios) that has `Magic(apiKey:extensions:)`.

Add the package with Swift Package Manager, then add the products you need to your target: `MagicExt-Solana`, `MagicExt-Bitcoin`, or both.

```swift
.package(url: "https://github.com/magiclabs/magic-ios-ext.git", from: "X.Y.Z") // the first release with MagicExt-Solana and MagicExt-Bitcoin
```

Turn them on by passing a configuration when you create `Magic`:

```swift
import MagicSDK
import MagicExt_Solana
import MagicExt_Bitcoin

Magic.shared = Magic(
    apiKey: "YOUR_PUBLISHABLE_API_KEY",
    extensions: [
        SolanaConfiguration(rpcUrl: "https://api.devnet.solana.com"),
        BitcoinConfiguration(rpcUrl: "https://blockstream.info/testnet/api", network: "testnet")
    ]
)
```

`Magic.shared.solana` and `Magic.shared.bitcoin` are `nil` until you pass the matching configuration. The user must be logged in first.

Both extensions have these methods. Each one has a completion-handler version and a PromiseKit version.

- `getPublicAddress` returns the user's address on that chain.
- `revealPrivateKey` shows Magic's UI for exporting the key. The key never reaches your app.

```swift
Magic.shared.solana?.getPublicAddress { response in
    print(response.result ?? response.error?.localizedDescription ?? "")
}
```

### Sign a Solana message

```swift
// A String is signed as UTF-8. You can also pass Data.
Magic.shared.solana?.signMessage("Sign in to Example") { response in
    // response.result is the 64-byte ed25519 signature, as Data
}
```

### Sign a Solana transaction

The SDK has no Solana dependency, so you give it the serialized transaction bytes and say which kind it is. Build the bytes with a Solana library or by hand. In `@solana/web3.js` this is `Transaction.serialize({ requireAllSignatures: false })` for a legacy transaction, or `VersionedTransaction.serialize()` for a version 0 transaction.

- `.legacy` is for a legacy `Transaction`.
- `.v0` is for a `VersionedTransaction`.

```swift
let serialized: Data = ... // the serialized, unsigned transaction

Magic.shared.solana?.signTransaction(serialized, type: .legacy) { response in
    if let signed = response.result {
        let rawTransaction: Data = signed.rawTransaction
        // Send rawTransaction to a Solana node, for example with sendRawTransaction.
    } else if let error = response.error {
        print(error.localizedDescription)
    }
}
```

Use `type: .v0` for a version 0 transaction.

### Partly sign a Solana transaction

Use `partialSignTransaction` when other people also have to sign, such as a fee payer. It adds the user's signature and leaves the other slots empty.

```swift
// serializeConfig only applies to legacy transactions, as in magic-js.
let config = SolanaSerializeConfig(requireAllSignatures: false, verifySignatures: false)

Magic.shared.solana?.partialSignTransaction(serialized, type: .legacy, serializeConfig: config) { response in
    let partlySigned = response.result?.rawTransaction
    // Pass it on to the next signer.
}
```

### Sign a Bitcoin transaction

You choose the inputs (the UTXOs to spend), the outputs and the change. Magic signs the result and returns a transaction that is ready to broadcast.

- Amounts are in BTC, not satoshis, with at most eight decimal places.
- `txNum` is the output index (vout) of the UTXO in its source transaction.
- Each input needs its `value`, because the signature covers the amount being spent.
- The fee is whatever is left after the outputs. Total outputs must not be more than total inputs. There is no minimum or maximum fee, so check it yourself.

```swift
let inputs = [
    BitcoinTransactionInput(txid: "<txid of the UTXO>", txNum: 0, value: 0.001)
]
let outputs = [
    BitcoinTransactionOutput(address: "<destination address>", value: 0.0009) // 0.0001 BTC fee
]

Magic.shared.bitcoin?.signTransaction(inputs: inputs, outputs: outputs) { response in
    if let signed = response.result {
        print(signed.signedTransaction) // hex, ready to broadcast
        print(signed.transactionHash)   // txid
    } else if let error = response.error {
        print(error.localizedDescription)
    }
}
```

Work out fees and change in whole satoshis, then convert to BTC for the call. Signing does not mean the network will accept the transaction.

### Before you broadcast

The signed result comes back through Magic's relayer. Decode `rawTransaction` or `signedTransaction` and check the amounts and addresses before you send it.

---

# MagicExt-OAuth
[![CI Status](https://img.shields.io/travis/Ethella/MagicExt-OAuth.svg?style=flat)](https://travis-ci.org/Ethella/MagicExt-OAuth)
[![Version](https://img.shields.io/cocoapods/v/MagicExt-OAuth.svg?style=flat)](https://cocoapods.org/pods/MagicExt-OAuth)
[![License](https://img.shields.io/cocoapods/l/MagicExt-OAuth.svg?style=flat)](https://cocoapods.org/pods/MagicExt-OAuth)
[![Platform](https://img.shields.io/cocoapods/p/MagicExt-OAuth.svg?style=flat)](https://cocoapods.org/pods/MagicExt-OAuth)

Cocoapods
---
## Set up the local development env
1. To start the demo app with local development SDK, download following projects
```bash
# demo app
$ git clone https://github.com/magiclabs/magic-ios-demo
# ios SDK
$ git clone https://github.com/magiclabs/magic-ios
$ git clone https://github.com/magiclabs/magic-ios-ext
```

2. To enable the demo use the local development SDK. Navigate to `magic-ios-demo/Podfile` and edit the following lines.
   This will make pod file install local dependencies instead of the ones distributed.

```ruby 
# Distributed Library on Cocoapods
# pod 'MagicSDK', '~> 3.0'
# pod 'MagicExt-OAuth', '~> 1.0'
    
#   Local development library
pod 'MagicSDK', :path => '../magic-ios/MagicSDK.podspec'
pod 'MagicExt-OAuth', :path => '../magic-ios-ext/MagicExt-OAuth.podspec'
```

```bash
$ cd /YOUR/PATH/TO/magic-ios-demo

# Install dependencies
$ pod install
```

3. Open `/YOUR/PATH/TO/magic-ios-demo/magic-ios-demo.xcworkspace` with XCode and try it out!

---

