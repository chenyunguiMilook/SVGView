import SwiftUI
import Combine

public class SVGText: SVGNode, ObservableObject {

    @Published public var text: String
    @Published public var font: SVGFont?
    @Published public var fill: SVGPaint?
    @Published public var stroke: SVGStroke?
    @Published public var textAnchor: HorizontalAlignment = .leading

    public override var typeName: String {
        return "text"
    }
    
    public init(text: String, font: SVGFont? = nil, fill: SVGPaint? = SVGColor.black, stroke: SVGStroke? = nil, textAnchor: HorizontalAlignment = .leading, transform: CGAffineTransform = .identity, opaque: Bool = true, opacity: Double = 1, clip: SVGUserSpaceNode? = nil, mask: SVGNode? = nil) {
        self.text = text
        self.font = font
        self.fill = fill
        self.stroke = stroke
        self.textAnchor = textAnchor
        super.init(transform: transform, opaque: opaque, opacity: opacity, clip: clip, mask: mask)
    }

    public override func serialize(_ serializer: Serializer) {
        serializer.value = text
        font?.serialize(to: serializer)
        serializer.add("text-anchor", textAnchor)
        fill?.serialize(key: "fill", serializer: serializer)
        stroke?.serialize(to: serializer)
        super.serialize(serializer)
    }
}
