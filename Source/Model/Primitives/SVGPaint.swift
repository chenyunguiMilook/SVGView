//
//  SVGPaint.swift
//  SVGView
//
//  Created by Yuriy Strot on 19.01.2021.
//

import Foundation
import SwiftUI

public class SVGPaint: SerializableElement, SerializableDecoration {

    public override init(id: String? = nil) {
        super.init(id: id)
    }
    
    public override func serialize(_ serializer: Serializer) {
        if let id {
            serializer.add("id", id)
        }
    }
    
    public func serialize(to serializer: Serializer) {
        
    }
    
    func serialize(key: String, serializer: Serializer) {
        
    }

    public func opacity(_ opacity: Double) -> SVGPaint {
        return self
    }

}

