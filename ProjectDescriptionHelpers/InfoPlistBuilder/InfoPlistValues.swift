//
//  InfoPlistEntrys.swift
//  TuistBased
//
//  Created by Bruno Bilescky on 16/07/2024.
//

import Foundation
import ProjectDescription

public class InfoPlistEntrys {
    
    /// Idenfier of the bundle
    public let bundleVersion = PlistEntry<String>(key: "CFBundleVersion")
    public let supportedInterfaceOrientations = PlistEntry<[UISupportedInterfaceOrientationsElement]>(key: "UISupportedInterfaceOrientations")
    public let copyrightNotice = PlistEntry<String>(key: "NSHumanReadableCopyright")
    public let bundleName = PlistEntry<String>(key: "CFBundleName")
    public let mainStoryboardName = PlistEntry<String>(key: "NSMainStoryboardFile")
    public let principalClass = PlistEntry<String>(key: "NSPrincipalClass")
    public let isUIElement = PlistEntry<Bool>(key: "LSUIElement")
    
    var allIdentifiers: [PlistField] {
        return PlistField.extractFields(from: self)
    }
    
}
