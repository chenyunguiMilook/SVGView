//
//  File.swift
//  
//
//  Created by chenyungui on 2023/1/5.
//

import Foundation
import XCTest
@testable import SVGView

public class SerializerTest: XCTestCase {
    
    func testSerializeGradient() throws {
        let folder = Bundle.module.resourceURL!
        let dir = folder.appendingPathComponent("w3c/1.2T/svg", isDirectory: true)
        let url = dir.appendingPathComponent("paths-data-15-t.svg")
        guard let node = SVGParser.parse(contentsOf: url) else { return }
        print(node.serialize().description)
    }
}
