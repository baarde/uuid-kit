import Crypto
import Foundation

extension UUID {
    internal init<T>(digest: T, version: Int) where T: Digest {
        self = digest.withUnsafeBytes { bytes in
            UUID(bytes: bytes, version: version)
        }
    }
}

extension HashFunction {
    internal mutating func update(uuid: UUID) {
        withUnsafeBytes(of: uuid.uuid) { bytes in
            update(bufferPointer: bytes)
        }
    }
    
    internal mutating func update<T>(collection: T) where T: Collection, T.Element == UInt8 {
        collection.withContiguousStorageIfAvailable { storage in
            storage.withUnsafeBytes { bytes in
                update(bufferPointer: bytes)
            }
        } ?? update(data: Data(collection))
    }
}
