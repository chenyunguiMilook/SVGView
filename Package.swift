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
    targets: [
    	.target(
    		name: "SVGView",
            path: "Source",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "SVGViewTests",
            dependencies: ["SVGView"],
            path: "SVGViewTests",
            resources: [.copy("w3c")]
        )
    ],
    swiftLanguageVersions: [.v5]
)
