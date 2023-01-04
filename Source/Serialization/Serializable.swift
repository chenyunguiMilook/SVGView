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

    func serialize(_ serializer: Serializer)

}

public protocol SerializableElement: SerializableBlock {

    var id: String? { get }

    var typeName: String { get }

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
