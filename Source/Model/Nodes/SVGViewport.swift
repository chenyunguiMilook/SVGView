import SwiftUI
import Combine

public class SVGViewport: SVGGroup {

    @Published public var width: SVGLength {
        willSet {
            self.objectWillChange.send()
        }
    }

    @Published public var height: SVGLength {
        willSet {
            self.objectWillChange.send()
        }
    }

    @Published public var viewBox: CGRect? {
        willSet {
            self.objectWillChange.send()
        }
    }

    @Published public var preserveAspectRatio: SVGPreserveAspectRatio {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    public override var typeName: String {
        return "svg"
    }

    public init(width: SVGLength, height: SVGLength, viewBox: CGRect? = .none, preserveAspectRatio: SVGPreserveAspectRatio, contents: [SVGNode] = []) {
        self.width = width
        self.height = height
        self.viewBox = viewBox
        self.preserveAspectRatio = preserveAspectRatio
        super.init(contents: contents)
    }

    override public func bounds() -> CGRect {
        if let viewBox {
            return CGRect(x: 0, y: 0, width: viewBox.right, height: viewBox.bottom)
        } else {
            switch (width, height) {
            case (.pixels(let w), .pixels(let h)):
                return CGRect(x: 0, y: 0, width: w, height: h)
            default:
                return CGRect(x: 0, y: 0, width: 800, height: 800)
            }
        }
    }

    public override func serialize(_ serializer: Serializer) {
        serializer.add("width", width.toString(), "100%")
        serializer.add("height", height.toString(), "100%")
        serializer.add("viewBox", viewBox)
        serializer.add("scaling", preserveAspectRatio.scaling)
        serializer.add("xAlign", preserveAspectRatio.xAlign)
        serializer.add("yAlign", preserveAspectRatio.yAlign)
        
        serializer.add("version", "1.2")
        serializer.add("xmlns", "http://www.w3.org/2000/svg")
        serializer.add("xmlns:xlink", "http://www.w3.org/1999/xlink")
        serializer.add("xmlns:xe", "http://www.w3.org/2001/xml-events")
        super.serialize(serializer)
    }
    
    private func computeSize(parent: CGSize) -> CGSize {
        return CGSize(width: width.toPixels(total: parent.width),
                      height: height.toPixels(total: parent.height))
    }

}
