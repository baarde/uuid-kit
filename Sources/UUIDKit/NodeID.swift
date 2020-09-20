import CUUIDKit
import Foundation

extension UUID {
    internal struct NodeID {
        public typealias Bytes = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
        
        public init(bytes: Bytes) {
            self.bytes = bytes
        }
        
        public let bytes: Bytes
        
        public static let `default`: NodeID = defaultEthernet ?? defaultRandom
        
        public static let defaultRandom: NodeID = random()
        
        public static let defaultEthernet: NodeID? = findDefaultEthernet()
        
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

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(Linux)

extension UUID.NodeID {
    public static func ethernet() -> AllEthernet {
        AllEthernet()
    }
    
    private init?(from addr: UnsafePointer<sockaddr>) {
        switch addr.pointee.sa_family {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        case sa_family_t(AF_LINK):
            guard let nodeID = addr.withMemoryRebound(to: sockaddr_dl.self, capacity: 1, UUID.NodeID.init) else {
                return nil
            }
            self = nodeID
        #endif
        #if os(Linux)
        case sa_family_t(AF_PACKET):
            guard let nodeID = addr.withMemoryRebound(to: sockaddr_ll.self, capacity: 1, UUID.NodeID.init) else {
                return nil
            }
            self = nodeID
        #endif
        default:
            return nil
        }
    }
    
    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    private init?(from addr: UnsafePointer<sockaddr_dl>) {
        guard addr.pointee.sdl_type == IFT_ETHER, addr.pointee.sdl_alen == 6 else {
            return nil
        }
        let nameLength = Int(addr.pointee.sdl_nlen)
        let nameOffset = MemoryLayout<sockaddr_dl>.offset(of: \sockaddr_dl.sdl_data)!
        let addrOffset = nameOffset + nameLength
        bytes = UnsafeRawPointer(addr).load(fromByteOffset: addrOffset, as: Bytes.self)
    }
    #endif
    
    #if os(Linux)
    private init?(from addr: UnsafePointer<sockaddr_ll>) {
        guard addr.pointee.sll_hatype == ARPHRD_ETHER, addr.pointee.sll_halen == 6 else {
            return nil
        }
        let addrOffset = MemoryLayout<sockaddr_ll>.offset(of: \sockaddr_ll.sll_addr)!
        bytes = UnsafeRawPointer(addr).load(fromByteOffset: addrOffset, as: Bytes.self)
    }
    #endif
    
    private static func findDefaultEthernet() -> UUID.NodeID? {
        ethernet().first { name, nodeID in
            // Skip 00:00:00:00:00:00 or 02:00:00:00:00:00.
            guard nodeID.bytes != (0, 0, 0, 0, 0, 0) && nodeID.bytes != (2, 0, 0, 0, 0, 0) else {
                return false
            }
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            // On Apple platforms, it is safe to assume the primary interface is always the one
            // named "en0". Because some interfaces ("en5" used by iBridge, "bridge0", "ap1") appear
            // before it in the list, we skip any interface that isn't named "en0".
            guard name == "en0" else {
                return false
            }
            #endif
            return true
        }.map { $0.nodeID }
    }
}

extension UUID.NodeID {
    internal final class AllEthernet: Sequence {
        public init() {
            getifaddrs(&list)
        }
        
        deinit {
            freeifaddrs(list)
        }
        
        public func makeIterator() -> Iterator {
            Iterator(sequence: self, head: list)
        }
        
        private var list: UnsafeMutablePointer<ifaddrs>?
    }
}

extension UUID.NodeID.AllEthernet {
    internal struct Iterator: IteratorProtocol {
        public mutating func next() -> (name: String, nodeID: UUID.NodeID)? {
            while let ifa = head?.pointee {
                head = ifa.ifa_next
                guard let addr = ifa.ifa_addr, let nodeID = UUID.NodeID(from: addr) else {
                    continue
                }
                return (String(cString: ifa.ifa_name), nodeID)
            }
            return nil
        }
        
        internal init(sequence: UUID.NodeID.AllEthernet, head: UnsafeMutablePointer<ifaddrs>?) {
            self.sequence = sequence
            self.head = head
        }
        
        private let sequence: UUID.NodeID.AllEthernet
        private var head: UnsafeMutablePointer<ifaddrs>?
    }
}

#else

extension UUID.NodeID {
    private static func findDefaultEthernet() -> UUID.NodeID? {
        nil
    }
}

#endif
