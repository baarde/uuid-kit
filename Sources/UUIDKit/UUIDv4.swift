import Foundation

extension UUID {
    internal struct UUIDv4 {
        public init() {
            var generator = SystemRandomNumberGenerator()
            self.init(using: &generator)
        }
        
        public init<T>(using generator: inout T) where T: RandomNumberGenerator {
            let words = (generator.next(), generator.next())
            rawValue = withUnsafeBytes(of: words) { bytes in
                UUID(bytes: bytes, version: 4)
            }
        }
        
        public let rawValue: UUID
    }
}
