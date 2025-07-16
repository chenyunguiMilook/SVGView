// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SVGView",
	platforms: [
        .iOS(.v17),
        //.macOS(.v15),
        .macCatalyst(.v17)
    ],
    products: [
    	.library(
    		name: "SVGView", 
    		targets: ["SVGView"]
    	)
    ],
    dependencies: [
        .package(url: "git@github.com:chenyunguiMilook/PrimeKit.git", from: "0.0.13"),
        .package(url: "git@github.com:chenyunguiMilook/RenderKit.git", from: "0.0.11"),
    ],
    targets: [
    	.target(
    		name: "SVGView",
            dependencies: ["PrimeKit", "RenderKit"],
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
