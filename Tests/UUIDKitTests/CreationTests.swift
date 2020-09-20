import XCTest
@testable import UUIDKit

final class CreationTests: XCTestCase {
    func testNull() {
        let uuid = UUID.null
        XCTAssertEqual(uuid.variant, .ncs)
        XCTAssertEqual(uuid.version, nil)
        XCTAssertEqual(uuid, UUID(uuidString: "00000000-0000-0000-0000-000000000000"))
    }
    
    func testV1() {
        let uuid = UUID.v1()
        XCTAssertEqual(uuid.variant, .rfc4122)
        XCTAssertEqual(uuid.version, 1)
        let other = UUID.v1()
        XCTAssertEqual(other.uuid.10, uuid.uuid.10)
        XCTAssertEqual(other.uuid.11, uuid.uuid.11)
        XCTAssertEqual(other.uuid.12, uuid.uuid.12)
        XCTAssertEqual(other.uuid.13, uuid.uuid.13)
        XCTAssertEqual(other.uuid.14, uuid.uuid.14)
        XCTAssertEqual(other.uuid.15, uuid.uuid.15)
        XCTAssertNotEqual(other, uuid)
    }
    
    func testV3() {
        let uuid = UUID.v3(name: "test.test", namespace: .dns)
        XCTAssertEqual(uuid.variant, .rfc4122)
        XCTAssertEqual(uuid.version, 3)
        XCTAssertEqual(uuid, UUID(uuidString: "90ff3dc0-7bbe-3132-9efc-17d6828d50db"))
    }
    
    func testV4() {
        let uuid = UUID.v4()
        XCTAssertEqual(uuid.variant, .rfc4122)
        XCTAssertEqual(uuid.version, 4)
        let other = UUID.v4()
        XCTAssertNotEqual(other, uuid)
    }
    
    func testV4UsingRandomGenerator() {
        var randomNumberGenerator = FakeRandomNumberGenerator(values: [
            0x0011223344556677,
            0x8899aabbccddeeff,
        ])
        let uuid = UUID.v4(using: &randomNumberGenerator)
        XCTAssertEqual(uuid.variant, .rfc4122)
        XCTAssertEqual(uuid.version, 4)
        XCTAssertEqual(uuid, UUID(uuidString: "77665544-3322-4100-bfee-ddccbbaa9988"))
        XCTAssertEqual(randomNumberGenerator.count, 2)
    }
    
    func testV5() {
        let uuid = UUID.v5(name: "test.test", namespace: .dns)
        XCTAssertEqual(uuid.variant, .rfc4122)
        XCTAssertEqual(uuid.version, 5)
        XCTAssertEqual(uuid, UUID(uuidString: "783d51c2-94cd-5e7a-8afe-c2fd6d91f7a2"))
    }
}
