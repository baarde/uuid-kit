# UUIDKit

[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![Swift 5.1](https://img.shields.io/badge/swift-5.1-brightgreen.svg)](https://swift.org)

UUIDKit is a Swift library for generating and working with Universally Unique Identifiers (UUIDs) as specified in [RFC 4122](https://tools.ietf.org/html/rfc4122.html).

It extends the existing Foundation's [`UUID`](https://developer.apple.com/documentation/foundation/uuid) type.

## Generating UUIDs

The default initializer for `UUID` returns a random (version 4) UUID. This library adds methods for creating version 1, version 3 and version 5 UUIDs.

### Time-based UUIDs (UUID.v1)

`UUID.v1` returns a time-based (version 1) UUID.

```swift
let uuidv1 = UUID.v1()
```

Note that this method may compromise privacy as it returns a UUID containing the Ethernet address of the user's computer.

### Random UUIDs (UUID.v4)

`UUID.v4` returns a random (version 4) UUID. You may pass a custom random number generator.

```swift
var generator = SystemRandomNumberGenerator()
let uuidv4 = UUID.v4(using: generator)
```

### Name-based UUIDs (UUID.v3 and UUID.v5)

`UUID.v3` and `UUID.v5` return name-based UUIDs using either MD5 (version 3) or SHA-1 (version 5) hashing.

```swift
let uuidv3 = UUID.v3(name: "thats.an.example", namespace: .dns)
let uuidv5 = UUID.v5(name: "http://example.com/index.html", namespace: .url)
```

Name-based UUIDs are built by combining a unique name with a namespace identifier. UUIDKit contains a list of pre-defined namespaces (`.dns`, `.url`, `.oid` and `.x500`); but any UUID may be used as a namespace.

```swift
let customNamespace = UUID.Namespace(UUID(uuidString: "34cd6bf4-3f41-4717-95ea-131762f60af8")!)
```

## License

This project is licensed for use under the MIT License (MIT). Please see the [LICENSE](LICENSE) file for more information.
