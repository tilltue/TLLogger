// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "TLLogger",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "TLLogger",
            targets: ["TLLogger"]
        ),
    ],
    targets: [
        .target(
            name: "TLLogger",
            path: "Sources"
        )
    ]
)
