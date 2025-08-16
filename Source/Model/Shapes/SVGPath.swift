import SwiftUI
import Combine
import PrimeKit
import RenderKit

public class SVGPath: SVGShape, ObservableObject {

    @Published public var segments: [PathSegment]

    public override var typeName: String {
        return "path"
    }
    
    public init(
        id: String? = nil,
        segments: [PathSegment] = [],
        fillRule: CGPathFillRule = .winding,
        transform: CGAffineTransform = .identity,
        opacity: Double = 1,
        clip: SVGNode? = nil,
        mask: SVGNode? = nil,
    ) {
        self.segments = segments
        super.init(
            transform: transform,
            opaque: true,
            opacity: opacity,
            fillOpacity: 1,
            clip: clip,
            mask: mask,
            id: id
        )
        self.fillRule = fillRule
    }
    
    override public func frame() -> CGRect {
        toBezierPath().cgPath.boundingBoxOfPath
    }

    override public func bounds() -> CGRect {
        frame()
    }

    public var pathString: String {
        segments.svgPathString
    }
    
    public override func serialize(_ serializer: Serializer) {
        serializer.add("d", pathString)
        serializer.add("fill-rule", fillRule)
        super.serialize(serializer)
    }
    
    public override var bezierPath: MBezierPath {
        self.toBezierPath()
    }
}

extension PathOperation {
    public var segment: PathSegment {
        switch self {
        case .moveTo(let point):
            return PathSegment(type: .M, data: [point.x, point.y])
        case .lineTo(let point):
            return PathSegment(type: .L, data: [point.x, point.y])
        case .quadCurveTo(let to, let c):
            return PathSegment(type: .Q, data: [c.x, c.y, to.x, to.y])
        case .curveTo(let to, let c1, let c2):
            return PathSegment(type: .C, data: [c1.x, c1.y, c2.x, c2.y, to.x, to.y])
        case .close:
            return PathSegment(type: .z)
        }
    }
}

extension SVGPath {
    
    public convenience init?(string: String, fillRule: CGPathFillRule) {
        let reader = PathReader(input: string)
        let segments = reader.read()
        guard !segments.isEmpty else { return nil }
        self.init(segments: segments, fillRule: fillRule)
    }
    
    public convenience init(
        id: String? = nil,
        cgPath: CGPath,
        fillRule: CGPathFillRule,
        transform: CGAffineTransform = .identity,
        opacity: Double = 1,
        clip: SVGNode? = nil,
        mask: SVGNode? = nil,
    ) {
        self.init(
            id: id,
            segments: cgPath.segments,
            fillRule: fillRule,
            transform: transform,
            opacity: opacity,
            clip: clip,
            mask: mask
        )
    }
}

extension CGPath {
    public var segments: [PathSegment] {
        return operations.map{ $0.segment }
    }
    
    public var svgPathString: String {
        return self.segments.svgPathString
    }
}

extension Array where Element == PathSegment {
    
    public var svgPathString: String {
        self.map { s in "\(s.type)\(s.data.compactMap { $0.serialize() }.joined(separator: ","))" }.joined(separator: " ")
    }
}
