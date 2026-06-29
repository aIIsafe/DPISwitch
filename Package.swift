// swift-tools-version: 5.9
// Package.swift
// DPISwitch
//
// ВНИМАНИЕ: Этот файл используется ТОЛЬКО для загрузки зависимостей.
// Само приложение создаётся как Xcode Project (.xcodeproj).
// Инструкции по настройке в README.md.

import PackageDescription

let package = Package(
    name: "DPISwitch",
    platforms: [
        .iOS(.v15)   // Xcode 13 / macOS Big Sur / iMac 2013
    ],
    dependencies: [
        // SwByeDPI — Swift wrapper для byedpi (ByeDPIKit + SwByeDPI модули)
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
