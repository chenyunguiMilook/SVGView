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
    
    func testSerialization1() throws {
        let name: String = "paths-data-15-t.svg"
        try testSerializeGradient(name: name)
    }
    
    func testSerialization2() throws {
        let name: String = "paint-stroke-02-t.svg"
        try testSerializeGradient(name: name)
    }

    func testGradient() throws {
        try testOtherSVG(name: "sleepy.svg")
    }
    
    func testGradient1() throws {
        try testOtherSVG(name: "avocado.svg")
    }

    func testSerializeGradient(name: String) throws {
        let folder = Bundle.module.resourceURL!
        let dir = folder.appendingPathComponent("w3c/1.2T/svg", isDirectory: true)
        let url = dir.appendingPathComponent(name)
        guard let node = SVGParser.parse(contentsOf: url) else { return }
        print(node.serialize().description)
    }
    
    func testOtherSVG(name: String) throws {
        let folder = Bundle.module.resourceURL!
        let dir = folder.appendingPathComponent("w3c/other", isDirectory: true)
        let url = dir.appendingPathComponent(name)
        guard let node = SVGParser.parse(contentsOf: url) else { return }
        print(node.serialize().description)
    }
}
