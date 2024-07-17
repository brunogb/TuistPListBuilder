//
//  InfoPlistEntrys.swift
//  TuistBased
//
//  Created by Bruno Bilescky on 16/07/2024.
//

import Foundation
import ProjectDescription

public struct InfoPlistEntries {
    
    /// Idenfier of the bundle
    public let bundleVersion = PlistEntry<String>(key: "CFBundleVersion")
    public let supportedInterfaceOrientations = PlistEntry<[UISupportedInterfaceOrientationsElement]>(key: "UISupportedInterfaceOrientations")
    public let copyrightNotice = PlistEntry<String>(key: "NSHumanReadableCopyright")
    public let bundleName = PlistEntry<String>(key: "CFBundleName")
    public let mainStoryboardName = PlistEntry<String>(key: "NSMainStoryboardFile")
    public let principalClass = PlistEntry<String>(key: "NSPrincipalClass")
    public let isUIElement = PlistEntry<Bool>(key: "LSUIElement")
    public let applicationCategoryType = PlistEntry<String>(key: "LSApplicationCategoryType")
    public let internalTestingOnly = PlistEntry<Bool>(key: "TFInternalTestingOnly")
    public let cameraReactionEffectsEnabled = PlistEntry<Bool>(key: "NSCameraReactionEffectsEnabled")
    public let cameraPortraitEffectEnabled = PlistEntry<Bool>(key: "NSCameraPortraitEffectEnabled")
    public let cameraStudioLightEnabled = PlistEntry<Bool>(key: "NSCameraStudioLightEnabled")
    
    var allIdentifiers: [PlistField] {
        return PlistField.extractFields(from: self)
    }
    
}

public struct PrivacyLocationTemporary: PlistEntryConvertible {
    public let entries: [PrivacyLocationTemporaryEntry]
    
    public init(_ entries: [PrivacyLocationTemporaryEntry]) {
        self.entries = entries
    }
    
    public func toValue() -> ProjectDescription.Plist.Value {
        let dictionary: [String: Plist.Value] = entries.reduce(into: [:], { partialResult, entry in
            partialResult[entry.key] = .string(entry.reason)
        })
        return .dictionary(dictionary)
    }
    
    public static func from(value: ProjectDescription.Plist.Value) -> PrivacyLocationTemporary? {
        guard
            case let .dictionary(dictionary) = value
        else { return nil }
        let entries: [PrivacyLocationTemporaryEntry] = dictionary.keys.compactMap { key in
            guard
                case let .string(string) = dictionary[key]
            else { return nil }
            return PrivacyLocationTemporaryEntry(key: key, reason: string)
        }
        return PrivacyLocationTemporary(entries)
    }
}

extension PrivacyLocationTemporary: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = PrivacyLocationTemporaryEntry
    public init(arrayLiteral elements: PrivacyLocationTemporaryEntry...) {
        self.entries = elements
    }
}

public struct PrivacyLocationTemporaryEntry {
    public let key: String
    public let reason: String
    
    public init(key: String, reason: String) {
        self.key = key
        self.reason = reason
    }
    
    public static func entry(_ key: String, reason: String) -> PrivacyLocationTemporaryEntry {
        .init(key: key, reason: reason)
    }
}

public struct PrivacyPlistEntries: PlistEntriesAggregator {
    
    public typealias StringPlistEntry = PlistEntry<String>
    
    /// A message that tells the user why the app needs access to files managed by a file provider.
    /// * macOS 10.15+
    /// * The user implicitly grants your app access to a file managed by a file provider when selecting the file in an Open or Save panel, dragging it onto your app, or opening it in Finder. Your app can access that file right away and any time in the future. In addition, if your app creates a new file managed by a file provider, the app can access that file without user consent.
    /// The first time your app tries to access a file managed by a file provider without implied user consent, the system prompts the user for permission. Add the NSFileProviderDomainUsageDescription key to your app’s Information Property List file to provide a string for the prompt that explains why your app needs access. The usage description is optional, but highly recommended.
    /// After the user chooses whether to grant access, the system remembers the user’s choice.
    /// * To reset permissions, use the tccutil command line utility with your app’s bundle ID: **$ tccutil reset FileProviderDomain \<bundleID\>**
    public let fileProviderDomain = StringPlistEntry(key: "NSFileProviderDomainUsageDescription")
    
    /// A message that tells the user why the app needs access to Bluetooth.
    /// * iOS 13.0+    iPadOS 13.0+    macOS 11.0+    tvOS 13.0+    visionOS 1.0+    watchOS 6.0+
    /// * **This key is required if your app uses the device’s Bluetooth interface.**
    public let bluetoothAlways = StringPlistEntry(key: "NSBluetoothAlwaysUsageDescription")
    
    /// A message that tells the user why the app is requesting access to the device’s camera.
    /// * iOS 7.0+    iPadOS 7.0+    macOS 10.14+    tvOS 17.0+    visionOS 1.0+
    /// * **This key is required if your app uses APIs that access the device’s camera.**
    public let camera = StringPlistEntry(key: "NSCameraUsageDescription")
    
    /// A message that tells the user why the app is requesting the ability to authenticate with Face ID.
    /// * iOS 11.0+    iPadOS 11.0+
    /// * **This key is required if your app uses APIs that access Face ID. Also note that App Clips can’t use Face ID.**
    public let faceID = StringPlistEntry(key: "NSFaceIDUsageDescription")
    
    /// A message that tells people why the app is requesting access to read and write their calendar data.
    /// * iOS 17.0+    iPadOS 17.0+    Mac Catalyst 17.0+    macOS 14.0+    visionOS 1.0+    watchOS 10.0+
    /// * If your app needs to create calendar events but doesn’t need to read them, use **.calendarWriteOnlyAccess** instead.
    /// * If your app runs on iOS 17 or later and presents an **`EKEventEditViewController`** to allow people to create calendar events, you don’t need to request calendar access.
    public let calendarFullAccess = StringPlistEntry(key: "NSCalendarsFullAccessUsageDescription")
    
    /// A message that tells people why the app is requesting access to create calendar events.
    /// * iOS 17.0+    iPadOS 17.0+    Mac Catalyst 17.0+    macOS 14.0+    visionOS 1.0+    watchOS 10.0+
    /// * If your app needs to read calendar events in addition to creating them, use **calendarFullAccess** instead.
    /// * If your app runs on iOS 17 or later and presents an **`EKEventEditViewController`** to allow people to create calendar events, you don’t need to request calendar access.
    public let calendarWriteOnlyAccess = StringPlistEntry(key: "NSCalendarsWriteOnlyAccessUsageDescription")
    
    /// A message that tells the user why the app is requesting access to the user’s contacts.
    /// * iOS 6.0+    iPadOS 6.0+    macOS 10.8+    visionOS 1.0+
    /// * **This key is required if your app uses APIs that access the user’s contacts.**
    public let contacts = StringPlistEntry(key: "NSContactsUsageDescription")
    
    /// A message that tells the user why the app needs access to the user’s Desktop folder.
    /// * macOS 10.15+
    /// * The user implicitly grants your app access to a file in the Desktop folder when selecting the file in an Open or Save panel, dragging it onto your app, or opening it in Finder. Your app can access that file right away and any time in the future. In addition, if your app creates a new file in the Desktop folder, the app can access that file without user consent.
    /// * The first time your app tries to access a file in the user’s Desktop folder without implied user consent, the system prompts the user for permission to access the folder’s contents. Add the NSDesktopFolderUsageDescription key to your app’s Information Property List file to provide a message that explains why your app needs access. The usage description is optional, but highly recommended.
    /// * App Sandbox enforces stricter limits on Desktop folder access, so that policy may supersede this one if your app enables sandboxing. See App Sandbox for more information.
    /// * After the user chooses whether to grant access, the system remembers the user’s choice. To reset permissions, use the tccutil command line utility with your app’s bundle ID: **`$ tccutil reset SystemPolicyDesktopFolder \<bundleID\>`**
    public let desktopFolder = StringPlistEntry(key: "NSDesktopFolderUsageDescription")
    
    /// A message that tells the user why the app needs access to the user’s Documents folder.
    /// * macOS 10.15+
    /// * The user implicitly grants your app access to a file in the Documents folder when selecting the file in an Open or Save panel, dragging it onto your app, or opening it in Finder. Your app can access that file right away and any time in the future. In addition, if your app creates a new file in the Documents folder, the app can access that file without user consent.
    /// * The first time your app tries to access a file in the user’s Documents folder without implied user consent, the system prompts the user for permission to access the folder’s contents. Add the NSDocumentsFolderUsageDescription key to your app’s Information Property List file to provide a message that explains why your app needs access. The usage description is optional, but highly recommended.
    /// * App Sandbox enforces stricter limits on Documents folder access, so that policy may supersede this one if your app enables sandboxing. See App Sandbox for more information.
    /// * After the user chooses whether to grant access, the system remembers the user’s choice. To reset permissions, use the tccutil command line utility with your app’s bundle ID: **`$ tccutil reset SystemPolicyDocumentsFolder \<bundleID\>`**
    public let documentsFolder = StringPlistEntry(key: "NSDocumentsFolderUsageDescription")
    
    /// A message that tells the user why the app needs access to the user’s Downloads folder.
    /// * macOS 10.15+
    /// * The user implicitly grants your app access to a file in the Downloads folder when selecting the file in an Open or Save panel, dragging it onto your app, or opening it in Finder. Your app can access that file right away and any time in the future. In addition, if your app creates a new file in the Downloads folder, the app can access that file without user consent.
    /// * The first time your app tries to access a file in the user’s Downloads folder without implied user consent, the system prompts the user for permission to access the folder’s contents. Add the NSDownloadsFolderUsageDescription key to your app’s Information Property List file to provide a message that explains why your app needs access. The usage description is optional, but highly recommended.
    /// * App Sandbox enforces stricter limits on Downloads folder access, so that policy may supersede this one if your app enables sandboxing. See App Sandbox for more information.
    /// * After the user chooses whether to grant access, the system remembers the user’s choice. To reset permissions, use the tccutil command line utility with your app’s bundle ID: **`$ tccutil reset SystemPolicyDownloadsFolder \<bundleID\>`**
    public let downloadsFolder = StringPlistEntry(key: "NSDownloadsFolderUsageDescription")
    
    /// A message that tells the user why the app is requesting access to financial data stored in Wallet.
    /// * iOS 17.4+    iPadOS 17.4+
    public let financialData = StringPlistEntry(key: "NSFinancialDataUsageDescription")
    
    /// A message to the user that explains why the app requested permission to read samples from the HealthKit store.
    /// * iOS 8.0+    iPadOS 8.0+    visionOS 1.0+
    /// * **This key is required if your app uses APIs that access the user’s heath data.**
    public let healthShare = StringPlistEntry(key: "NSHealthShareUsageDescription")
    
    /// A message to the user that explains why the app requested permission to read clinical records.
    /// * iOS 12.0+    iPadOS 12.0+    visionOS 1.0+
    /// * **This key is required if your app uses APIs that access the user's clinical records.**
    public let healthClinicHealthRecordsShare = StringPlistEntry(key: "NSHealthClinicalHealthRecordsShareUsageDescription")
    
    /// A message to the user that explains why the app requested permission to save samples to the HealthKit store.
    /// iOS 8.0+    iPadOS 8.0+    visionOS 1.0+
    /// * **This key is required if your app uses APIs that update the user’s health data.**
    public let healthUpdate = StringPlistEntry(key: "NSHealthUpdateUsageDescription")
    
    /// A message that tells the user why the app is requesting access to the user’s HomeKit configuration data.
    /// * iOS 8.0+    iPadOS 8.0+    visionOS 1.0+    watchOS 2.0+
    /// * **This key is required if your app uses APIs that access the user’s HomeKit configuration data.**
    public let homeKit = StringPlistEntry(key: "NSHomeKitUsageDescription")
    
    /// A message that tells the user why the app is requesting identity information.
    /// * iOS 16.0+    iPadOS 16.0+    visionOS 1.0+
    /// * **This key is required if your app uses APIs that access identity information from Wallet.**
    public let walletIdentity = StringPlistEntry(key: "NSIdentityUsageDescription")
    
    /// A message that tells the user why the app is requesting access to the local network.
    /// * iOS 14.0+    iPadOS 14.0+    macOS 11.0+    tvOS 14.0+    visionOS 1.0+
    /// * Any app that uses the local network, directly or indirectly, should include this description. This includes apps that use Bonjour and services implemented with Bonjour, as well as direct unicast or multicast connections to local hosts.
    public let localNetwork = StringPlistEntry(key: "NSLocalNetworkUsageDescription")
    
    /// A message that tells the user why the app is requesting access to the user’s location information at all times.
    /// * iOS 11.0+     iPadOS 11.0+    visionOS 1.0+
    /// * **This key is required if your iOS app uses APIs that access the user’s location information at all times.**
    /// * Use this key if your iOS app accesses location information while running in the background. If your app only needs location information when in the foreground, use **.locationWhenInUse** instead.
    /// * If you need location information in a macOS app, use **.location** instead. If your iOS app deploys to versions earlier than iOS 11, use **.locationAlways**.
    public let locationAlwaysAndWhenInUse = StringPlistEntry(key: "NSLocationAlwaysAndWhenInUseUsageDescription")
    
    /// A message that tells the user why the app is requesting access to the user's location at all times. (DEPRECATED)
    /// * iOS 8.0–10.0 (**Deprecated**)    iPadOS 8.0–10.0 (**Deprecated**)
    /// * Use this key if your iOS app accesses location information in the background, and you deploy to a target earlier than iOS 11. In that case, add both this and **.locationAlwaysAndWhenInUse** property with the same message. Apps running on older versions of the OS use the message associated with **.locationAlways**, while apps running on later versions use the one associated with **.locationAlwaysAndWhenInUse**.
    public let locationAlways = StringPlistEntry(key: "NSLocationAlwaysUsageDescription")
    
    /// A Boolean value that indicates whether the app requests reduced location accuracy by default.
    /// * iOS 14.0+    iPadOS 14.0+    visionOS 1.0+    watchOS 7.0+
    /// * Include this key in your information property list to set your app’s default behavior for location accuracy when it calls the Core Location framework. Set the key value to true to prompt the user for reduced accuracy by default; set it to false to prompt for full location accuracy. If you don't include that key in your Info.plist, that's equivalent to setting it to false.
    /// * When this key is set to true, all Core Location services (location updates, visit monitoring, significant location change, fence monitoring) receive service at the reduced-accuracy service level. Users will see that your app is asking for reduced accuracy because the location authorization prompt will show a map with an approximate location, and your app will have the Precise Location toggled off in Settings > Privacy > Location Services . These indicators of an app's improved privacy are ones that users may value.
    /// * Setting **.locationDefaultAccuracyReduced** determines the default type of authorization your app gets, but users can override it any time in Settings. Users always control the level of location accuracy they want to share, and can change precision settings in Settings > Privacy > Location Services by selecting Precise Location for your app.
    public let locationDefaultAccuracyReduced = PlistEntry<Bool>(key: "NSLocationDefaultAccuracyReduced")
    
    /// A collection of messages that explain why the app is requesting temporary access to the user’s location.
    /// * iOS 14.0+ iPadOS 14.0+ macOS 11.0+ visionOS 1.0+
    /// * Use this key if your app needs temporary access to full accuracy location information. Provide a dictionary of messages that address different use cases, keyed by strings that you define.
    /// * When you request access, select among the messages at run time by providing the associated key to the **requestTemporaryFullAccuracyAuthorization(withPurposeKey:)** method
    public let locationTemporary = PlistEntry<PrivacyLocationTemporary>(key: "NSLocationTemporaryUsageDescriptionDictionary")
    
    /// A message that tells the user why the app is requesting access to the user’s location information.
    /// * iOS 6.0–8.0 (**Deprecated**)    iPadOS 6.0–8.0 (**Deprecated**)    macOS 10.14+
    /// * Use this key in a macOS app that accesses the user’s location information. In an iOS app, use **.locationWhenInUse** or **.locationAlwaysAndWhenInUse** instead.
    /// * **This key is required if your macOS app uses APIs that access the user’s location information.**
    public let location = StringPlistEntry(key: "NSLocationUsageDescription")
    
    /// A message that tells the user why the app is requesting access to the user’s location information while the app is running in the foreground.
    /// * iOS 11.0+    iPadOS 11.0+    visionOS 1.0+
    /// * Use this key if your iOS app accesses location information only when running in the foreground. If your app needs location information when in the background, use **.locationAlwaysAndWhenInUse** instead.
    /// * If you need location information in a macOS app, use **.location** instead.
    public let locationWhenInUse = StringPlistEntry(key: "NSLocationWhenInUseUsageDescription")
    
    /// A message that tells the user why the app is requesting access to the user’s media library.
    /// * iOS 2.0+    iPadOS 2.0+    visionOS 1.0+
    /// * Set the value of this key to a user-readable description of how you intend to use the user’s media library. The first time your app access the user’s media library, the system prompts the user to grant or deny authorization for your app to do so. The system includes this key’s description in the dialog it displays to the user.
    /// * **The system requires this key if your app uses APIs that access the user’s media library.**
    public let appleMusic = StringPlistEntry(key: "NSAppleMusicUsageDescription")
    
    /// A message that tells the user why the app is requesting access to the device’s microphone.
    /// * iOS 7.0+    iPadOS 7.0+    macOS 10.14+    tvOS 17.0+    visionOS 1.0+    watchOS 4.0+
    /// * **This key is required if your app uses APIs that access the device’s microphone.**
    public let microphone = StringPlistEntry(key: "NSMicrophoneUsageDescription")
    
    /// A message that tells the user why the app is requesting access to the device’s motion data.
    /// iOS 7.0+    iPadOS 7.0+    macOS 10.15+    visionOS 1.0+
    /// * **This key is required if your app uses APIs that access the device’s motion data, including CMSensorRecorder, CMPedometer, CMMotionActivityManager, and CMMovementDisorderManager. If you don’t include this key, your app will crash when it attempts to access motion data.**
    public let motion = StringPlistEntry(key: "NSMotionUsageDescription")
    
    /// A request for user permission to begin an interaction session with nearby devices.
    /// * iOS 15.0+    iPadOS 15.0+    watchOS 8.0+
    /// * Before an app starts an interaction session, the system checks whether the user agrees to share their relative distance and direction with a nearby peer. The first time the app runs, the framework presents a prompt that displays the value of this key contained in your project’s Info.plist. The system persists the user’s choice in Settings. After your app runs for the first time, it consults the user preference in Settings before it begins a new interaction session.
    public let nearbyInteractions = StringPlistEntry(key: "NSNearbyInteractionUsageDescription")
    
    /// A message that tells the user why the app is requesting access to the device’s NFC hardware.
    /// * iOS 11.0+    iPadOS 11.0+
    /// * **You’re required to provide this key if your app uses APIs that access the NFC hardware.**
    public let nfcReader = StringPlistEntry(key: "NFCReaderUsageDescription")
    
    /// A message that tells the user why the app is requesting add-only access to the user’s photo library.
    /// * iOS 11.0+    iPadOS 11.0+    visionOS 1.0+
    /// * **This key is required if your app uses APIs that have write access to the user’s photo library.**
    public let photoLibraryAdd = StringPlistEntry(key: "NSPhotoLibraryAddUsageDescription")
    
    /// A message that tells the user why the app is requesting access to the user’s photo library.
    /// * iOS 6.0+    iPadOS 6.0+    macOS 10.14+    visionOS 1.0+
    /// * If your app only adds assets to the photo library and does not read assets, use the **.photoLibraryAdd** property instead.
    /// * **This key is required if your app uses APIs that have read or write access to the user’s photo library.**
    public let photoLibrary = StringPlistEntry(key: "NSPhotoLibraryUsageDescription")
    
    /// A message that tells people why the app is requesting access to read and write their reminders data.
    /// iOS 17.0+    iPadOS 17.0+    Mac Catalyst 17.0+    macOS 14.0+    visionOS 1.0+    watchOS 10.0+
    /// * **This key is required if your app uses APIs that access the person’s reminder data.**
    public let remindersFullAccess = StringPlistEntry(key: "NSRemindersFullAccessUsageDescription")
    
    /// A message that tells people why the app is requesting access to their reminders. (DEPRECATED)
    /// * iOS 6.0–17.0 (**Deprecated**)    iPadOS 6.0–17.0 (**Deprecated**)    Mac Catalyst 13.0–17.0 (**Deprecated**)    macOS 10.14–14.0 (**Deprecated**)    watchOS 6.0–10.0 (**Deprecated**)
    /// * **.reminders** has been deprecated; use **.remindersFullAccess** instead.
    public let reminders = StringPlistEntry(key: "NSRemindersUsageDescription")
    
    /// A message that tells the user why the app is requesting to send user data to Siri.
    /// * iOS 10.0+    iPadOS 10.0+    visionOS 1.0+
    /// * **This key is required if your app uses APIs that send user data to Siri.**
    public let siri = StringPlistEntry(key: "NSSiriUsageDescription")
    
    /// A message that tells the user why the app is requesting to send user data to Apple’s speech recognition servers.
    /// * iOS 10+    iPadOS 10+    macOS 10.15+    visionOS 1.0+
    /// * **This key is required if your app uses APIs that send user data to Apple’s speech recognition servers.**
    public let speechRecognition = StringPlistEntry(key: "NSSpeechRecognitionUsageDescription")
    
    /// A message that tells the user why the app is requesting to send notifications
    public let userNotification = StringPlistEntry(key: "NSUserNotificationsUsageDescription")
    
    /// A message that informs the user why an app is requesting permission to use data for tracking the user or the device.
    /// * iOS 14.0+    iPadOS 14.0+    tvOS 14.0+    visionOS 1.0+
    /// * If your app calls the App Tracking Transparency API, you must provide custom text, known as a usage-description string, which displays as a system-permission alert request. The usage-description string tells the user why the app is requesting permission to use data for tracking the user or the device. The user has the option to grant or deny the authorization request. If you don’t include a usage-description string, your app may crash when a user first launches it.
    /// * Make sure your app requests permission to track sometime before tracking occurs. This could be at first launch or when using certain features in your app. For example, when signing on with a third-party SSO.
    public let userTracking = StringPlistEntry(key: "NSUserTrackingUsageDescription")
    
    public init() { }
    
}
