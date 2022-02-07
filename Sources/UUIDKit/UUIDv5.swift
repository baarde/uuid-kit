import Crypto
import Foundation

extension UUID {
    /// Creates a new name-based (version 5) UUID using SHA-1 hashing.
    ///
    /// - parameter name: A value that is unique within the given namespace.
    /// - parameter namespace: An UUID namespace used as a prefix for `name`.
    public static func v5<T>(name: T, namespace: Namespace) -> UUID where T: Collection, T.Element == UInt8 {
        UUIDv5(name: name, namespace: namespace).rawValue
    }
    
    /// Creates a new name-based (version 5) UUID using SHA-1 hashing.
    ///
    /// - parameter name: A value that is unique within the given namespace.
    /// - parameter namespace: An UUID namespace used as a prefix for `name`.
    public static func v5<T>(name: T, namespace: Namespace) -> UUID where T: DataProtocol {
        UUIDv5(name: name, namespace: namespace).rawValue
    }
    
    /// Creates a new name-based (version 5) UUID using SHA-1 hashing.
    ///
    /// - parameter name: A value that is unique within the given namespace.
    /// - parameter namespace: An UUID namespace used as a prefix for `name`.
    public static func v5<T>(name: T, namespace: Namespace) -> UUID where T: StringProtocol {
        UUIDv5(name: name, namespace: namespace).rawValue
    }
}

public struct UUIDv5: Codable, Hashable, LosslessStringConvertible, RawRepresentable {
    public init<T>(name: T, namespace: UUID.Namespace) where T: Collection, T.Element == UInt8 {
        var hash = Crypto.Insecure.SHA1()
        hash.update(uuid: namespace.rawValue)
        hash.update(collection: name)
        rawValue = UUID(digest: hash.finalize(), version: 5)
    }
    
    public init<T>(name: T, namespace: UUID.Namespace) where T: DataProtocol {
        var hash = Crypto.Insecure.SHA1()
        hash.update(uuid: namespace.rawValue)
        hash.update(data: name)
        rawValue = UUID(digest: hash.finalize(), version: 5)
    }
    
    public init<T>(name: T, namespace: UUID.Namespace) where T: StringProtocol {
        self.init(name: name.utf8, namespace: namespace)
    }
    
    public init?(rawValue: UUID) {
        guard rawValue.version == 5 else {
            return nil
        }
        self.rawValue = rawValue
    }
    
    public init?(_ description: String) {
        guard let rawValue = UUID(uuidString: description), rawValue.version == 5 else {
            return nil
        }
        self.rawValue = rawValue
    }
    
    public let rawValue: UUID
    
    public var description: String {
        rawValue.description
    }
}
