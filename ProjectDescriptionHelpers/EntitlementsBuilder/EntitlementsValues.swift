//
//  EntitlementsValues.swift
//  TuistBased
//
//  Created by Bruno Bilescky on 16/07/2024.
//

import Foundation
import ProjectDescription

public class EntitlementsValues {
    public let appSandboxed = PlistEntry<Bool>(key: "com.apple.security.app-sandbox")
    public let apsEnvironment = PlistEntry<String>(key: "aps-environment")
    
    var allIdentifiers: [PlistField] {
        return PlistField.extractFields(from: self)
    }
}
