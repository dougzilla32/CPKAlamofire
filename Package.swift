import PackageDescription

let package = Package(
    name: "CPKAlamofire",
    dependencies: [
        .Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4),
        .Package(url: "https://github.com/PromiseKit/Alamofire-.git", majorVersion: 3, minor: 2),
        .Package(url: "https://github.com/dougzilla32/CancelForPromiseKit.git", majorVersion: 1, minor: 1)
    ],
    exclude: ["Tests"]
)
