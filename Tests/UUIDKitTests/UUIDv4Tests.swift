import XCTest
@testable import UUIDKit

final class UUIDv4Tests: XCTestCase {
    func testVariantAndVersion() {
        let uuid = UUID.v4()
        XCTAssertEqual(uuid.variant, .rfc4122)
        XCTAssertEqual(uuid.version, 4)
    }
    
    func testRandomness() {
        let lhs = UUID.v4()
        let rhs = UUID.v4()
        XCTAssertNotEqual(lhs, rhs)
    }
    
    func testRandomBytes() {
        var randomNumberGenerator = FakeRandomNumberGenerator(values: [
            0x0011223344556677,
            0x8899aabbccddeeff,
        ])
        let uuid = UUID.v4(using: &randomNumberGenerator)
        XCTAssertEqual(uuid, UUID(uuidString: "77665544-3322-4100-bfee-ddccbbaa9988"))
        XCTAssertEqual(randomNumberGenerator.count, 2)
    }
    
    func testRawRepresentable() {
        let rawValue = UUID(uuidString: "712869ea-f10f-40b7-b192-4f8653973806")!
        let uuid = UUIDv4(rawValue: rawValue)
        XCTAssertNotNil(uuid)
        XCTAssertEqual(uuid?.rawValue, rawValue)
        XCTAssertNil(UUIDv4(rawValue: UUID(uuidString: "d2989d1a-3bf9-11ec-bdb7-4d10858c27b2")!))
    }
    
    func testLosslessStringConvertible() {
        let description = "712869ea-f10f-40b7-b192-4f8653973806"
        let uuid = UUIDv4(description)
        XCTAssertNotNil(uuid)
        XCTAssertEqual(uuid?.description.lowercased(), description)
        XCTAssertNil(UUIDv4("d2989d1a-3bf9-11ec-bdb7-4d10858c27b2"))
    }
}
