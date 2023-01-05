import SwiftUI

public class SVGFont: SerializableElement {

    public let name: String
    public let size: CGFloat
    public let weight: String

    public init(name: String = "Serif", size: CGFloat = 16, weight: String = "normal") {
        self.name = name
        self.size = size
        self.weight = weight
        super.init(id: nil)
    }

    public func toSwiftUI() -> Font {
        return Font.custom(name, size: size)//.weight(fontWeight)
    }

    public override func serialize(_ serializer: Serializer) {
        serializer
            .add("name", name, "Serif")
            .add("size", size, 16)
            .add("weight", weight, "normal")
    }
}

extension SVGFont: SerializableDecoration {
    public func serialize(to serializer: Serializer) {
        serializer
            .add("font-family", name, "Serif")
            .add("font-size", size, 16)
            .add("weight", weight, "normal")
    }
}


