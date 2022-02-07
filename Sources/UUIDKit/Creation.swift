import Foundation

extension UUID {
    /// The nil UUID with all 128 bits set to zero.
    public static let null = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    
    /// Creates a new time-based (version 1) UUID.
    ///
    /// The UUID is built from the current time and a fixed randomly-generated node identifier.
    ///
    /// This method does not use the Ethernet address because retrieving the Ethernet address is
    /// platform-dependent, leaks private information and is not guaranteed to actually return a
    /// unique identifier.
    ///
    /// - warning: Though randomly-generated, the node identifier is the same for all UUIDs created
    ///            using this method. If you wish to hide the provenance of the UUIDs, you should
    ///            use a different method.
    public static func v1() -> UUID {
        UUIDv1().rawValue
    }
    
    /// Creates a new name-based (version 3) UUID using MD5 hashing.
    ///
    /// - warning: Unless backward compatibility is an issue, SHA-1 (`.v5`) should be preferred.
    /// - parameter name: A value that is unique within the given namespace.
    /// - parameter namespace: An UUID namespace used as a prefix for `name`.
    public static func v3<T>(name: T, namespace: Namespace) -> UUID where T: Collection, T.Element == UInt8 {
        UUIDv3(name: name, namespace: namespace).rawValue
    }
    
    /// Creates a new name-based (version 3) UUID using MD5 hashing.
    ///
    /// - warning: Unless backward compatibility is an issue, SHA-1 (`.v5`) should be preferred.
    /// - parameter name: A value that is unique within the given namespace.
    /// - parameter namespace: An UUID namespace used as a prefix for `name`.
    public static func v3<T>(name: T, namespace: Namespace) -> UUID where T: DataProtocol {
        UUIDv3(name: name, namespace: namespace).rawValue
    }
    
    /// Creates a new name-based (version 3) UUID using MD5 hashing.
    ///
    /// - warning: Unless backward compatibility is an issue, SHA-1 (`.v5`) should be preferred.
    /// - parameter name: A value that is unique within the given namespace.
    /// - parameter namespace: An UUID namespace used as a prefix for `name`.
    public static func v3<T>(name: T, namespace: Namespace) -> UUID where T: StringProtocol {
        UUIDv3(name: name, namespace: namespace).rawValue
    }
    
    /// Creates a new random (version 4) UUID.
    ///
    /// The system's default source of random is used to create the new UUID.
    public static func v4() -> UUID {
        UUIDv4().rawValue
    }
    
    /// Creates a new random (version 4) UUID, using the given generator as a source for randomness.
    ///
    /// - parameter generator: The random number generator to use when creating the new random UUID.
    public static func v4<T>(using generator: inout T) -> UUID where T: RandomNumberGenerator {
        UUIDv4(using: &generator).rawValue
    }
    
    /// Creates a new name-based (version 5) UUID using SHA-1 hashing.
    ///
    /// - parameter name: A value that is unique within the given namespace.
    /// - parameter namespace: An UUID namespace used as a prefix for `name`.
    public static func v5<T>(name: T, namespace: Namespace) -> UUID where T: Collection, T.Element == UInt8 {
        UUIDv5(name: name, namespace: namespace).rawValue
    }
    
    /// Creates a new name-based (version 5) UUID using SHA-1 hashing.
    ///
    /// - parameter name: A value that is unique within the given namespace.
    /// - parameter namespace: An UUID namespace used as a prefix for `name`.
    public static func v5<T>(name: T, namespace: Namespace) -> UUID where T: DataProtocol {
        UUIDv5(name: name, namespace: namespace).rawValue
    }
    
    /// Creates a new name-based (version 5) UUID using SHA-1 hashing.
    ///
    /// - parameter name: A value that is unique within the given namespace.
    /// - parameter namespace: An UUID namespace used as a prefix for `name`.
    public static func v5<T>(name: T, namespace: Namespace) -> UUID where T: StringProtocol {
        UUIDv5(name: name, namespace: namespace).rawValue
    }
}

extension UUID {
    internal init(bytes source: UnsafeRawBufferPointer, version: Version) {
        precondition(source.count >= 16)
        var bytes = UUID.null.uuid
        withUnsafeMutableBytes(of: &bytes) { target in
            _ = source.copyBytes(to: target, count: 16)
        }
        bytes.8 = bytes.8 & 0x3f | 0x80
        bytes.6 = bytes.6 & 0x0f | version << 4
        self.init(uuid: bytes)
        assert(self.version == version)
    }
}
