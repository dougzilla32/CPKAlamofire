// swift-tools-version:4.0

// Cannot current support SPM because PMKAlamofire's outdated SPM config file causes this error:
//   error: dependency graph is unresolvable; found these conflicting requirements:
//
//   Dependencies:
//     https://github.com/PromiseKit/Alamofire.git @ 3.2.0..<4.0.0

//import PackageDescription
//
//let pkg = Package(name: "CPKAlamofire")
//pkg.products = [
//    .library(name: "CPKAlamofire", targets: ["CPKAlamofire"]),
//]
//pkg.dependencies = [
//    .package(url: "https://github.com/dougzilla32/CancelForPromiseKit.git", from: "1.1.0"),
//    .package(url: "https://github.com/PromiseKit/Alamofire.git", from: "3.2.0")
////    .package(url: "https://github.com/AliSoftware/OHHTTPStubs", from: "6.0.0")
//]
//
//let cpkaf: Target = .target(name: "CPKAlamofire")
//cpkaf.path = "Sources"
//cpkaf.dependencies = ["CancelForPromiseKit", "PMKAlamofire"]
//
//pkg.swiftLanguageVersions = [3, 4]
//pkg.targets = [
//    cpkaf
//// Cannot run tests because OHHTTPStubs does not currently support SPM
////    .testTarget(name: "CPKAFTests", dependencies: ["CPKFoundation", "OHHTTPStubs"], path: "Tests"),
//]
