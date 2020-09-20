import Foundation

extension UUID {
    internal struct UUIDv1 {
        public init() {
            self.init(nodeID: .default)
        }
        
        public init(nodeID: NodeID) {
            let (timestamp, clockSequence) = Clock.default.next()
            self.init(timestamp: timestamp, clockSequence: clockSequence, nodeID: nodeID)
        }
        
        public init(timestamp: Timestamp, clockSequence: ClockSequence, nodeID: NodeID) {
            let time = timestamp.rawValue
            var bytes = UUID.null.uuid
            bytes.0 = UInt8(truncatingIfNeeded: time >> 24)
            bytes.1 = UInt8(truncatingIfNeeded: time >> 16)
            bytes.2 = UInt8(truncatingIfNeeded: time >> 8)
            bytes.3 = UInt8(truncatingIfNeeded: time)
            bytes.4 = UInt8(truncatingIfNeeded: time >> 40)
            bytes.5 = UInt8(truncatingIfNeeded: time >> 32)
            bytes.6 = UInt8(truncatingIfNeeded: time >> 56) & 0x0f | 0x10
            bytes.7 = UInt8(truncatingIfNeeded: time >> 48)
            bytes.8 = UInt8(truncatingIfNeeded: clockSequence >> 8) & 0x3f | 0x80
            bytes.9 = UInt8(truncatingIfNeeded: clockSequence)
            (bytes.10, bytes.11, bytes.12, bytes.13, bytes.14, bytes.15) = nodeID.bytes
            rawValue = UUID(uuid: bytes)
            assert(rawValue.version == 1)
        }
        
        public let rawValue: UUID
    }
}
