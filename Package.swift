// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SwiftBlogs",
    platforms: [
       .macOS(.v13)
    ],
    products: [
        .library(name: "SwiftBlogs", targets: ["SwiftBlogs"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        // 🐘 Fluent driver for MySQL/MariaDB.
        .package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.0.0"),
        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "4.3.0"),
        .package(url: "https://github.com/vapor/leaf-kit.git", from: "1.0.0"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
    ],
    targets: [
        // Core blog engine library — imported by consumer projects via SPM
        .target(
            name: "SwiftBlogs",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),
                .product(name: "Leaf", package: "leaf"),
                .product(name: "LeafKit", package: "leaf-kit"),
                .product(name: "Vapor", package: "vapor"),
            ],
            resources: [
                .copy("Resources/Views"),
                .copy("Resources/Public"),
            ],
            swiftSettings: swiftSettings
        ),
        // Development server — not part of the library, used for local development only
        .executableTarget(
            name: "Run",
            dependencies: [
                .target(name: "SwiftBlogs"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SwiftBlogsTests",
            dependencies: [
                .target(name: "SwiftBlogs"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
