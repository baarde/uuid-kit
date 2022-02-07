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
        let lhs = UUIDv1()
        let rhs = UUIDv1()
        XCTAssertNotEqual(lhs, rhs)
        XCTAssertEqual(lhs.node, rhs.node)
    }
    
    func testTimestampIsAscending() {
        let lhs = UUIDv1()
        let rhs = UUIDv1()
        XCTAssertLessThan(lhs.timestamp, rhs.timestamp)
    }
    
    func testFields() {
        let uuid = UUIDv1("d2989d1a-3bf9-11ec-bdb7-4d10858c27b2")
        XCTAssertEqual(uuid?.timestamp.rawValue, 0x1ec3bf9d2989d1a)
        XCTAssertEqual(uuid?.clockSequence.rawValue, 0x3db7)
        XCTAssertEqual(uuid?.node.rawValue, 0x4d10858c27b2)
    }
    
    func testRawRepresentable() {
        let rawValue = UUID(uuidString: "d2989d1a-3bf9-11ec-bdb7-4d10858c27b2")!
        let uuid = UUIDv1(rawValue: rawValue)
        XCTAssertNotNil(uuid)
        XCTAssertEqual(uuid?.rawValue, rawValue)
        XCTAssertNil(UUIDv1(rawValue: UUID(uuidString: "712869ea-f10f-40b7-b192-4f8653973806")!))
    }
    
    func testLosslessStringConvertible() {
        let description = "d2989d1a-3bf9-11ec-bdb7-4d10858c27b2"
        let uuid = UUIDv1(description)
        XCTAssertNotNil(uuid)
        XCTAssertEqual(uuid?.description.lowercased(), description)
        XCTAssertNil(UUIDv1("712869ea-f10f-40b7-b192-4f8653973806"))
    }
}
