import SwiftUI

public class SVGStroke {

    public let fill: SVGPaint
    public let width: CGFloat
    public let cap: CGLineCap
    public let join: CGLineJoin
    public let miterLimit: CGFloat
    public let dashes: [CGFloat]
    public let offset: CGFloat

    public init(fill: SVGPaint = SVGColor.black, width: CGFloat = 1, cap: CGLineCap = .butt, join: CGLineJoin = .miter, miterLimit: CGFloat = 4, dashes: [CGFloat] = [], offset: CGFloat = 0.0) {
        self.fill = fill
        self.width = width
        self.cap = cap
        self.join = join
        self.miterLimit = miterLimit
        self.dashes = dashes
        self.offset = offset
    }

    public func toSwiftUI() -> StrokeStyle {
        StrokeStyle(lineWidth: width,
                    lineCap: cap,
                    lineJoin: join,
                    miterLimit: miterLimit,
                    dash: dashes,
                    dashPhase: offset)
    }
}

extension SVGStroke: SerializableDecoration {
    
    // TODO: need add to refs
    //"url(#paint10_linear_31_79)"
    public func serialize(to serializer: Serializer) {
        if let linear = fill as? SVGLinearGradient {
            
        } else if let radial = fill as? SVGRadialGradient {
            
        } else {
            fill.serialize(key: "stroke", serializer: serializer)
        }
        serializer.add("stroke-width", width, 1)
        serializer.add("stroke-cap", cap)
        serializer.add("stroke-join", join)
        serializer.add("stroke-offset", offset, 0)
        serializer.add("stroke-miterLimit", miterLimit, 4)
        serializer.add("stroke-dashes", dashes.serialized)
    }
}
