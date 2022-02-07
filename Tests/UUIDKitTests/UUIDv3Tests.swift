import XCTest
@testable import UUIDKit

final class UUIDv3Tests: XCTestCase {
    func testVariantAndVersion() {
        let uuid = UUID.v3(name: "test.test", namespace: .dns)
        XCTAssertEqual(uuid.variant, .rfc4122)
        XCTAssertEqual(uuid.version, 3)
    }
    
    func testMD5Hash() {
        let uuid = UUID.v3(name: "test.test", namespace: .dns)
        XCTAssertEqual(uuid, UUID(uuidString: "90ff3dc0-7bbe-3132-9efc-17d6828d50db"))
    }
}
