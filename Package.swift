// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CardParts",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "CardParts", targets: ["CardParts"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", from: "4.0.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "CardParts",
            dependencies: [
                .byName(name: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .byName(name: "RxDataSources"),
                .byName(name: "RxGesture")
            ],
            path: "CardParts",
            resources: [
                .process("Assets/icons.xcassets")
            ]
        ),
        .testTarget(
            name: "CardPartsTests",
            dependencies: ["CardParts"],
            path: "Example/Tests"
        )
    ]
)
