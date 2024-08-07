//
//  PListBuilder.swift
//  TuistBased
//
//  Created by Bruno Bilescky on 16/07/2024.
//

import Foundation
import ProjectDescription

@dynamicMemberLookup
public class PlistBuilder {
    
    public var values: [String: Plist.Value] = [:]
    
    init() { }
    
    public func value<Value: PlistEntryConvertible>(for key: String) -> Value? {
        guard let value = values[key] else {
            return nil
        }
        return Value.from(value: value)
    }
    
    public func setValue<Value: PlistEntryConvertible>(_ value: Value?, for key: String) {
        values[key] = value?.toValue()
    }
    
    public subscript<Value: PlistEntryConvertible>(dynamicMember key: String) -> Value? {
        get {
            value(for: key)
        }
        set {
            setValue(newValue, for: key)
        }
    }
    
    public var infoPlist: InfoPlist {
        return .extendingDefault(with: values)
    }
    
    public var entitlements: Entitlements? {
        guard !values.values.isEmpty else {
            return nil
        }
        return .dictionary(values)
    }
}

public protocol PlistEntriesAggregator {
    init()
}

public protocol PlistEntryConvertible {
    
    func toValue() -> Plist.Value
    static func from(value: Plist.Value) -> Self?
}

public class PlistEntry<T> {
    
    public let key: String
    
    public init(key: String) {
        self.key = key
    }
    
}
