// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SVGView",
	platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .macCatalyst(.v17)
    ],
    products: [
    	.library(
    		name: "SVGView", 
    		targets: ["SVGView"]
    	)
    ],
    dependencies: [
        .package(url: "git@github.com:chenyunguiMilook/CoreKit.git", from: "1.0.7"),
    ],
    targets: [
    	.target(
    		name: "SVGView",
            dependencies: ["CoreKit"],
            path: "Source",
            exclude: ["Info.plist"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=complete")]
        ),
        .testTarget(
            name: "SVGViewTests",
            dependencies: ["SVGView"],
            path: "SVGViewTests",
            resources: [.copy("w3c")]
        )
    ]
)
