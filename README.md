# SVGView Core

[![Swift](https://img.shields.io/badge/Swift-5.7+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS-lightgrey.svg)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)]()

**SVGView Core** 是一个基于 Swift 原生开发的高性能 SVG 解析与对象模型库。它能将 SVG 字符串或文件解析为可操作的 Swift 对象图（Object Graph），支持复杂的路径数据处理、CSS 样式层叠、仿射变换解析，并具备将对象模型反序列化回 XML 的能力，完美适配 SwiftUI 和 CoreGraphics 生态。

---

## 🌟 核心功能 (Features)

*   **全功能解析引擎**：基于 `XMLParser` 构建的 DOM 解析器，支持从 String、Data、URL 或流中读取 SVG。
*   **完整的对象模型**：提供 `SVGNode`, `SVGGroup`, `SVGShape` 等强类型对象，所有节点均遵循 `ObservableObject` 协议，天然支持 SwiftUI 数据绑定。
*   **高精度路径处理**：内置强大的 `PathReader`，完全遵循 SVG 标准解析 `d` 属性（支持 M, L, C, Q, A, Z 等所有指令），并能转换为 `UIBezierPath`/`NSBezierPath`。
*   **CSS 与样式支持**：
    *   支持内联样式 (`style="..."`) 和属性样式。
    *   内置 `CSSParser`，支持解析 `<style>` 标签内的类选择器 (`.class`)、ID 选择器 (`#id`) 和标签选择器。
    *   支持颜色解析（Hex, RGB, 颜色关键字）及渐变（线性 `linearGradient` 与 径向 `radialGradient`）。
*   **数学与变换**：
    *   使用 Swift 5.7+ `RegexBuilder` 实现的高性能变换解析器 (`transform` 属性)。
    *   支持 `matrix`, `translate`, `rotate`, `scale`, `skewX`, `skewY` 及其组合。
*   **序列化能力**：实现了完整的 `Serializable` 协议栈，可将修改后的 Swift 对象模型重新导出为标准的 SVG XML 字符串。
*   **跨平台兼容**：核心逻辑通过 `MBezierPath` 别名同时兼容 macOS (AppKit) 和 iOS (UIKit/SwiftUI)。

---

## 🏗 模块概览 (Module Overview)

本库源码结构清晰，主要分为以下几个核心模块：

### 1. 解析与输入 (Parser Core)
负责将原始 XML 数据转换为内存中的对象模型，处理资源加载与上下文管理。

| 组件 / 类 | 功能描述 |
| :--- | :--- |
| **SVGParser** | 解析入口类，协调 DOM 解析、节点创建和上下文分发。 |
| **DOMParser / XMLDelegate** | 基于 `Foundation.XMLParser` 的底层封装，构建基础 XML 树结构。 |
| **SVGContext** | 解析上下文，管理全局配置（如 PPI、默认字体）、ID 索引及样式继承。 |
| **SVGLinker** | 资源加载器协议，处理外部图片或资源的加载策略（支持本地及网络）。 |
| **SVGIndex** | 索引管理器，负责 `defs`、`id` 引用以及渐变定义的查找。 |

### 2. SVG 对象模型 (Data Model)
构建了一套完整的 SVG 节点树，所有类均继承自 `SVGNode` 并支持序列化。

| 组件 / 类 | 功能描述 |
| :--- | :--- |
| **SVGNode** | 基础节点类，包含变换 (`transform`)、透明度、遮罩 (`mask`) 及剪裁 (`clip`) 属性。 |
| **SVGGroup (`<g>`, `<svg>`)** | 容器节点，支持子节点嵌套和坐标系变换，计算包围盒 (Bounding Box)。 |
| **SVGShape** | 抽象形状基类，派生出 `SVGRect`, `SVGCircle`, `SVGEllipse`, `SVGLine`, `SVGPolygon`。 |
| **SVGPath (`<path>`)** | 核心形状类，存储解析后的 `PathSegment` 数组，支持填充规则 (`evenOdd`/`winding`)。 |
| **SVGText (`<text>`)** | 文本节点，支持锚点对齐 (`text-anchor`)、字体属性及位置变换。 |
| **SVGImage (`<image>`)** | 图片节点，支持 Base64 内嵌数据 (`SVGDataImage`) 和外部 URL 链接 (`SVGURLImage`)。 |

### 3. 几何与数学 (Geometry & Math)
处理复杂的矢量图形计算、路径解析及矩阵变换。

| 组件 / 类 | 功能描述 |
| :--- | :--- |
| **PathReader** | 词法分析器，将 SVG 路径字符串 (`d="M10 10..."`) 解析为 `PathSegment` 数组。 |
| **MBezierPath Extension** | 跨平台扩展，统一 macOS/iOS 的贝塞尔曲线 API，提供 `cgPath` 转换及几何计算。 |
| **TransformParser** | 利用 `RegexBuilder` 解析 CSS 变换字符串，生成 `CGAffineTransform` 矩阵。 |
| **SVGLength** | 长度单位处理器，处理像素 (`px`) 与百分比 (`%`) 的转换逻辑。 |
| **SVGPreserveAspectRatio** | 视口适配逻辑，实现 SVG 的 `preserveAspectRatio` (如 `xMidYMid meet`)。 |

### 4. 样式与属性 (Styling & Attributes)
管理图形的视觉表现，包括颜色、描边、字体及 CSS 解析。

| 组件 / 类 | 功能描述 |
| :--- | :--- |
| **CSSParser** | CSS 解析引擎，处理样式表的级联规则和选择器匹配。 |
| **SVGPaint / SVGColor** | 绘画填充基类。支持 Hex/RGB 颜色解析，兼容 SwiftUI `Color`。 |
| **SVGGradient** | 渐变系统，包含 `SVGLinearGradient` 和 `SVGRadialGradient`，支持 `SVGStop` 定义。 |
| **SVGStroke** | 描边属性模型，包含线宽、端点类型 (`cap`)、连接类型 (`join`) 及虚线 (`dashArray`)。 |
| **SVGFont** | 字体模型，解析 `font-family`, `font-weight`, `font-size`。 |

### 5. 序列化 (Serialization)
提供将 Swift 对象模型逆向输出为 XML 的能力，用于保存或导出修改后的 SVG。

| 组件 / 类 | 功能描述 |
| :--- | :--- |
| **Serializer** | 核心序列化器，构建 XML 字符串结构，处理缩进、属性拼接及子节点递归。 |
| **Serializable 协议簇** | 包含 `SerializableElement`, `SerializableAtom` 等协议，定义对象的导出行为。 |
| **XMLSerializer** | 具体的 XML 生成逻辑实现，支持 XML 头定义及特殊字符转义。 |

---

## 🛠 快速开始 (Quick Start)

### 解析 SVG
```swift
// 从 URL 解析
if let url = Bundle.main.url(forResource: "icon", withExtension: "svg"),
   let svgNode = SVGParser.parse(contentsOf: url) {
    print("Parsed SVG with size: \(svgNode.bounds())")
}

// 从字符串解析
let svgString = """
<svg width="100" height="100">
  <circle cx="50" cy="50" r="40" stroke="green" stroke-width="4" fill="yellow" />
</svg>
"""
let node = SVGParser.parse(string: svgString)
```

### 序列化 (导出 XML)
```swift
// 修改节点属性
if let circle = node as? SVGGroup, let shape = circle.contents.first as? SVGCircle {
    shape.fill = SVGColor.red
}

// 导出为字符串
let serializer = Serializer(name: "svg")
node?.serialize(serializer)
let xmlString = serializer.toSerializerString()
print(xmlString)
```

---

## ⚠️ 系统要求

*   **iOS 13.0+ / macOS 10.15+** (由于使用了 SwiftUI 和 Combine)
*   **Swift 5.7+** (使用了 RegexBuilder 进行变换解析)