import Foundation

extension UUIDv1 {
    public struct Node: Hashable, RawRepresentable {
        public init<T>(truncatingIfNeeded source: T) where T: BinaryInteger {
            self.rawValue = UInt64(truncatingIfNeeded: source) & ~(.max << 48)
        }
        
        public init?(rawValue: UInt64) {
            guard rawValue & (.max << 48) == 0 else {
                return nil
            }
            self.rawValue = rawValue
        }
        
        public let rawValue: UInt64
        
        public static let current: Node = .random()
        
        public static func random() -> Node {
            var generator = SystemRandomNumberGenerator()
            return random(using: &generator)
        }
        
        public static func random<T>(using generator: inout T) -> Node where T: RandomNumberGenerator {
            Node(truncatingIfNeeded: generator.next() | 0x010000000000)
        }
    }
}
