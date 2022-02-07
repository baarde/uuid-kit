import Foundation

extension UUID {
    /// The variant of the UUID.
    ///
    /// UUIDs generated using `UUID()` or one of the methods in UUIDKit use the `.rfc4122` variant.
    public var variant: Variant {
        switch uuid.8 {
        case 0x80 ... 0xbf:
            return .rfc4122
        case 0xc0 ... 0xdf:
            return .reservedMicrosoft
        case 0xe0 ... 0xff:
            return .reservedFuture
        default:
            return .reservedNCS
        }
    }
    
    /// The version number of the UUID.
    ///
    /// This property is `nil` when `variant` is not equal to `.rfc4122`.
    ///
    /// [RFC4122](https://tools.ietf.org/html/rfc4122) defines the following versions:
    /// - `1`: Time-based UUID.
    /// - `2`: DCE Security UUID.
    /// - `3`: Name-based UUID using MD5 hashing.
    /// - `4`: Random UUID.
    /// - `5`: Name-based UUID using SHA-1 hashing.
    public var version: Int? {
        variant == .rfc4122 ? Int(uuid.6 >> 4) : nil
    }
    
    /// The nil UUID with all 128 bits set to zero.
    public static let null = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    
    /// The variant determines the layout of the UUID.
    ///
    /// It is stored in the most significant bits of byte 8 of the UUID.
    public enum Variant: Hashable {
        /// A variant reserved for NCS backward compatibility.
        case reservedNCS
        /// The variant specified in specified in [RFC 4122](https://tools.ietf.org/html/rfc4122).
        case rfc4122
        /// A variant reserved for Microsoft backward compatibility.
        case reservedMicrosoft
        /// A variant reserved for for future definition.
        case reservedFuture
    }
}

extension UUID {
    internal init(bytes source: UnsafeRawBufferPointer, version: Int) {
        precondition(source.count >= 16)
        var bytes = UUID.null.uuid
        withUnsafeMutableBytes(of: &bytes) { target in
            _ = source.copyBytes(to: target, count: 16)
        }
        bytes.8 = bytes.8 & 0x3f | 0x80
        bytes.6 = bytes.6 & 0x0f | UInt8(truncatingIfNeeded: version << 4)
        self.init(uuid: bytes)
        assert(self.version == version)
    }
}
