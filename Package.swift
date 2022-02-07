// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "UUIDKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "UUIDKit", targets: ["UUIDKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0" ..< "3.0.0"),
    ],
    targets: [
        .target(name: "UUIDKit", dependencies: [
            .product(name: "Crypto", package: "swift-crypto"),
        ]),
        .testTarget(name: "UUIDKitTests", dependencies: [
            .target(name: "UUIDKit"),
        ]),
    ]
)
