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
    
    func testRawRepresentable() {
        let rawValue = UUID(uuidString: "90ff3dc0-7bbe-3132-9efc-17d6828d50db")!
        let uuid = UUIDv3(rawValue: rawValue)
        XCTAssertNotNil(uuid)
        XCTAssertEqual(uuid?.rawValue, rawValue)
        XCTAssertNil(UUIDv3(rawValue: UUID(uuidString: "712869ea-f10f-40b7-b192-4f8653973806")!))
    }
    
    func testLosslessStringConvertible() {
        let description = "90ff3dc0-7bbe-3132-9efc-17d6828d50db"
        let uuid = UUIDv3(description)
        XCTAssertNotNil(uuid)
        XCTAssertEqual(uuid?.description.lowercased(), description)
        XCTAssertNil(UUIDv3("712869ea-f10f-40b7-b192-4f8653973806"))
    }
}
