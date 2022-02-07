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
}
