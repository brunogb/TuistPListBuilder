//
//  EntitlementsBuilder.swift
//  TuistBased
//
//  Created by Bruno Bilescky on 06/11/2023.
//

import Foundation
import ProjectDescription

@dynamicMemberLookup
public struct EntitlementsBuilder {
    
    public typealias EntitlementValueKeyPath<Value> = KeyPath<EntitlementsValues, PlistEntry<Value>>
    
    private let identifiers = EntitlementsValues()
    private(set) public var raw: PlistBuilder
    
    public init() {
        self.raw = PlistBuilder()
    }
    
    public subscript<Value: PlistEntryConvertible>(dynamicMember keyPath: EntitlementValueKeyPath<Value>) -> Value? {
        get {
            return raw.value(for: identifiers[keyPath: keyPath].key)
        }
        set {
            raw.setValue(newValue, for: identifiers[keyPath: keyPath].key)
        }
    }
    
}

public extension Entitlements {
    
    static func with(builder closure: (inout EntitlementsBuilder) -> Void) -> Entitlements? {
        var builder = EntitlementsBuilder()
        closure(&builder)
        return builder.raw.entitlements
    }
    
}
