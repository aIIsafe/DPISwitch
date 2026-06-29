// swift-tools-version: 5.9
// Package.swift — только для разрешения зависимостей.
// Проект собирается через xcodegen → DPISwitch.xcodeproj

import PackageDescription

let package = Package(
    name: "DPISwitch",
    platforms: [.iOS(.v17)],
    dependencies: [
        .package(url: "https://github.com/mIwr/SwByeDPI.git", from: "0.17.3")
    ],
    targets: [
        .target(
            name: "DPISwitch",
            dependencies: [
                .product(name: "SwByeDPI", package: "SwByeDPI"),
                .product(name: "ByeDPIKit", package: "SwByeDPI")
            ],
            path: "DPISwitch"
        )
    ]
)
