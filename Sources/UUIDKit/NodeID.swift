import Foundation

extension UUID {
    internal struct NodeID {
        public typealias Bytes = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
        
        public init(bytes: Bytes) {
            self.bytes = bytes
        }
        
        public let bytes: Bytes
        
        public static let `default`: NodeID = random()
        
        public static func random() -> NodeID {
            var generator = SystemRandomNumberGenerator()
            return random(using: &generator)
        }
        
        public static func random<T>(using generator: inout T) -> NodeID where T: RandomNumberGenerator {
            let number = generator.next()
            let bytes = (
                UInt8(truncatingIfNeeded: number >> 40) | 0x01,
                UInt8(truncatingIfNeeded: number >> 32),
                UInt8(truncatingIfNeeded: number >> 24),
                UInt8(truncatingIfNeeded: number >> 16),
                UInt8(truncatingIfNeeded: number >> 8),
                UInt8(truncatingIfNeeded: number)
            )
            return NodeID(bytes: bytes)
        }
    }
}
