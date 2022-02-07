import XCTest
@testable import UUIDKit

final class BaseTests: XCTestCase {
    func testNull() {
        let uuid = UUID.null
        XCTAssertEqual(uuid.variant, .reservedNCS)
        XCTAssertEqual(uuid.version, nil)
        XCTAssertEqual(uuid, UUID(uuidString: "00000000-0000-0000-0000-000000000000"))
    }
    
    func testRFC4122() {
        let uuid = UUID(uuidString: "712869EA-F10F-40B7-B192-4F8653973806")!
        XCTAssertEqual(uuid.variant, .rfc4122)
        XCTAssertEqual(uuid.version, 4)
    }
    
    func testReservedNCS() {
        let uuid = UUID(uuidString: "3c4d28ff-e000-0000-0d00-013422000000")!
        XCTAssertEqual(uuid.variant, .reservedNCS)
        XCTAssertEqual(uuid.version, nil)
    }
    
    func testReservedMicrosoft() {
        let uuid = UUID(uuidString: "00000131-0000-0000-c000-000000000046")!
        XCTAssertEqual(uuid.variant, .reservedMicrosoft)
        XCTAssertEqual(uuid.version, nil)
    }
    
    func testReservedFuture() {
        let uuid = UUID(uuidString: "ffffffff-ffff-ffff-ffff-ffffffffffff")!
        XCTAssertEqual(uuid.variant, .reservedFuture)
        XCTAssertEqual(uuid.version, nil)
    }
}
