//
//  UISupportedInterfaceOrientationsElement.swift
//  TuistBased
//
//  Created by Bruno Bilescky on 14/07/2024.
//

import Foundation
import ProjectDescription

public enum UISupportedInterfaceOrientationsElement: PlistEntryConvertible {
    
    private static let portraitKey = "UIInterfaceOrientationPortrait"
    private static let upsideDownKey = "UIInterfaceOrientationPortraitUpsideDown"
    private static let landscapeLeftKey = "UIInterfaceOrientationLandscapeLeft"
    private static let landscapeRightKey = "UIInterfaceOrientationLandscapeRight"
    
    case portrait
    case upsideDown
    case landscapeLeft
    case landscapeRight
    
    public func toValue() -> Plist.Value {
        switch self {
        case .portrait: return .string(Self.portraitKey)
        case .upsideDown: return .string(Self.upsideDownKey)
        case .landscapeLeft: return .string(Self.landscapeLeftKey)
        case .landscapeRight: return .string(Self.landscapeRightKey)
        }
    }
    
    public static func from(value: Plist.Value) -> UISupportedInterfaceOrientationsElement? {
        guard case let .string(key) = value else {
            return nil
        }
        switch key {
        case Self.portraitKey: return .portrait
        case Self.upsideDownKey: return .upsideDown
        case Self.landscapeLeftKey: return .landscapeLeft
        case Self.landscapeRightKey: return .landscapeRight
        default: return nil
        }
    }
    
}
