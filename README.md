## Instalation
To install this plugin add this to your Config.swift (if you don't have a Config.swift file yet, just create one inside the Tuist folder with the following content):
```swift
import ProjectDescription

let config = Config(
    plugins: [
        .git(url: "https://github.com/brunogb/TuistPListBuilder.git", tag: "0.0.1")
    ]
)
```
and the import the plugin in the files that are needed:
```swift
import TuistPList
```


## Tuist Plist plugin
When defining targets in Tuist, it is common to add a dictionary 

```swift
Target.target(
            name: "SampleAppForPlugin",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.SampleAppForPlugin",
            infoPlist: .extendingDefault(with: [
                "Test" : true
            ]),
            sources: ["SampleAppForPlugin/Sources/**"],
            resources: ["SampleAppForPlugin/Resources/**"],
            dependencies: []
        )

```
The issue with this approach is that you can mispell the correct infoPlist key. And sometimes, you don't really know the right structure to configure valid values.

This plugin allows you to use a more cohesive approach, adding autocompletion and type checking to the infoPlist creation, and it can be used to create the entitlements file as well.

```swift
Target.target(
            name: "SampleAppForPlugin",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.SampleAppForPlugin",
            infoPlist: .with { info in
                info.mainStoryboardName = "LaunchScreen.storyboard"
                info.bundleVersion = "1.0.1"
                info.supportedInterfaceOrientations = [.portrait, .upsideDown]
            },
            sources: ["SampleAppForPlugin/Sources/**"],
            resources: ["SampleAppForPlugin/Resources/**"],
            entitlements: .with { entitlements in
                entitlements.appSandboxed = false
            },
            dependencies: []
        )
```

## Custom entries (Keys not defined in the library)

And in case you need to use another key that is not defined in the library, you have access to a `raw` property, which allows you to define custom properties:
```swift
info.raw.CFCustomEntry = "abcde"
```
which will add a entry with key "CFCustomEntry" and value "abcde"

You can also add type check and autocompletion, you can create a type that conforms to `PlistEntriesAggregator` and define custom properties inside it:
```swift
public struct MyInfoPlistEntries: PlistEntriesAggregator {
    
    public let customEntry = PlistEntry<String>(key: "CFCustomEntry")
    
    public init() { }
}
```
then you can either add those properties directly into the `info` object:
```swift
extension InfoPlistBuilder {
    public subscript<V: PlistEntryConvertible>(dynamicMember keyPath: KeyPath<MyInfoPlistEntries, PlistEntry<V>>) -> V? {
        get {
            raw.value(for: MyInfoPlistEntries()[keyPath: keyPath].key)
        }
        set {
            raw.setValue(newValue, for: MyInfoPlistEntries()[keyPath: keyPath].key)
        }
    }
}

...

info.customEntry = "My Custom value"

```
or you can group them inside a property:
```swift
extension InfoPlistBuilder {
    var custom: GenericInfoPlistBuilder<MyInfoPlistEntries> {
        get {
            .init(rawBuilder: raw)
        }
        nonmutating set { }
    }
}

...

info.custom.customEntry = "My Custom tag"

```
## Custom objects
If you need to add more complex objects to the info.plist you can create a type and conform it to the `PlistEntryConvertible` protocol. This protocol asks for two methods. A converter from Plist.Value -> Your type, and another converter: Your Type -> Plist.Value

```swift
struct CustomObject: PlistEntryConvertible {
    
    let url: String
    let secret: String
    
    func toValue() -> ProjectDescription.Plist.Value {
        .dictionary([
            "URL": .string(url),
            "SECRET": .string(secret)
        ])
    }
    
    static func from(value: ProjectDescription.Plist.Value) -> CustomObject? {
        guard case let .dictionary(dictionary) = value,
              case let .string(url) = dictionary["URL"],
              case let .string(secret) = dictionary["SECRET"] else {
            return nil
        }
        return CustomObject(url: url, secret: secret)
    }
}

struct MyInfoPlistEntrys: PlistEntriesAggregator {
    
    let customTag = PlistEntry<String>(key: "CFCustomTag")
    let connection = PlistEntry<CustomObject>(key: "Custom_connection")
    
    init() { }
}

...

info.custom.connection = CustomObject(url: "my url", secret: "my secret")

```
