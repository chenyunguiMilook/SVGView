//
//  File.swift
//  
//
//  Created by chenyungui on 2023/1/6.
//

import Foundation
import CoreGraphics
import RegexBuilder

public struct SVGTransformParser: CustomConsumingRegexComponent {
    public typealias RegexOutput = [CGAffineTransform]

    public func consuming(
        _ input: String, startingAt index: String.Index, in bounds: Range<String.Index>
    ) throws -> (upperBound: String.Index, output: [CGAffineTransform])? {
        let regex = Regex{
            Capture {
                TransformParser()
            }
            Optionally(.whitespace)
        }
        var stringForMatching = input[index...]
        var upperBound: String.Index?
        var values: [CGAffineTransform] = []
        
        while stringForMatching.starts(with: regex) {
            if let (whole, value) = stringForMatching.firstMatch(of: regex)?.output {
                upperBound = whole.endIndex
                values.append(value)
                stringForMatching = input[whole.endIndex...]
            }
        }
        if let upperBound {
            return (upperBound, values)
        } else {
            return nil
        }
    }
}

extension RegexComponent where Self == SVGTransformParser {
    public static var svgTransforms: SVGTransformParser {
        SVGTransformParser()
    }
}
