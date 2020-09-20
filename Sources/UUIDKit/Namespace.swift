import Foundation

extension UUID {
    /// A UUID prefix used when generating a name-based UUID using either `UUID.v3` or `UUID.v5`.
    ///
    /// You can generate a new UUID as a namespace or use one of the pre-defined values
    /// (`.dns`, `.url`, `.oid` or `.x500`).
    public struct Namespace: Hashable, RawRepresentable {
        /// Creates a namespace with the specified UUID.
        ///
        /// - parameter uuid: The UUID to use as the namespace.
        public init(_ uuid: UUID) {
            self.init(rawValue: uuid)
        }
        
        public init(rawValue: UUID) {
            self.rawValue = rawValue
        }
        
        public let rawValue: UUID
        
        /// The namespace to use with a fully-qualified domain name.
        public static let dns = Namespace(UUID(
            uuid: (0x6b, 0xa7, 0xb8, 0x10, 0x9d, 0xad, 0x11, 0xd1, 0x80, 0xb4, 0x00, 0xc0, 0x4f, 0xd4, 0x30, 0xc8)
        ))
        
        /// The namespace to use with a URL.
        public static let url = Namespace(UUID(
            uuid: (0x6b, 0xa7, 0xb8, 0x11, 0x9d, 0xad, 0x11, 0xd1, 0x80, 0xb4, 0x00, 0xc0, 0x4f, 0xd4, 0x30, 0xc8)
        ))
        
        /// The namespace to use with a ISO OID.
        public static let oid = Namespace(UUID(
            uuid: (0x6b, 0xa7, 0xb8, 0x12, 0x9d, 0xad, 0x11, 0xd1, 0x80, 0xb4, 0x00, 0xc0, 0x4f, 0xd4, 0x30, 0xc8)
        ))
        
        /// The namespace to use with a X.500 DN.
        public static let x500 = Namespace(UUID(
            uuid: (0x6b, 0xa7, 0xb8, 0x14, 0x9d, 0xad, 0x11, 0xd1, 0x80, 0xb4, 0x00, 0xc0, 0x4f, 0xd4, 0x30, 0xc8)
        ))
    }
}
