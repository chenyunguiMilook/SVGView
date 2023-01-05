//
//  Serializable.swift
//  SVGView
//
//  Created by Yuriy Strot on 18.01.2021.
//

import Foundation

public protocol SerializableAtom {
    func serialize() -> String
}

public protocol SerializableOption {

    func isDefault() -> Bool

    func serialize() -> String

}

public protocol SerializableBlock {

    func serialize(name: String?) -> Serializer
}

public class SerializableElement: SerializableBlock {

    @Published public var id: String?
    
    public var typeName: String {
        return String(describing: type(of: self))
    }

    public init(id: String? = nil) {
        self.id = id
    }

    public func serialize(name: String? = nil) -> Serializer {
        let s = Serializer(name: name ?? typeName)
        if let id {
            s.addAttribute(name: "id", value: id)
        }
        self.serialize(s)
        return s
    }
    
    public func serialize(_ serializer: Serializer) {
        
    }
}

public protocol SerializableEnum: SerializableOption, RawRepresentable, CaseIterable, Equatable where Self.RawValue == String {

}

public extension SerializableEnum {

    func isDefault() -> Bool {
        return self == type(of: self).allCases.first
    }

    func serialize() -> String {
        return rawValue
    }
}
