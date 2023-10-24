import SwiftUI
import Combine
import UIKit

public class SVGShape: SVGNode {

    @Published public var fill: SVGPaint?
    @Published public var stroke: SVGStroke?

    public var bezierPath: MBezierPath {
        fatalError("need to override")
    }
    public var fillRule: CGPathFillRule = .winding
    
    public override func serialize(_ serializer: Serializer) {
        if let fill {
            fill.serialize(key: "fill", serializer: serializer)
        } else {
            serializer.add("fill", "none")
        }
        if let stroke {
            stroke.serialize(to: serializer)
        } else {
            serializer.add("stroke", "none")
        }
        super.serialize(serializer)
    }
}
