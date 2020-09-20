import Foundation

extension UUID {
    /// The variant of the UUID.
    ///
    /// UUIDs generated using `UUID()` or one of the methods in UUIDKit use the `.rfc4122` variant.
    public var variant: Variant {
        switch uuid.8 {
        case 0x80...0xbf:
            return .rfc4122
        case 0xc0...0xdf:
            return .microsoft
        case 0xe0...0xff:
            return .future
        default:
            return .ncs
        }
    }
    
    /// The variant determines the layout of the UUID.
    ///
    /// It is stored in the most significant bits of byte 8 of the UUID.
    public enum Variant: Hashable {
        /// A variant reserved for NCS backward compatibility.
        case ncs
        /// The variant specified in specified in [RFC 4122](https://tools.ietf.org/html/rfc4122).
        case rfc4122
        /// A variant reserved for Microsoft backward compatibility.
        case microsoft
        /// A variant reserved for for future definition.
        case future
    }
}
