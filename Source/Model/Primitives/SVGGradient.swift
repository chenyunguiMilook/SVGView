//
//  SVGGradient.swift
//  SVGView
//
//  Created by Yuriy Strot on 22.02.2021.
//

import SwiftUI

public class SVGLinearGradient: SVGGradient {

    public let x1: CGFloat
    public let y1: CGFloat
    public let x2: CGFloat
    public let y2: CGFloat

    public override var typeName: String {
        return "linearGradient"
    }
    
    public init(x1: CGFloat = 0, y1: CGFloat = 0, x2: CGFloat = 0, y2: CGFloat = 0,
                userSpace: Bool = false,
                stops: [SVGStop] = [],
                transform: CGAffineTransform = .identity,
                id: String) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        super.init(
            userSpace: userSpace,
            stops: stops,
            transform: transform,
            id: id
        )
    }

    public convenience init(degree: CGFloat = 0, from: SVGColor, to: SVGColor) {
        self.init(degree: degree, stops: [SVGStop(color: from, offset: 0), SVGStop(color: to, offset: 1)])
    }

    public init(degree: CGFloat = 0, stops: [SVGStop]) {
        let rad = degree * .pi / 180
        var v = [0, 0, cos(rad), sin(rad)]
        let mmax = 1 / max(abs(v[2]), abs(v[3]))
        v[2] *= mmax
        v[3] *= mmax
        if v[2] < 0 {
            v[0] = -v[2]
            v[2] = 0
        }
        if v[3] < 0 {
            v[1] = -v[3]
            v[3] = 0
        }

        self.x1 = v[0]
        self.y1 = v[1]
        self.x2 = v[2]
        self.y2 = v[3]

        super.init(
            userSpace: false,
            stops: stops
        )
    }
    
    public override func serialize(_ serializer: Serializer) {
        serializer
            .add("x1", self.x1)
            .add("y1", self.y1)
            .add("x2", self.x2)
            .add("y2", self.y2)
        super.serialize(serializer)
    }
    
    override func serialize(key: String, serializer: Serializer) {
        serializer.addReference(self)
        serializer.add(key, "url(#\(self.id!))")
    }

    public func toSwiftUI(rect: CGRect) -> LinearGradient {
        let suiStops = stops.map { stop in Gradient.Stop(color: stop.color.toSwiftUI(), location: stop.offset) }
        let nx1 = userSpace ? (x1 - rect.minX) / rect.size.width : x1
        let ny1 = userSpace ? (y1 - rect.minY) / rect.size.height : y1
        let nx2 = userSpace ? (x2 - rect.minX) / rect.size.width : x2
        let ny2 = userSpace ? (y2 - rect.minY) / rect.size.height : y2
        return LinearGradient(gradient: Gradient(stops: suiStops), startPoint: UnitPoint(x: nx1, y: ny1), endPoint: UnitPoint(x: nx2, y: ny2)
        )
    }

    func apply<S>(view: S, model: SVGShape? = nil) -> some View where S : View {
        let frame = model?.frame() ?? CGRect()
        let bounds = model?.bounds() ?? CGRect()
        let width = bounds.width
        let height = bounds.height
        let maximum = max(width, height)
        
        return view
            .foregroundColor(.clear)
            .overlay(
                toSwiftUI(rect: frame)
                    .applyIf(!userSpace) {
                        $0.frame(width: maximum, height: maximum)
                            .scaleEffect(CGSize(width: width/maximum, height: height/maximum))
                    }
                    .frame(width: width, height: height)
                    .offset(x: bounds.minX, y: bounds.minY)
                    .mask(view)
            )
    }

}

public class SVGRadialGradient: SVGGradient {
    
    public let cx: CGFloat
    public let cy: CGFloat
    public let fx: CGFloat
    public let fy: CGFloat
    public let r: CGFloat
    
    public override var typeName: String {
        return "radialGradient"
    }
    
    public init(cx: CGFloat = 0.5, cy: CGFloat = 0.5, fx: CGFloat = 0.5, fy: CGFloat = 0.5, r: CGFloat = 0.5,
                userSpace: Bool = false,
                stops: [SVGStop] = [],
                transform: CGAffineTransform,
                id: String) {
        self.cx = cx
        self.cy = cy
        self.fx = fx
        self.fy = fy
        self.r = r
        super.init(
            userSpace: userSpace,
            stops: stops,
            transform: transform,
            id: id
        )
    }

    public override func serialize(_ serializer: Serializer) {
        super.serialize(serializer)
        serializer
            .add("cx", self.cx)
            .add("cy", self.cy)
            .add("r", self.r)
            .add("fx", self.fx)
            .add("fy", self.fy)
    }
    
    override func serialize(key: String, serializer: Serializer) {
        serializer.addReference(self)
        serializer.add(key, "url(#\(id!))")
    }
    
    public func toSwiftUI(rect: CGRect) -> RadialGradient {
        let suiStops = stops.map { stop in Gradient.Stop(color: stop.color.toSwiftUI(), location: stop.offset) }
        let s = min(rect.size.width, rect.size.height)
        let ncx = userSpace ? (cx - rect.minX) / rect.size.width : cx
        let ncy = userSpace ? (cy - rect.minY) / rect.size.height : cy
        return RadialGradient(gradient: Gradient(stops: suiStops), center: UnitPoint(x: ncx, y: ncy), startRadius: 0, endRadius: userSpace ? r : r * s)
    }

    func apply<S>(view: S, model: SVGShape? = nil) -> some View where S : View {
        let frame = model?.frame() ?? CGRect()
        let bounds = model?.bounds() ?? CGRect()
        let width = bounds.width
        let height = bounds.height
        let minimum = min(width, height)
        return view
            .foregroundColor(.clear)
            .overlay(
                toSwiftUI(rect: frame)
                    .scaleEffect(CGSize(width: userSpace ? 1 : width/minimum,
                                        height: userSpace ? 1 : height/minimum))
                    .offset(x: bounds.minX, y: bounds.minY)
                    .mask(view)
            )
    }
}

public class SVGGradient: SVGPaint, Equatable {

    public static func == (lhs: SVGGradient, rhs: SVGGradient) -> Bool {
        if lhs.userSpace != rhs.userSpace {
            return false
        }

        if lhs.stops.isEmpty && rhs.stops.isEmpty {
            return true
        }

        return lhs.stops.elementsEqual(rhs.stops)
    }

    public let userSpace: Bool
    public let stops: [SVGStop]
    public var transform: CGAffineTransform

    public init(userSpace: Bool = false,
                stops: [SVGStop] = [],
                transform: CGAffineTransform = .identity,
                id: String? = nil) {
        self.userSpace = userSpace
        self.stops = stops
        self.transform = transform
        super.init(id: id)
    }
    
    public override func serialize(_ serializer: Serializer) {
        let t = self.transform
        let values = [t.a, t.b, t.c, t.d, t.tx, t.ty]
        let strings = values.map{ String(format: "%g", $0) }.joined(separator: " ")
        serializer.add("gradientTransform", "matrix(\(strings))")
        if userSpace {
            serializer.add("gradientUnits", "userSpaceOnUse")
        }
        serializer.addChildren(self.stops.map{ $0.serialize() })
    }
}

public class SVGStop: SerializableElement, Equatable {

    public static func == (lhs: SVGStop, rhs: SVGStop) -> Bool {
        return lhs.offset == rhs.offset && lhs.color == rhs.color
    }

    public let color: SVGColor
    public let offset: CGFloat

    public override var typeName: String {
        return "stop"
    }
    
    public init(color: SVGColor, offset: CGFloat = 0) {
        self.color = color
        self.offset = max(0, min(1, offset))
    }
    
    public override func serialize(_ serializer: Serializer) {
        color.serialize(key: "stop-color", serializer: serializer)
        serializer
            .add("stop-opacity", color.opacity)
            .add("offset", offset)
    }
}
 
