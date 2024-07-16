//
//  PlistField.swift
//  TuistPList
//
//  Created by Bruno Bilescky on 16/07/2024.
//

import Foundation


/// Simple entity to hold property name and relative key of an entry for a Plist file
public struct PlistField {
    let key: String
    let property: String
}

/// Type erases a PListEntry, removing access to the generic type the entry is backed by
private protocol PlistEntryIdentifiable {
    var key: String { get }
}

/// Empty Conformance
extension PlistEntry: PlistEntryIdentifiable { }

extension PlistField {
    static func extractFields(from instance: Any) -> [PlistField] {
        let mirror = Mirror(reflecting: instance)
        return mirror.children.reduce(into: []) { partialResult, child in
            if let identifiable = child.value as? PlistEntryIdentifiable, let label = child.label {
                partialResult.append( PlistField(key: identifiable.key, property: label))
            }
        }
    }
}
