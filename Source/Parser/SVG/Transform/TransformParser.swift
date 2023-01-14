//
//  File.swift
//  
//
//  Created by chenyungui on 2023/1/6.
//

import Foundation
import CoreGraphics
import RegexBuilder

extension Double {
    public var toRadians: Double {
        return self * .pi / 180
    }
    public var toDegree: Double {
        return self * 180 / .pi
    }
}

extension CGAffineTransform {
    
    public enum Error: Swift.Error {
        case invalidTransform
    }
    
    public init(type: TransformType, values: [Double]) throws {
        switch type {
        case .translate:
            var x: Double = 0
            var y: Double = 0
            if values.count == 1 {
                x = values[0]
            } else if values.count == 2 {
                x = values[0]
                y = values[1]
            } else {
                throw Error.invalidTransform
            }
            self = CGAffineTransform(translationX: x, y: y)
        case .rotate:
            if values.count == 1 {
                let angle = values[0].toRadians
                self = CGAffineTransform(rotationAngle: angle)
            } else if values.count == 3 {
                let angle = values[0].toRadians
                let centerX = values[1]
                let centerY = values[2]
                self = CGAffineTransform(rotate: angle, aroundCenter: .init(x: centerX, y: centerY))
            } else {
                throw Error.invalidTransform
            }
        case .scale:
            var x: Double = 0
            var y: Double = 0
            if values.count == 1 {
                x = values[0]
                y = values[0]
            } else if values.count == 2 {
                x = values[0]
                y = values[1]
            } else {
                throw Error.invalidTransform
            }
            self = CGAffineTransform(scaleX: x, y: y)
        case .skewX:
            if values.count == 1 {
                let angle = values[0].toRadians
                self = CGAffineTransform.init(skewX: angle)
            } else {
                throw Error.invalidTransform
            }
        case .skewY:
            if values.count == 1 {
                let angle = values[0].toRadians
                self = CGAffineTransform.init(skewY: angle)
            } else {
                throw Error.invalidTransform
            }
        case .matrix:
            if values.count == 6 {
                self = CGAffineTransform(a: values[0], b: values[1], c: values[2], d: values[3], tx: values[4], ty: values[5])
            } else {
                throw Error.invalidTransform
            }
        }
    }
}

extension CGAffineTransform {
    public init(skewX sx: Double) {
        let a: Double = 1
        let b: Double = 0
        let c: Double = tan(sx)
        let d: Double = 1
        self.init(a, b, c, d, 0, 0)
    }
    
    public init(skewY sy: Double) {
        let a: Double = 1
        let b: Double = tan(sy)
        let c: Double = 0
        let d: Double = 1
        self.init(a, b, c, d, 0, 0)
    }
    
    public init(rotate radian: CGFloat, aroundCenter center: CGPoint) {
        let cosa = cos(radian)
        let sina = sin(radian)
        let a = cosa
        let b = sina
        let c = -sina
        let d = cosa
        let x = center.y * sina - center.x * cosa + center.x
        let y = -center.y * cosa - center.x * sina + center.y
        self.init(a, b, c, d, x, y)
    }
}

public func * (m1: CGAffineTransform, m2: CGAffineTransform) -> CGAffineTransform {
    return m1.concatenating(m2)
}

public struct TransformParser: CustomConsumingRegexComponent {
    public typealias RegexOutput = CGAffineTransform

    public func consuming(
        _ input: String, startingAt index: String.Index, in bounds: Range<String.Index>
    ) throws -> (upperBound: String.Index, output: CGAffineTransform)? {
        
        let regex = Regex {
            Capture(.transformType)
            "("
            Capture(.transformValues)
            ")"
        }
        let stringForMatching = input[index...]
        if stringForMatching.starts(with: regex),
           let (whole, type, values) = stringForMatching.firstMatch(of: regex)?.output {
            let transform = try CGAffineTransform(type: type, values: values)
            return (whole.endIndex, transform)
        } else {
            return nil
        }
    }
}

extension RegexComponent where Self == TransformParser {
    public static var transform: TransformParser {
        TransformParser()
    }
}
