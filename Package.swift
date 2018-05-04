import PackageDescription

let package = Package(
    name: "CPKAlamofire",
    dependencies: [
        .Package(url: "https://github.com/dougzilla32/CancellablePromiseKit", majorVersion: 1),
        .Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4)
    ],
    exclude: ["Tests"]
)
