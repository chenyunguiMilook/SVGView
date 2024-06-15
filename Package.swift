// swift-tools-version: 5.9
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
        .package(url: "git@github.com:chenyunguiMilook/CommonKit.git", from: "0.2.26"),
    ],
    targets: [
    	.target(
    		name: "SVGView",
            dependencies: ["CommonKit"],
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
