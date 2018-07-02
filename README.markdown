# CancelForPromiseKit Alamofire Extensions

[![badge-docs](https://dougzilla32.github.io/CPKAlamofire/api/badge.svg)](https://dougzilla32.github.io/CPKAlamofire/api/) [![Build Status](https://travis-ci.org/dougzilla32/CPKAlamofire.svg?branch=master)](https://travis-ci.org/dougzilla32/CPKAlamofire)

This project adds cancellable promises to [PromiseKit's Alamofire Extension].

This project supports Swift 3.1, 3.2, 4.0 and 4.1.

Here is the [Jazzy](https://github.com/realm/jazzy) generated [CancelForPromiseKit Alamofire Extensions API documentation](https://dougzilla32.github.io/CPKAlamofire/api/).

## Usage

```swift
let context = Alamofire.request("https://httpbin.org/get", method: .GET)
    .responseJSONCC().then { json, rsp in
        // 
    }.catch(policy: .allErrors) { error in
        //…
    }.cancelContext

//…

context.cancel()
```

Of course, the whole point in promises is composability, so:

```swift
func login() -> CancellablePromise<User> {
    let q = DispatchQueue.global()
    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    return firstly { in
        Alamofire.request(url, method: .get).responseDataCC()
    }.map(on: q) { data, rsp in
        convertToUser(data)
    }.ensure {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

let context = firstly {
    login()
}.done { user in
    //…
}.catch(policy: .allErrorsExceptCancellation) { error in
   UIAlertController(/*…*/).show() 
}.cancelContext

//…

context.cancel()
```

## CococaPods

```ruby
# Podfile
pod 'CancelForPromiseKit/Alamofire', '~> 1.0'
```

```swift
// `.swift` files
import PromiseKit
import CancelForPromiseKit
import Alamofire
import CPKAlamofire
```

## Carthage

```ruby
github "CancelForPromiseKit/Alamofire-" ~> 1.0
```

The extensions are built into their own framework:

```swift
// `.swift` files
import PromiseKit
import CancelForPromiseKit
import Alamofire
import CPKAlamofire
```

To build with Carthage on versions of Swift prior to 4.1, set the 'Carthage' flag in your target's Build settings at the following location. This is necessary to properly import the PMKAlamofire module, which is only defined for Carthage:
    
    TARGETS -> [Your target name]:
        'Swift Compiler - Custom Flags' -> 'Active Compilation Conditions' -> 'Debug'
        'Swift Compiler - Custom Flags' -> 'Active Compilation Conditions' -> 'Release'

## SwiftPM

```swift
let package = Package(
    dependencies: [
        .Target(url: "https://github.com/dougzilla32/CancelForPromiseKit-Alamofire", majorVersion: 1)
    ]
)
```

[PromiseKit's Alamofire Extension]: https://github.com/PromiseKit/Alamofire-
