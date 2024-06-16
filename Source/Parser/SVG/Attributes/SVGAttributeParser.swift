//
//  SVGAttributeParser.swift
//  
//
//  Created by chenyungui on 2024/6/16.
//
import Foundation

protocol SVGAttributeParser {
    associatedtype Value: Sendable
    var attributeName: String { get }
    var isInherited: Bool { get }
    func parse(string: String, context: SVGNodeContext) -> Value?
    func defaultValue(context: SVGNodeContext) -> Value
}

struct SVGLengthAttribute: SVGAttributeParser, Sendable {
    typealias Value = CGFloat
    
    let attributeName: String
    let isInherited: Bool = false
    let parser: SVGLengthParser

    init(name: String, axis: SVGLengthAxis) {
        self.attributeName = name
        self.parser = SVGLengthParser.forAxis(axis)
    }

    func parse(string: String, context: SVGNodeContext) -> CGFloat? {
        parser.float(string: string, context: context)
    }

    func defaultValue(context: SVGNodeContext) -> CGFloat { 0 }
}

struct SVGFontSizeAttribute: SVGAttributeParser, Sendable {
    typealias Value = CGFloat
    
    let attributeName: String = "font-size"
    let isInherited: Bool = true

    func parse(string: String, context: SVGNodeContext) -> CGFloat? {
        SVGLengthParser.fontSize.float(string: string, context: context)
    }

    func defaultValue(context: SVGNodeContext) -> CGFloat {
        context.defaultFontSize
    }
}

