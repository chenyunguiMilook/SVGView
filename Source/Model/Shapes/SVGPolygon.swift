import SwiftUI
import Combine

public class SVGPolygon: SVGShape, ObservableObject {

    @Published public var points: [CGPoint]

    public override var typeName: String {
        return "polygon"
    }
    
    public init(_ points: [CGPoint]) {
        self.points = points
    }

    public init(points: [CGPoint] = []) {
        self.points = points
    }

    override public func frame() -> CGRect {
        guard !points.isEmpty else {
            return .zero
        }

        var minX = CGFloat(INT16_MAX)
        var minY = CGFloat(INT16_MAX)
        var maxX = CGFloat(INT16_MIN)
        var maxY = CGFloat(INT16_MIN)

        for point in points {
            minX = min(minX, point.x)
            maxX = max(maxX, point.x)
            minY = min(minY, point.y)
            maxY = max(maxY, point.y)
        }

        return CGRect(x: minX, y: minY,
                      width: maxX - minX,
                      height: maxY - minY)
    }

    public override func bounds() -> CGRect {
        let frame = frame()
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }

    public override func serialize(_ serializer: Serializer) {
        serializer.add("points", points.serialized)
        super.serialize(serializer)
    }
    
    public override var bezierPath: MBezierPath {
        let path = MBezierPath()
        for (i, point) in points.enumerated() {
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.close()
        return path
    }
}

