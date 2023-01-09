//
//  Extensions.swift
//  SVGView
//
//  Created by Yuriy Strot on 18.01.2021.
//

import Foundation
import SwiftUI

extension Bool: SerializableAtom {
    public func serialize() -> String {
        return self.description
    }
}

extension String: SerializableAtom {
    public func serialize() -> String {
        return self
    }
}

extension CGFloat: SerializableAtom {
    public func serialize() -> String {
        return String(format: "%g", self)
    }
}

extension Double: SerializableAtom {
    public func serialize() -> String {
        return CGFloat(self).serialize()
    }
}

extension CGAffineTransform: SerializableAtom {
    //"matrix(1,0,0,1,50,20)"
    public func serialize() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 10
        let nums = [a, b, c, d, tx, ty]
        let strings = nums.map{ formatter.string(from: $0 as NSNumber) ?? "n/a" }
        return "matrix(\(strings.joined(separator: ",")))"
    }
}

extension CGRect: SerializableAtom {
    public func serialize() -> String {
        return "\(self.minX) \(self.minY) \(self.width) \(self.height)"
    }
}

public extension Collection where Iterator.Element == CGPoint {
    var serialized: CGPointList? {
        if self.isEmpty {
            return nil
        }
        return CGPointList(points: self.map { $0 })
    }
}

public class CGPointList: SerializableAtom {
    let points: [CGPoint]

    init(points: [CGPoint]) {
        self.points = points
    }

    public func serialize() -> String {
        return "[\(self.points.map { p in "\(p.x.serialize()), \(p.y.serialize())" }.joined(separator: ", "))]"
    }
}

public extension Collection where Iterator.Element == CGFloat {
    var serialized: CGFloatList? {
        if self.isEmpty {
            return nil
        }
        return CGFloatList(list: self.map { $0 })
    }
}

public class CGFloatList: SerializableAtom {
    let list: [CGFloat]

    init(list: [CGFloat]) {
        self.list = list
    }

    public func serialize() -> String {
        return "[\(self.list.map { p in p.serialize() }.joined(separator: ", "))]"
    }
}

extension CGLineCap: SerializableOption {
    public func isDefault() -> Bool {
        return self == .butt
    }

    public func serialize() -> String {
        switch self {
        case .round:
            return "round"
        case .square:
            return "square"
        default:
            return "butt"
        }
    }
}

extension CGLineJoin: SerializableOption {
    public func isDefault() -> Bool {
        return self == .miter
    }

    public func serialize() -> String {
        switch self {
        case .round:
            return "round"
        case .bevel:
            return "bevel"
        default:
            return "miter"
        }
    }
}

extension CGPathFillRule: SerializableOption {
    public func isDefault() -> Bool {
        return self == .winding
    }

    public func serialize() -> String {
        switch self {
        case .evenOdd:
            return "evenodd"
        default:
            return "nonzero"
        }
    }
}

extension HorizontalAlignment: SerializableOption {
    public func isDefault() -> Bool {
        return self == .leading
    }

    public func serialize() -> String {
        switch self {
        case .center:
            return "middle"
        case .trailing:
            return "end"
        default:
            return "start"
        }
    }
}
