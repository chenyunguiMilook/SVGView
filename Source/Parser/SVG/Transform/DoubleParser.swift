//
//  File.swift
//  
//
//  Created by chenyungui on 2023/1/8.
//

import Foundation
import RegexBuilder

public struct DoubleParser: CustomConsumingRegexComponent {
    public typealias RegexOutput = Double

    
    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: Double)? {
        input[index...].withCString { startAddress in
            var endAddress: UnsafeMutablePointer<CChar>!
            let ouput = strtod(startAddress, &endAddress)
            guard endAddress > startAddress else { return nil }
            let parsedLength = startAddress.distance(to: endAddress)
            let upperBound = input.utf8.index(index, offsetBy: parsedLength)
            return (upperBound, ouput)
        }
    }
}


extension RegexComponent where Self == DoubleParser {
    public static var double: DoubleParser {
        DoubleParser()
    }
}
