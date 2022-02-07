import Foundation

extension UUID {
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
}

public struct UUIDv1: Codable, Hashable, LosslessStringConvertible, RawRepresentable {
    public init() {
        self.init(node: .current)
    }
    
    public init(node: Node) {
        let (timestamp, clockSequence) = Clock.default.next()
        self.init(timestamp: timestamp, clockSequence: clockSequence, node: node)
    }
    
    public init(timestamp: Timestamp, clockSequence: ClockSequence, node: Node) {
        var bytes = UUID.null.uuid
        bytes.0 = UInt8(truncatingIfNeeded: timestamp.rawValue >> 24)
        bytes.1 = UInt8(truncatingIfNeeded: timestamp.rawValue >> 16)
        bytes.2 = UInt8(truncatingIfNeeded: timestamp.rawValue >> 8)
        bytes.3 = UInt8(truncatingIfNeeded: timestamp.rawValue)
        bytes.4 = UInt8(truncatingIfNeeded: timestamp.rawValue >> 40)
        bytes.5 = UInt8(truncatingIfNeeded: timestamp.rawValue >> 32)
        bytes.6 = UInt8(truncatingIfNeeded: timestamp.rawValue >> 56) & 0x0f | 0x10
        bytes.7 = UInt8(truncatingIfNeeded: timestamp.rawValue >> 48)
        bytes.8 = UInt8(truncatingIfNeeded: clockSequence.rawValue >> 8) & 0x3f | 0x80
        bytes.9 = UInt8(truncatingIfNeeded: clockSequence.rawValue)
        bytes.10 = UInt8(truncatingIfNeeded: node.rawValue >> 40)
        bytes.11 = UInt8(truncatingIfNeeded: node.rawValue >> 32)
        bytes.12 = UInt8(truncatingIfNeeded: node.rawValue >> 24)
        bytes.13 = UInt8(truncatingIfNeeded: node.rawValue >> 16)
        bytes.14 = UInt8(truncatingIfNeeded: node.rawValue >> 8)
        bytes.15 = UInt8(truncatingIfNeeded: node.rawValue)
        rawValue = UUID(uuid: bytes)
        assert(rawValue.version == 1)
    }
    
    public init?(rawValue: UUID) {
        guard rawValue.version == 1 else {
            return nil
        }
        self.rawValue = rawValue
    }
    
    public init?(_ description: String) {
        guard let rawValue = UUID(uuidString: description), rawValue.version == 1 else {
            return nil
        }
        self.rawValue = rawValue
    }
    
    public let rawValue: UUID
    
    public var timestamp: Timestamp {
        let bytes = rawValue.uuid
        var rawValue: UInt64 = 0
        rawValue |= UInt64(bytes.0) << 24
        rawValue |= UInt64(bytes.1) << 16
        rawValue |= UInt64(bytes.2) << 8
        rawValue |= UInt64(bytes.3)
        rawValue |= UInt64(bytes.4) << 40
        rawValue |= UInt64(bytes.5) << 32
        rawValue |= UInt64(bytes.6 & 0x0f) << 56
        rawValue |= UInt64(bytes.7) << 48
        return Timestamp(truncatingIfNeeded: rawValue)
    }
    
    public var clockSequence: ClockSequence {
        let bytes = rawValue.uuid
        var rawValue: UInt16 = 0
        rawValue |= UInt16(bytes.8) << 8
        rawValue |= UInt16(bytes.9)
        return ClockSequence(truncatingIfNeeded: rawValue)
    }
    
    public var node: Node {
        let bytes = rawValue.uuid
        var rawValue: UInt64 = 0
        rawValue |= UInt64(bytes.10) << 40
        rawValue |= UInt64(bytes.11) << 32
        rawValue |= UInt64(bytes.12) << 24
        rawValue |= UInt64(bytes.13) << 16
        rawValue |= UInt64(bytes.14) << 8
        rawValue |= UInt64(bytes.15)
        return Node(truncatingIfNeeded: rawValue)
    }
    
    public var description: String {
        rawValue.description
    }
}
