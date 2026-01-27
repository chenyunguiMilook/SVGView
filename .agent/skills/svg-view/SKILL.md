---
name: svg-view
description: High-performance SVG parsing and object model library for Swift, supporting path data, CSS styles, and XML serialization.
---

# SVGView Skill

SVGView is a Swift-native library for parsing and manipulating SVG data. It converts XML into a traversable object graph, allowing for easy integration with SwiftUI or any graphics engine.

## Core Modules

### 1. Parser Engine
- **`SVGParser`**: Main entry point for parsing strings, data, or URLs.
- **`DOMParser`**: Foundation XML-based parser mapping to internal nodes.
- **`CSSParser`**: Resolves embedded and inline styles into node attributes.
- **`PathReader`**: Parses complex path data string commands into `AppBezierPath`.

### 2. Node Model
- **`SVGNode`**: Base node with transform, opacity, and visibility.
- **`SVGGroup`**: Represents `<g>` or `<svg>` tags, supporting nested hierarchies.
- **`SVGShape`**: Base for specific geometric shapes (Rect, Circle, Ellipse, Polygon).
- **`SVGImage`**: Supports embedded and external bitmap images.

### 3. Rendering Context
- **`SVGContext`**: Maintains PPI, font settings, and ID-based resource lookup.
- **`SVGIndex`**: Optimizes access to gradients, patterns, and masks.

### 4. Serialization
- **`XMLSerializer`**: Converts the object model back to standard SVG XML for export.

## Common Tasks

### Parsing SVG Data
```swift
import SVGView

let svgString = "<svg>...</svg>"
if let group = SVGParser.parse(xml: svgString) {
    // Process the node tree
}
```

### Accessing Shape Data
```swift
if let shape = node as? SVGShape {
    let path = shape.path
    // Use path for rendering or hit-testing
}
```

### Serializing to XML
```swift
let xmlString = group.serialize()
```

## Build & Verify

- **macOS 15**: `swift build`
- **macCatalyst 17**: `xcodebuild -scheme SVGView -destination "generic/platform=macOS,variant=Mac Catalyst" build`
- **Run Tests**: `swift test`

## Best Practices
- **Memory Management**: Use `SVGContext` to manage resource lifecycles during parsing.
- **Precision**: Prefer `Double` for coordinate calculations to maintain SVG accuracy.
- **Performance**: Use ID lookup in `SVGIndex` rather than recursive tree searches where possible.
