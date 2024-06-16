//
//  SVGAttribute.swift
//  SVGView
//
//  Created by Yuri Strot on 29.05.2022.
//

import Foundation

struct SVGAttributes {

    static let fontSize = SVGFontSizeAttribute()
    static let x = SVGLengthAttribute(name: "x", axis: .x)
    static let y = SVGLengthAttribute(name: "y", axis: .y)
    static let width = SVGLengthAttribute(name: "width", axis: .x)
    static let height = SVGLengthAttribute(name: "height", axis: .y)
    static let r = SVGLengthAttribute(name: "r", axis: .all)
    static let rx = SVGLengthAttribute(name: "rx", axis: .x)
    static let ry = SVGLengthAttribute(name: "ry", axis: .y)
    static let cx = SVGLengthAttribute(name: "cx", axis: .x)
    static let cy = SVGLengthAttribute(name: "cy", axis: .y)
    static let x1 = SVGLengthAttribute(name: "x1", axis: .x)
    static let x2 = SVGLengthAttribute(name: "x2", axis: .x)
    static let y1 = SVGLengthAttribute(name: "y1", axis: .y)
    static let y2 = SVGLengthAttribute(name: "y2", axis: .y)

}
