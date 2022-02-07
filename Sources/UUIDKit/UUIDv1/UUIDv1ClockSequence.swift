import Foundation

extension UUIDv1 {
    public struct ClockSequence: Hashable, RawRepresentable {
        public init<T>(truncatingIfNeeded source: T) where T: BinaryInteger {
            self.rawValue = UInt16(truncatingIfNeeded: source) & ~(.max << 14)
        }
        
        public init?(rawValue: UInt16) {
            guard rawValue & (.max << 14) == 0 else {
                return nil
            }
            self.rawValue = rawValue
        }
        
        public let rawValue: UInt16
        
        public var next: ClockSequence {
            ClockSequence(truncatingIfNeeded: rawValue &+ 1)
        }
        
        public static func random() -> ClockSequence {
            var generator = SystemRandomNumberGenerator()
            return random(using: &generator)
        }
        
        public static func random<T>(using generator: inout T) -> ClockSequence where T: RandomNumberGenerator {
            ClockSequence(truncatingIfNeeded: generator.next())
        }
    }
}
