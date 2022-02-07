import XCTest
@testable import UUIDKit

final class UUIDv1Tests: XCTestCase {
    func testVariantAndVersion() {
        let uuid = UUID.v1()
        XCTAssertEqual(uuid.variant, .rfc4122)
        XCTAssertEqual(uuid.version, 1)
    }
    
    func testNodeIsRandom() {
        let uuid = UUID.v1()
        XCTAssertEqual(uuid.uuid.10 & 0x1, 1)
    }
    
    func testNodeIsConstant() {
        let lhs = UUID.v1()
        let rhs = UUID.v1()
        XCTAssertNotEqual(lhs, rhs)
        XCTAssertEqual(lhs.uuid.10, rhs.uuid.10)
        XCTAssertEqual(lhs.uuid.11, rhs.uuid.11)
        XCTAssertEqual(lhs.uuid.12, rhs.uuid.12)
        XCTAssertEqual(lhs.uuid.13, rhs.uuid.13)
        XCTAssertEqual(lhs.uuid.14, rhs.uuid.14)
        XCTAssertEqual(lhs.uuid.15, rhs.uuid.15)
    }
}
