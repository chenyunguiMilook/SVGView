//
//  File.swift
//  
//
//  Created by chenyungui on 2023/1/6.
//

import Foundation
import RegexBuilder

public struct TransformValuesParser: CustomConsumingRegexComponent {
    public typealias RegexOutput = [Double]

    public func consuming(
        _ input: String, startingAt index: String.Index, in bounds: Range<String.Index>
    ) throws -> (upperBound: String.Index, output: [Double])? {
        let regex = Regex {
            Capture{
                One(.double)
            } transform: {
                Double($0)
            }
            Optionally(",")
            Optionally(.whitespace)
        }
        var stringForMatching = input[index...]
        var upperBound: String.Index?
        var values: [Double] = []
        
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

extension RegexComponent where Self == TransformValuesParser {
    public static var transformValues: TransformValuesParser {
        TransformValuesParser()
    }
}
