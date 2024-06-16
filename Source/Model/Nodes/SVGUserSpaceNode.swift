//
//  SVGUserSpaceNode.swift
//  Pods
//
//  Created by Alisa Mylnikova on 14/10/2020.
//

import SwiftUI

public class SVGUserSpaceNode: SVGNode {

    public enum UserSpace: String, SerializableEnum {

        case objectBoundingBox
        case userSpaceOnUse
    }

    public let node: SVGNode
    public let userSpace: UserSpace

    public init(node: SVGNode, userSpace: UserSpace) {
        self.node = node
        self.userSpace = userSpace
    }
    
    public override func serialize(_ serializer: Serializer) {
        serializer.add("userSpace", userSpace)
        super.serialize(serializer)
    }
}
