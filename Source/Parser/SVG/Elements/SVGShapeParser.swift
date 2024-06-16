//
//  SVGShapeParser.swift
//  SVGView
//
//  Created by Yuri Strot on 29.05.2022.
//

import CoreGraphics

class SVGShapeParser: SVGBaseElementParser {

    override func doParse(context: SVGNodeContext, delegate: (XMLElement) -> SVGNode?) -> SVGNode? {
        guard let locus = parseLocus(context: context) else { return nil }
        locus.fill = SVGHelper.parseFill(context.styles, context.index)
        locus.stroke = SVGHelper.parseStroke(context.styles, index: context.index)
        return locus
    }

    /// should be overwritten by inheritor
    func parseLocus(context: SVGNodeContext) -> SVGShape? {
        return nil
    }

}

class SVGRectParser: SVGShapeParser {
    override func parseLocus(context: SVGNodeContext) -> SVGShape? {
        let rx = context.optional(SVGAttributes.rx)
        let ry = context.optional(SVGAttributes.ry)
        return SVGRect(
            x: context.value(SVGAttributes.x),
            y: context.value(SVGAttributes.y),
            width: context.value(SVGAttributes.width),
            height: context.value(SVGAttributes.height),
            rx: rx ?? ry ?? 0,
            ry: ry ?? rx ?? 0)
    }
}

class SVGCircleParser: SVGShapeParser {
    override func parseLocus(context: SVGNodeContext) -> SVGShape? {
        return SVGCircle(
            cx: context.value(SVGAttributes.cx),
            cy: context.value(SVGAttributes.cy),
            r: context.value(SVGAttributes.r))
    }
}

class SVGEllipseParser: SVGShapeParser {
    override func parseLocus(context: SVGNodeContext) -> SVGShape? {
        return SVGEllipse(
            cx: context.value(SVGAttributes.cx),
            cy: context.value(SVGAttributes.cy),
            rx: context.value(SVGAttributes.rx),
            ry: context.value(SVGAttributes.ry))
    }
}

class SVGLineParser: SVGShapeParser {
    override func parseLocus(context: SVGNodeContext) -> SVGShape? {
        return SVGLine(context.value(SVGAttributes.x1), context.value(SVGAttributes.y1), context.value(SVGAttributes.x2), context.value(SVGAttributes.y2))
    }
}

class SVGPolygonParser: SVGShapeParser {
    override func parseLocus(context: SVGNodeContext) -> SVGShape? {
        let points = SVGHelper.parsePointsArray(context.property("points") ?? "")
        return SVGPolygon(points)
    }
}

class SVGPolylineParser: SVGShapeParser {
    override func parseLocus(context: SVGNodeContext) -> SVGShape? {
        let points = SVGHelper.parsePointsArray(context.property("points") ?? "")
        return SVGPolyline(points)
    }
}

class SVGPathParser: SVGShapeParser {
    override func parseLocus(context: SVGNodeContext) -> SVGShape? {
        let segments = PathReader(input: context.property("d") ?? "").read()
        return SVGPath(segments: segments, fillRule: context.style("fill-rule") == "evenodd" ? .evenOdd : .winding)
    }
}
