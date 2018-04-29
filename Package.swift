// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "STSProject",
    products: [
        .library(
            name: "STSLibrary",
            type: .dynamic,
            targets: ["STSLibrary"]
        )
    ],
    dependencies: [
        //example:
        // .package(url: "https://github.com/ReactiveX/RxSwift.git", "4.0.0" ..< "5.0.0")
    ],
    targets: [
        .target(
            name: "STSLibrary",
            dependencies: []),
        .target(
            name: "STSApplication",
            dependencies: ["STSLibrary"]),
        .testTarget(
            name: "STSLibraryTests",
            dependencies: ["STSLibrary"]),
    ]
)
