import SwiftUI
import Combine
import CommonKit

public class SVGPath: SVGShape, ObservableObject {

    @Published public var segments: [PathSegment]

    public override var typeName: String {
        return "path"
    }
    
    public init(segments: [PathSegment] = [], fillRule: CGPathFillRule = .winding) {
        self.segments = segments
        super.init(
            transform: .identity,
            opaque: true,
            opacity: 1,
            fillOpacity: 1,
            clip: nil,
            mask: nil,
            id: nil
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

    public func contentView() -> some View {
        SVGPathView(model: self)
    }
    
    public override var bezierPath: MBezierPath {
        self.toBezierPath()
    }
}

struct SVGPathView: View {

    @ObservedObject var model = SVGPath()

    public var body: some View {
        model.toBezierPath().toSwiftUI(model: model, eoFill: model.fillRule == .evenOdd)
    }
}

extension MBezierPath {

    func toSwiftUI(model: SVGShape, eoFill: Bool = false) -> some View {
        let isGradient = model.fill is SVGGradient
        let bounds = isGradient ? model.bounds() : CGRect.zero
        return Path(self.cgPath)
            .applySVGStroke(stroke: model.stroke, eoFill: eoFill)
            .applyShapeAttributes(model: model)
            .applyIf(isGradient) {
                $0.frame(width: bounds.width, height: bounds.height)
                    .position(x: 0, y: 0)
                    .offset(x: bounds.width/2, y: bounds.height/2)
            }
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
    
    public convenience init(cgPath: CGPath, fillRule: CGPathFillRule) {
        self.init(segments: cgPath.segments, fillRule: fillRule)
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
