// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SVGView",
	platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .macCatalyst(.v16)
    ],
    products: [
    	.library(
    		name: "SVGView", 
    		targets: ["SVGView"]
    	)
    ],
    dependencies: [
        .package(url: "git@github.com:chenyunguiMilook/CommonKit.git", from: "0.1.47"),
    ],
    targets: [
    	.target(
    		name: "SVGView",
            dependencies: ["CommonKit"],
            path: "Source",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "SVGViewTests",
            dependencies: ["SVGView"],
            path: "SVGViewTests",
            resources: [.copy("w3c")]
        )
    ]
)
