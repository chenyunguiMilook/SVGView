//
//  SVGIndex.swift
//  SVGView
//
//  Created by Yuriy Strot on 21.02.2021.
//

import SwiftUI

class SVGIndex {

    private var elements = [String: XMLElement]()
    private var paints = [String: SVGPaint]()
    private var cssParser = CSSParser()

    init(element: XMLElement) {
        fill(from: element)
    }

    func element(by id: String) -> XMLElement? {
        elements[id]
    }

    func paint(by id: String) -> SVGPaint? {
        paints[id]
    }

    func cssStyle(for element: XMLElement) -> [String: String] {
        cssParser.getStyles(element: element)
    }

    private func fill(from element: XMLElement) {
        if let id = SVGHelper.parseId(element.attributes) {
            elements[id] = element
            switch element.name {
            case "linearGradient", "radialGradient", "fill":
                paints[id] = parseFill(element, id: id)
            default:
                elements[id] = element
            }
        }
        // css style
        if element.name == "style", let textNode = element.contents.first as? XMLText {
            cssParser.parse(content: textNode.text)
        }
        for child in element.contents {
            if let child = child as? XMLElement {
                fill(from: child)
            }
        }
    }

    private func parseFill(_ element: XMLElement, id: String) -> SVGPaint? {
        switch element.name {
        case "linearGradient":
            return parseLinearGradient(element, id: id)
        case "radialGradient":
            return parseRadialGradient(element, id: id)
        default:
            return .none
        }
    }

    private func getParentGradient(_ element: XMLElement) -> SVGGradient? {
        if let link = element.attributes["xlink:href"]?.replacingOccurrences(of: " ", with: ""), link.hasPrefix("#") {

            let id = link.replacingOccurrences(of: "#", with: "")
            return paints[id] as? SVGGradient
        }
        return nil
    }

    private func parseLinearGradient(_ element: XMLElement, id: String) -> SVGPaint? {
        let parent = getParentGradient(element)

        let stops = element.contents.isEmpty ? (parent?.stops ?? []) : parseStops(element.contents, element.attributes)

        switch stops.count {
        case 0:
            return .none
        case 1:
            return stops.first!.color
        default:
            break
        }

        let plg = parent as? SVGLinearGradient
        let x1 = getDoubleValueFromPercentage(element, attribute: "x1", defaultValue: plg?.x1 ?? 0)
        let y1 = getDoubleValueFromPercentage(element, attribute: "y1", defaultValue: plg?.y1 ?? 0)
        let x2 = getDoubleValueFromPercentage(element, attribute: "x2", defaultValue: plg?.x2 ?? 1)
        let y2 = getDoubleValueFromPercentage(element, attribute: "y2", defaultValue: plg?.y2 ?? 0)

        var userSpace = false
        if let gradientUnits = element.attributes["gradientUnits"], gradientUnits == "userSpaceOnUse" {
            userSpace = true
        } else if let pg = parent {
            userSpace = pg.userSpace
        }

        var transform: CGAffineTransform = .identity
        if let gradientTransform = element.attributes["gradientTransform"] {
            transform = SVGHelper.parseTransform(gradientTransform)
        }
        return SVGLinearGradient(x1: x1, y1: y1, x2: x2, y2: y2, userSpace: userSpace, stops: stops, transform: transform, id: id)
    }

    private func parseRadialGradient(_ element: XMLElement, id: String) -> SVGPaint? {
        let parent = getParentGradient(element)
        let stops = element.contents.isEmpty ? (parent?.stops ?? []) : parseStops(element.contents, element.attributes)

        switch stops.count {
        case 0:
            return .none
        case 1:
            return stops.first!.color
        default:
            break
        }

        let prg = parent as? SVGRadialGradient
        let cx = getDoubleValueFromPercentage(element, attribute: "cx", defaultValue: prg?.cx ?? 0.5)
        let cy = getDoubleValueFromPercentage(element, attribute: "cy", defaultValue: prg?.cy ?? 0.5)
        let fx = getDoubleValueFromPercentage(element, attribute: "fx", defaultValue: prg?.fx ?? cx)
        let fy = getDoubleValueFromPercentage(element, attribute: "fy", defaultValue: prg?.fy ?? cy)
        let r = getDoubleValueFromPercentage(element, attribute: "r", defaultValue: prg?.r ?? 0.5)

        var userSpace = false
        if let gradientUnits = element.attributes["gradientUnits"], gradientUnits == "userSpaceOnUse" {
            userSpace = true
        } else if let p = parent {
            userSpace = p.userSpace
        }

        var transform: CGAffineTransform = .identity
        if let gradientTransform = element.attributes["gradientTransform"] {
            transform = SVGHelper.parseTransform(gradientTransform)
        }

        return SVGRadialGradient(cx: cx, cy: cy, fx: fx, fy: fy, r: r, userSpace: userSpace, stops: stops, transform: transform, id: id)
    }

    private func parseStops(_ nodes: [XMLNode], _ style: [String: String]) -> [SVGStop] {
        var result = [SVGStop]()
        for node in nodes {
            if let element = node as? XMLElement {
                if let stop = parseStop(element, style) {
                    result.append(stop)
                }
            }
        }
        return result
    }

    private func parseStop(_ element: XMLElement, _ style: [String: String]) -> SVGStop? {
        let offset = getDoubleValueFromPercentage(element, attribute: "offset")

        var opacity: Double = 1
        if let stopOpacity = element.attributes["stop-opacity"], let doubleValue = Double(stopOpacity) {
            opacity = doubleValue
        }
        var color = SVGColor.black.opacity(opacity)
        if let stopColor = element.attributes["stop-color"], let clr = SVGHelper.parseColor(stopColor, style) {
            color = clr.opacity(opacity)
        }
        return SVGStop(color: color, offset: offset)
    }

    private func getDoubleValueFromPercentage(_ element: XMLElement, attribute: String, defaultValue: CGFloat = 0) -> CGFloat {
        guard let attributeValue = element.attributes[attribute] else {
            return defaultValue
        }
        if !attributeValue.contains("%") {
            return SVGHelper.parseCGFloat(element.attributes, attribute, defaultValue: defaultValue)
        } else {
            let value = attributeValue.replacingOccurrences(of: "%", with: "")
            if let doubleValue = Double(value) {
                return CGFloat(doubleValue / 100)
            }
        }
        return defaultValue
    }

}
