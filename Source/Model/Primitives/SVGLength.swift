//
//  SVGLength.swift
//  Pods
//
//  Created by Alisa Mylnikova on 13/10/2020.
//

import SwiftUI

public enum SVGLength {

    case percent(CGFloat)
    case pixels(CGFloat)

    public init(percent: CGFloat) {
        self = .percent(percent)
    }

    public init(pixels: CGFloat) {
        self = .pixels(pixels)
    }

    public var ideal: CGFloat? {
        switch self {
        case .percent(_):
            return nil
        case let .pixels(pixels):
            return pixels
        }
    }

    public func toPixels(total: CGFloat) -> CGFloat {
        switch self {
        case let .percent(percent):
            return total * percent / 100.0
        case let .pixels(pixels):
            return pixels
        }
    }

    public func toString() -> String {
        switch(self) {
        case let .percent(percent):
            return "\(percent.serialize())%"
        case let .pixels(pixels):
            return pixels.serialize()
        }
    }
}
