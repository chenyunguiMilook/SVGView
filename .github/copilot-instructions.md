# Copilot instructions for SVGView

This file gives concise, actionable guidance for AI coding agents working in this repo.

- **Big picture:** SVGView parses SVG XML into a Swift object graph and exposes it as SwiftUI views. Parsing flows: `DOMParser` -> `SVGParser` -> element-specific `SVGElementParser`s -> `SVGNode` tree. See `Source/Parser/SVG/SVGParser.swift` for the top-level entry points (`parse(contentsOf:)`, `parse(data:)`, `parse(xml:)`).

- **Core components:**
  - `Source/Parser/SVG/` : parsing logic and per-element parsers (e.g. `SVGPathParser`, `SVGImageParser`).
  - `Source/Model/Nodes/` : runtime node model (`SVGNode`, `SVGGroup`, shapes). `SVGNode` uses `@Published` properties and `updateParentNode(_:)` for parent-child wiring. See `Source/Model/Nodes/SVGNode.swift`.
  - `Source/Parser/SVG/Settings/` : runtime settings (`SVGSettings.swift`, `SVGScreen.swift`) and link resolution (`SVGLinker`).
  - `Source/Serialization/Serializer.swift` : text serialization used by tests (note: file contains older/commented code — confirm current serializer implementation if editing serialization behavior).
  - `SVGViewTests/` : integration-style tests compare serialized parse results to W3C reference files (see `SVGViewTests/BaseTestCase.swift` for `compareToReference` usage).

- **Extension points & patterns:**
  - Element parser dispatch is a static map in `SVGParser.parsers` keyed by tag name; to add new element support, implement `SVGElementParser` and register it in that map.
  - Style resolution merges XML attributes, inline `style` attribute, and CSS via `SVGIndex.cssStyle(for:)` — see `SVGParser.getStyleAttributes` for current merging logic.
  - `SVGSettings.linkIfNeeded(to:)` returns a settings instance with an `SVGURLLinker` when parsing from a URL; prefer passing `SVGSettings` through parse calls to control linking, logging, font size and ppi.

- **Build / test / debug commands:**
  - Open in Xcode: use `SVGView.xcodeproj` or `SVGView.xcworkspace` (workspace exists).
  - Swift Package Manager (if used): `swift build` and `swift test` from repo root (Package.swift present).
  - Run tests in Xcode: select the `SVGViewTests` scheme and run. Tests run by loading W3C SVG files from `SVGViewTests/w3c/*` and comparing serialized output.

- **Project-specific conventions to follow in code changes:**
  - Prefer immutable `SVGSettings` passed through parse calls (use `linkIfNeeded(to:)` rather than mutating global state).
  - Node state is observable (`@Published`); changing visual properties (opacity, transform, etc.) is done on `SVGNode` instances directly to be picked up by SwiftUI.
  - Keep parsers side-effect minimal; element parsing constructs `SVGNode` instances and depends on parent context (`SVGContext`) for inherited attributes.

- **Files to reference when implementing features or fixes:**
  - Parser entry points: `Source/Parser/SVG/SVGParser.swift`
  - Context & indexing: `Source/Parser/SVG/SVGContext.swift`, `Source/Parser/SVG/SVGIndex.swift`
  - Node model: `Source/Model/Nodes/SVGNode.swift`, `SVGGroup.swift`, `SVGShape.swift`
  - Settings/linking: `Source/Parser/SVG/Settings/SVGSettings.swift`
  - Tests: `SVGViewTests/BaseTestCase.swift` and `SVGViewTests/w3c/` reference folders.

- **Small gotchas & checks before PR:**
  - Verify which `Serializer` implementation is used by tests; `Source/Serialization/Serializer.swift` contains code inside block comments — running `swift test` / Xcode tests will reveal if serializer needs repair.
  - When changing parsing order or style precedence, update `SVGParser.getStyleAttributes` and corresponding tests in `SVGViewTests`.

If any section is unclear or you want more examples (e.g. adding a new element parser, or how to run a specific test), tell me which part to expand.
