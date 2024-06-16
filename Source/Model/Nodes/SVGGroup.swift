import SwiftUI
import Combine

public class SVGGroup: SVGNode, ObservableObject {

    public override var typeName: String { return "g" }
    @Published public var contents: [SVGNode] = []

    public init(contents: [SVGNode], transform: CGAffineTransform = .identity, opaque: Bool = true, opacity: Double = 1, clip: SVGUserSpaceNode? = nil, mask: SVGNode? = nil) {
        super.init(transform: transform, opaque: opaque, opacity: opacity, clip: clip, mask: mask)
        self.contents = contents
    }

    override public func bounds() -> CGRect {
        contents.map { $0.bounds() }.reduce(contents.first?.bounds() ?? CGRect.zero) { $0.union($1) }
    }

    override public func getNode(byId id: String) -> SVGNode? {
        if let node = super.getNode(byId: id) {
            return node
        }
        for node in contents {
            if let node = node.getNode(byId: id) {
                return node
            }
        }
        return .none
    }

    public override func serialize(_ serializer: Serializer) {
        super.serialize(serializer)
        serializer.add(contents)
    }
    
    public func addChild(_ child: SVGNode) {
        self.contents.append(child)
    }
}

