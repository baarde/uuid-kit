import XCTest
@testable import UUIDKit

final class UUIDv5Tests: XCTestCase {
    func testVariantAndVersion() {
        let uuid = UUID.v5(name: "test.test", namespace: .dns)
        XCTAssertEqual(uuid.variant, .rfc4122)
        XCTAssertEqual(uuid.version, 5)
    }
    
    func testSHA1Hash() {
        let uuid = UUID.v5(name: "test.test", namespace: .dns)
        XCTAssertEqual(uuid, UUID(uuidString: "783d51c2-94cd-5e7a-8afe-c2fd6d91f7a2"))
    }
}
