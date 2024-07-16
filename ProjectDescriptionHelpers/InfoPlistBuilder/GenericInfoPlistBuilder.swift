//
//  GenericInfoPlistBuilder.swift
//  TuistPList
//
//  Created by Bruno Bilescky on 16/07/2024.
//

import Foundation

@dynamicMemberLookup
public struct GenericInfoPlistBuilder<Entries: PlistEntriesAggregator> {
    
    public init(rawBuilder: PlistBuilder?) {
        self.raw = rawBuilder ?? PlistBuilder()
    }
    
    private let identifiers = Entries()
    private(set) public var raw: PlistBuilder
    
    public subscript<V: PlistEntryConvertible>(dynamicMember keyPath: KeyPath<Entries, PlistEntry<V>>) -> V? {
        get {
            return raw.value(for: identifiers[keyPath: keyPath].key)
        }
        set {
            raw.setValue(newValue, for: identifiers[keyPath: keyPath].key)
        }
    }
}
