//
//  File.swift
//  
//
//  Created by chenyungui on 2023/1/6.
//

import Foundation
import RegexBuilder

public enum TransformType: String {
    case matrix
    case translate
    case rotate
    case scale
    case skewX
    case skewY
}

public struct TransformTypeParser: CustomConsumingRegexComponent {
    public typealias RegexOutput = TransformType

    public func consuming(
        _ input: String, startingAt index: String.Index, in bounds: Range<String.Index>
    ) throws -> (upperBound: String.Index, output: TransformType)? {
        let regex = Regex {
            TryCapture {
                ChoiceOf {
                    "matrix"
                    "translate"
                    "rotate"
                    "scale"
                    "skewX"
                    "skewY"
                }
            } transform: {
                TransformType(rawValue: String($0))
            }
        }
        let stringForMatching = input[index...]
        if stringForMatching.starts(with: regex),
            let (whole, type) = stringForMatching.firstMatch(of: regex)?.output {
            return (whole.endIndex, type)
        } else {
            return nil
        }
    }
}

extension RegexComponent where Self == TransformTypeParser {
    public static var transformType: TransformTypeParser {
        TransformTypeParser()
    }
}
