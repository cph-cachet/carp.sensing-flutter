// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "battery_plus", path: "/Users/arata/.pub-cache/hosted/pub.dev/battery_plus-6.2.1/ios/battery_plus"),
        .package(name: "device_info_plus", path: "/Users/arata/.pub-cache/hosted/pub.dev/device_info_plus-11.3.3/ios/device_info_plus"),
        .package(name: "flutter_local_notifications", path: "/Users/arata/.pub-cache/hosted/pub.dev/flutter_local_notifications-19.0.0/ios/flutter_local_notifications"),
        .package(name: "flutter_timezone", path: "/Users/arata/.pub-cache/hosted/pub.dev/flutter_timezone-4.1.0/ios/flutter_timezone"),
        .package(name: "package_info_plus", path: "/Users/arata/.pub-cache/hosted/pub.dev/package_info_plus-8.3.0/ios/package_info_plus"),
        .package(name: "path_provider_foundation", path: "/Users/arata/.pub-cache/hosted/pub.dev/path_provider_foundation-2.4.1/darwin/path_provider_foundation"),
        .package(name: "sensors_plus", path: "/Users/arata/.pub-cache/hosted/pub.dev/sensors_plus-6.1.1/ios/sensors_plus"),
        .package(name: "shared_preferences_foundation", path: "/Users/arata/.pub-cache/hosted/pub.dev/shared_preferences_foundation-2.5.4/darwin/shared_preferences_foundation"),
        .package(name: "sqflite_darwin", path: "/Users/arata/.pub-cache/hosted/pub.dev/sqflite_darwin-2.4.2/darwin/sqflite_darwin")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "battery-plus", package: "battery_plus"),
                .product(name: "device-info-plus", package: "device_info_plus"),
                .product(name: "flutter-local-notifications", package: "flutter_local_notifications"),
                .product(name: "flutter-timezone", package: "flutter_timezone"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "path-provider-foundation", package: "path_provider_foundation"),
                .product(name: "sensors-plus", package: "sensors_plus"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "sqflite-darwin", package: "sqflite_darwin")
            ]
        )
    ]
)
