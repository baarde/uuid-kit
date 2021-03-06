import Crypto
import Foundation

extension UUID {
    internal struct UUIDv3 {
        public init<T>(name: T, namespace: Namespace) where T: Collection, T.Element == UInt8 {
            var hash = Crypto.Insecure.MD5()
            hash.update(uuid: namespace.rawValue)
            hash.update(collection: name)
            rawValue = UUID(digest: hash.finalize(), version: 3)
        }
        
        public init<T>(name: T, namespace: Namespace) where T: DataProtocol {
            var hash = Crypto.Insecure.MD5()
            hash.update(uuid: namespace.rawValue)
            hash.update(data: name)
            rawValue = UUID(digest: hash.finalize(), version: 3)
        }
        
        public init<T>(name: T, namespace: Namespace) where T: StringProtocol {
            self.init(name: name.utf8, namespace: namespace)
        }
        
        public let rawValue: UUID
    }
}
