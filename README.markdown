# CancelForPromiseKit Alamofire Extensions ![Build Status]

This project adds cancellable promises to [PromiseKit's Alamofire Extension].

This project supports Swift 3.1, 3.2, 4.0 and 4.1.

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

## SwiftPM

```swift
let package = Package(
    dependencies: [
        .Target(url: "https://github.com/dougzilla32/CancelForPromiseKit-Alamofire", majorVersion: 1)
    ]
)
```


[Build Status]: https://travis-ci.org/dougzilla32/CancelForPromiseKit-Alamofire.svg?branch=master
[PromiseKit's Alamofire Extension]: https://github.com/PromiseKit/Alamofire-
