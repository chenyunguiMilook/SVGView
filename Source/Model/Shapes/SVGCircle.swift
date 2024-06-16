import SwiftUI
import Combine

public class SVGCircle: SVGShape, ObservableObject {

    @Published public var cx: CGFloat
    @Published public var cy: CGFloat
    @Published public var r: CGFloat

    public override var typeName: String {
        return "circle"
    }
    
    public init(cx: CGFloat = 0, cy: CGFloat = 0, r: CGFloat = 0) {
        self.cx = cx
        self.cy = cy
        self.r = r
    }

    override public func frame() -> CGRect {
        CGRect(x: cx - r, y: cy - r, width: 2*r, height: 2*r)
    }

    public override func serialize(_ serializer: Serializer) {
        serializer.add("cx", cx, 0).add("cy", cy, 0).add("r", r, 0)
        super.serialize(serializer)
    }
    
    public override var bezierPath: MBezierPath {
        return MBezierPath(ovalIn: self.frame())
    }
}
