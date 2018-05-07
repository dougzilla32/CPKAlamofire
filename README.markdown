# CancelForPromiseKit Alamofire Extensions ![Build Status]

This project adds promises to [Alamofire](https://github.com/Alamofire/Alamofire).

This project supports Swift 3.1, 3.2, 4.0 and 4.1.

## Usage

```swift
let context = CancelContext()
Alamofire.request("https://httpbin.org/get", method: .GET)
    .responseJSON(cancel: context).then { json, rsp in
        // 
    }.catch(policy: .allErrors) { error in
        //…
    }

//…

context.cancel()
```

Of course, the whole point in promises is composability, so:

```swift
func login(cancel context: CancelContext) -> Promise<User> {
    let q = DispatchQueue.global()
    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    return firstly { in
        Alamofire.request(url, method: .get).responseData(cancel: context)
    }.map(on: q) { data, rsp in
        convertToUser(data)
    }.ensure {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

let context = CancelContext()
firstly {
    login(cancel: context)
}.done { user in
    //…
}.catch(policy: .allErrorsExceptCancellation) { error in
   UIAlertController(/*…*/).show() 
}
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
        .Target(url: "https://github.com/CancelForPromiseKit/Alamofire", majorVersion: 1)
    ]
)
```


[Build Status]: https://travis-ci.org/CancelForPromiseKit/Alamofire.svg?branch=master
