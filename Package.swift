import PackageDescription

let package = Package(
    name: "CPKAlamofire",
    dependencies: [
        .Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4),
        .Package(url: "https://github.com/PromiseKit/Alamofire-", majorVersion: 3),
        .Package(url: "https://github.com/dougzilla32/CancelForPromiseKit", majorVersion: 1)
    ],
    exclude: ["Tests"]
)
