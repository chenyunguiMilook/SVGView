import SwiftUI
import Combine

public class SVGNode: SerializableElement {

    @Published public var transform: CGAffineTransform = CGAffineTransform.identity
    @Published public var opaque: Bool
    @Published public var opacity: Double
    @Published public var fillOpacity: Double
    @Published public var clip: SVGNode?
    @Published public var mask: SVGNode?
    public weak var parent: SVGGroup?

    var gestures = [AnyGesture<()>]()

    public var globalTransform: CGAffineTransform {
        if let parent {
            return self.transform * parent.globalTransform
        } else {
            return self.transform
        }
    }
    
    public init(transform: CGAffineTransform = .identity, opaque: Bool = true, opacity: Double = 1, fillOpacity: Double = 1, clip: SVGNode? = nil, mask: SVGNode? = nil, id: String? = nil) {
        self.transform = transform
        self.opaque = opaque
        self.opacity = opacity
        self.fillOpacity = fillOpacity
        self.clip = clip
        self.mask = mask
        super.init(id: id)
    }

    public func bounds() -> CGRect {
        let frame = frame()
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    public func frame() -> CGRect {
        fatalError()
    }

    public func getNode(byId id: String) -> SVGNode? {
        return self.id == id ? self : .none
    }
    
    public override func serialize(_ serializer: Serializer) {
        if !transform.isIdentity {
            serializer.add("transform", transform)
        }
        serializer.add("opacity", opacity, 1)
        serializer.add("fill-opacity", opacity, 1)
        serializer.add("opaque", opaque, true)
        serializer.add("clip", clip).add("mask", mask)
    }
}

extension SVGNode {
    
    public func updateParentNode(_ parent: SVGGroup?) {
        self.parent = parent
        if let group = self as? SVGGroup {
            for child in group.contents {
                child.updateParentNode(group)
            }
        }
    }
}
