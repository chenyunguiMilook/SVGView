//
//  SVGLinker.swift
//  SVGView
//
//  Created by Yuri Strot on 27.05.2022.
//

import Foundation

public protocol SVGLinkerProtocol: Sendable {
    func load(src: String) throws -> Data?
}

public struct SVGLinker: SVGLinkerProtocol {
    
    public init() {
        
    }
    public func load(src: String) throws -> Data? {
        return nil
    }
}

public struct SVGURLLinker: SVGLinkerProtocol {

    public let url: URL

    public init(url: URL) {
        self.url = url
    }
    
    public init(relativeTo url: URL) {
        self.url = url.deletingLastPathComponent()
    }

    public func load(src: String) throws -> Data? {
        let url = url.appendingPathComponent(src)
        return try Data(contentsOf: url)
    }
}
