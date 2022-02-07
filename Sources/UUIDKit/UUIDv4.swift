import Foundation

extension UUID {
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
}

public struct UUIDv4: Codable, Hashable, LosslessStringConvertible, RawRepresentable {
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
    
    public init?(rawValue: UUID) {
        guard rawValue.version == 4 else {
            return nil
        }
        self.rawValue = rawValue
    }
    
    public init?(_ description: String) {
        guard let rawValue = UUID(uuidString: description), rawValue.version == 4 else {
            return nil
        }
        self.rawValue = rawValue
    }
    
    public let rawValue: UUID
    
    public var description: String {
        rawValue.description
    }
}
