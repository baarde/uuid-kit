import XCTest
@testable import UUIDKit

final class NamespaceTests: XCTestCase {
    func testNamespaces() {
        XCTAssertEqual(UUID.Namespace.dns.rawValue,  UUID(uuidString: "6ba7b810-9dad-11d1-80b4-00c04fd430c8"))
        XCTAssertEqual(UUID.Namespace.url.rawValue,  UUID(uuidString: "6ba7b811-9dad-11d1-80b4-00c04fd430c8"))
        XCTAssertEqual(UUID.Namespace.oid.rawValue,  UUID(uuidString: "6ba7b812-9dad-11d1-80b4-00c04fd430c8"))
        XCTAssertEqual(UUID.Namespace.x500.rawValue, UUID(uuidString: "6ba7b814-9dad-11d1-80b4-00c04fd430c8"))
    }
}
