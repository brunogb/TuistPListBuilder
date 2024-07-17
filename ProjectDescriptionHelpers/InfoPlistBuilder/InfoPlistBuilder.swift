//
//  InfoPListBuilder.swift
//  TuistBased
//
//  Created by Bruno Bilescky on 06/11/2023.
//

import Foundation
import ProjectDescription

@dynamicMemberLookup
public struct InfoPlistBuilder {
    
    public init() {
        self.raw = PlistBuilder()
    }
    
    private let identifiers = InfoPlistEntries()
    private(set) public var raw: PlistBuilder
    
    public subscript<V: PlistEntryConvertible>(dynamicMember keyPath: KeyPath<InfoPlistEntries, PlistEntry<V>>) -> V? {
        get {
            return raw.value(for: identifiers[keyPath: keyPath].key)
        }
        set {
            raw.setValue(newValue, for: identifiers[keyPath: keyPath].key)
        }
    }
    
    public var privacy: GenericInfoPlistBuilder<PrivacyPlistEntries> {
        get {
            .init(rawBuilder: raw)
        }
        nonmutating set { }
    }
}

public extension InfoPlist {
    
    static func with(builder closure: ( inout InfoPlistBuilder) -> Void) -> InfoPlist {
        var builder = InfoPlistBuilder()
        closure(&builder)
        return builder.raw.infoPlist
    }
    
}
