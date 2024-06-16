//
//  SVGURLImage.swift
//  SVGView
//
//  Created by Alisa Mylnikova on 22/09/2021.
//

import SwiftUI

public class SVGURLImage: SVGImage, ObservableObject {

    public let src: String
    public let data: Data?

    public init(x: CGFloat = 0, y: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0, src: String, data: Data?) {
        self.src = src
        self.data = data
        super.init(x: x, y: y, width: width, height: height)
    }

    public override func serialize(_ serializer: Serializer) {
        serializer.add("src", src)
        super.serialize(serializer)
    }
}

