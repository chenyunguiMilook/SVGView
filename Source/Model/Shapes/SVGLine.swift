import SwiftUI
import Combine

public class SVGLine: SVGShape, ObservableObject {

    @Published public var x1: CGFloat
    @Published public var y1: CGFloat
    @Published public var x2: CGFloat
    @Published public var y2: CGFloat

    public override var typeName: String {
        return "line"
    }
    
    public init(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }

    public init(x1: CGFloat = 0, y1: CGFloat = 0, x2: CGFloat = 0, y2: CGFloat = 0) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }

    override public func frame() -> CGRect {
        return CGRect(x: min(x1, x2), y: min(y1, y2), width: abs(x1 - x2), height: abs(y1 - y2))
    }

    public override func serialize(_ serializer: Serializer) {
        serializer.add("x1", x1, 0).add("y1", y1, 0).add("x2", x2, 0).add("y2", y2, 0)
        super.serialize(serializer)
    }
    
    public override var bezierPath: MBezierPath {
        let path = MBezierPath()
        path.move(to: CGPoint(x: x1, y: y1))
        path.addLine(to: CGPoint(x: x2, y: y2))
        return path
    }
}
