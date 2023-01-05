import SwiftUI
import Combine

public class SVGShape: SVGNode {

    @Published public var fill: SVGPaint?
    @Published public var stroke: SVGStroke?

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
