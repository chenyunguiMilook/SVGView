//
//  SVGParserPrimitives.swift
//  SVGView
//
//  Created by Alisa Mylnikova on 20/07/2020.
//

import SwiftUI
import RegexBuilder
import PrimeKit

public class SVGHelper: NSObject {

    static func parseUse(_ use: String?) -> String? {
        guard let use = use else {
            return .none
        }
        return use.replacingOccurrences(of: "url(#", with: "")
            .replacingOccurrences(of: ")", with: "")
    }

    static func parseId(_ dict: [String: String]) -> String? {
        return dict["id"] ?? dict["xml:id"]
    }

    static func parseStroke(_ style: [String: String], index: SVGIndex) -> SVGStroke? {
        guard let fill = SVGHelper.parseStrokeFill(style, index) else {
            return .none
        }

        return SVGStroke(
            fill: fill.opacity(SVGHelper.parseOpacity(style, "stroke-opacity")),
            width: parseCGFloat(style, "stroke-width", defaultValue: 1),
            cap: getStrokeCap(style),
            join: getStrokeJoin(style),
            miterLimit: parseCGFloat(style, "stroke-miterlimit", defaultValue: 4),
            dashes: getStrokeDashes(style),
            offset: parseCGFloat(style, "stroke-dashoffset"))
    }

    static func getStrokeDashes(_ style: [String: String]) -> [CGFloat] {
        var dashes = [CGFloat]()
        if let strokeDashes = style["stroke-dasharray"] {
            let separatedValues = strokeDashes.components(separatedBy: CharacterSet(charactersIn: " ,"))
            separatedValues.forEach { value in
                if let doubleValue = doubleFromString(value) {
                    dashes.append(CGFloat(doubleValue))
                }
            }
        }
        return dashes
    }

    static func getStrokeCap(_ style: [String: String]) -> CGLineCap {
        if let strokeCap = style["stroke-linecap"] {
            switch strokeCap {
            case "round":
                return .round
            case "square":
                return .square
            default:
                break
            }
        }
        return .butt
    }

    static func getStrokeJoin(_ style: [String: String]) -> CGLineJoin {
        if let strokeJoin = style["stroke-linejoin"] {
            switch strokeJoin {
            case "round":
                return .round
            case "bevel":
                return .bevel
            default:
                break
            }
        }
        return .miter
    }

    static func parseTransform(_ attributes: String) -> CGAffineTransform {
        guard !attributes.isEmpty else { return .identity }
        let regex = Regex {
            Capture(.svgTransforms)
        }
        if let (_, transforms) = attributes.firstMatch(of: regex)?.output {
            var result: CGAffineTransform = .identity
            for trans in transforms.reversed() {
                result = result * trans
            }
            return result
        } else {
            return .identity
        }
    }

    static func transformForNodeInRespectiveCoords(respective: SVGNode, absolute: SVGNode) -> CGAffineTransform {
        let absoluteBounds = absolute.bounds()
        let respectiveBounds = respective.bounds()
        let finalSize = CGSize(width: absoluteBounds.width * respectiveBounds.width,
                               height: absoluteBounds.height * respectiveBounds.height)
        let scale = SVGPreserveAspectRatio(scaling: .none).layout(size: respectiveBounds.size, into: finalSize)
        let move = CGAffineTransform(translationX: absoluteBounds.minX, y: absoluteBounds.minY)
        return scale.concatenating(move)
    }
}
