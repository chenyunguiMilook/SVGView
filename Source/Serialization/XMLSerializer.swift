//
//  File.swift
//  
//
//  Created by chenyungui on 2023/1/5.
//

import Foundation

open class Serializer {
    public static func serialize(_ serializable: SerializableBlock) -> String {
        return serializable.serialize(name: nil).description
    }

    public var name: String
    public var attributes: [String: String] = [:]
    public var value: String?
    public internal(set) var children: [Serializer] = []

    public init(name: String, attributes: [String: Any] = [:], value: Any? = nil) {
        self.name = name
        self.addAttributes(attributes)
        if let value = value {
            self.value = String(describing: value)
        }
    }

    private convenience init(xml: Serializer) {
        self.init(name: xml.name, attributes: xml.attributes, value: xml.value)
        self.addChildren(xml.children)
    }

    @discardableResult
    public func add<S: SerializableAtom>(_ key: String, _ value: S?) -> Serializer {
        if let val = value {
            self.addAttribute(name: key, value: val.serialize())
        }
        return self
    }

    @discardableResult
    public func add<S>(_ key: String, _ value: S, _ defVal: S? = nil) -> Serializer where S: SerializableAtom, S: Equatable {
        if let defVal {
            if value != defVal {
                self.addAttribute(name: key, value: value.serialize())
            }
        } else {
            self.addAttribute(name: key, value: value.serialize())
        }
        return self
    }

    @discardableResult
    public func add<S: SerializableOption>(_ key: String, _ value: S) -> Serializer {
        if !value.isDefault() {
            self.addAttribute(name: key, value: value.serialize())
        }
        return self
    }
    
    @discardableResult
    public func add<S: SerializableBlock>(_ key: String, _ block: S?) -> Serializer {
        if let block {
            self.addChild(block.serialize(name: key))
        }
        return self
    }
    
    public func add<S: SerializableBlock>(_ blocks: [S]) {
        self.addChildren(blocks.map{ $0.serialize(name: nil) })
    }
    
    public func addAttribute(name: String, value: Any) {
        let string = String(describing: value)
        if string == "\"red\"" {
            print("break here")
        }
        self.attributes[name] = string
    }

    public func addAttributes(_ attributes: [String: Any]) {
        for (key, value) in attributes {
            self.addAttribute(name: key, value: value)
        }
    }

    public func addChild(_ xml: Serializer) {
        guard xml !== self else {
            fatalError("can not add self to xml children list!")
        }
        children.append(xml)
    }

    public func addChildren(_ xmls: [Serializer]) {
        xmls.forEach { self.addChild($0) }
    }
}

extension Serializer {

    public var description: String {
        return self.toSerializerString()
    }

    public func toSerializerString() -> String {
        let meta = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        var result = ""
        var depth: Int = 0
        describe(xml: self, depth: &depth, result: &result)
        return meta + "\n" + result
    }

    private func describe(xml: Serializer, depth: inout Int, result: inout String) {
        if xml.children.isEmpty {
            result += xml.getCombine(numTabs: depth)
        }
        else {
            result += xml.getStartPart(numTabs: depth)
            depth += 1
            for child in xml.children {
                describe(xml: child, depth: &depth, result: &result)
            }
            depth -= 1
            result += xml.getEndPart(numTabs: depth)
        }
    }

    private func getAttributeString() -> String {
        return self.attributes.map { " \($0.0)=\"\($0.1)\"" }.joined()
    }

    private func getStartPart(numTabs: Int) -> String {
        return getDescription(numTabs: numTabs, closed: false)
    }

    private func getEndPart(numTabs: Int) -> String {
        return String(repeating: "\t", count: numTabs) + "</\(name)>\n"
    }

    private func getCombine(numTabs: Int) -> String {
        return self.getDescription(numTabs: numTabs, closed: true)
    }

    private func getDescription(numTabs: Int, closed: Bool) -> String {
        var attr = self.getAttributeString()
        attr = attr.isEmpty ? "" : attr + " "
        let tabs = String(repeating: "\t", count: numTabs)
        var valueString: String = ""
        if let v = self.value {
            valueString = v.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if attr.isEmpty {
            switch (closed, self.value) {
            case (true, .some(_)): return tabs + "<\(name)>\(valueString)</\(name)>\n"
            case (true, .none): return tabs + "<\(name) />\n"
            case (false, .some(_)): return tabs + "<\(name)>\(valueString)\n"
            case (false, .none): return tabs + "<\(name)>\n"
            }
        }
        else {
            switch (closed, self.value) {
            case (true, .some(_)): return tabs + "<\(name)" + attr + ">\(valueString)</\(name)>\n"
            case (true, .none): return tabs + "<\(name)" + attr + "/>\n"
            case (false, .some(_)): return tabs + "<\(name)" + attr + ">\(valueString)\n"
            case (false, .none): return tabs + "<\(name)" + attr + ">\n"
            }
        }
    }
}
