//
//  PListBuilder+Conformance.swift
//  TuistBased
//
//  Created by Bruno Bilescky on 16/07/2024.
//

import Foundation
import ProjectDescription

extension String: PlistEntryConvertible {
    public func toValue() -> ProjectDescription.Plist.Value {
        .string(self)
    }
    
    public static func from(value: ProjectDescription.Plist.Value) -> String? {
        guard case let .string(string) = value else {
            return nil
        }
        return string
    }
}

extension Int: PlistEntryConvertible {
    public func toValue() -> ProjectDescription.Plist.Value {
        .integer(self)
    }
    
    public static func from(value: ProjectDescription.Plist.Value) -> Int? {
        guard case let .integer(number) = value else {
            return nil
        }
        return number
    }
}

extension Double: PlistEntryConvertible {
    public func toValue() -> ProjectDescription.Plist.Value {
        .real(self)
    }
    
    public static func from(value: ProjectDescription.Plist.Value) -> Double? {
        guard case let .real(number) = value else {
            return nil
        }
        return number
    }
}

extension Bool: PlistEntryConvertible {
    public func toValue() -> ProjectDescription.Plist.Value {
        .boolean(self)
    }
    
    public static func from(value: ProjectDescription.Plist.Value) -> Bool? {
        guard case let .boolean(boolean) = value else {
            return nil
        }
        return boolean
    }
}

extension Array: PlistEntryConvertible where Element: PlistEntryConvertible {
    public func toValue() -> ProjectDescription.Plist.Value {
        .array(self.compactMap { $0.toValue() })
    }
    
    public static func from(value: ProjectDescription.Plist.Value) -> Array<Element>? {
        guard case let .array(values) = value else {
            return []
        }
        return values.compactMap { Element.from(value: $0) }
    }
}

extension Dictionary: PlistEntryConvertible where Key == String, Value: PlistEntryConvertible {
    public func toValue() -> ProjectDescription.Plist.Value {
        .dictionary(self.mapValues({ $0.toValue() }))
    }
    
    public static func from(value: ProjectDescription.Plist.Value) -> Dictionary<Key, Value>? {
        guard case let .dictionary(values) = value else {
            return [:]
        }
        return values.compactMapValues { Value.from(value: $0) }
    }
}
