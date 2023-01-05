import SwiftUI
import Combine

public class SVGShape: SVGNode {

    @Published public var fill: SVGPaint?
    @Published public var stroke: SVGStroke?

    public override func serialize(_ serializer: Serializer) {
        fill?.serialize(key: "fill", serializer: serializer)
        stroke?.serialize(to: serializer)
        super.serialize(serializer)
    }
}
