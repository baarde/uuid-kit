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
    
    func testRawRepresentable() {
        let rawValue = UUID(uuidString: "783d51c2-94cd-5e7a-8afe-c2fd6d91f7a2")!
        let uuid = UUIDv5(rawValue: rawValue)
        XCTAssertNotNil(uuid)
        XCTAssertEqual(uuid?.rawValue, rawValue)
        XCTAssertNil(UUIDv5(rawValue: UUID(uuidString: "712869ea-f10f-40b7-b192-4f8653973806")!))
    }
    
    func testLosslessStringConvertible() {
        let description = "783d51c2-94cd-5e7a-8afe-c2fd6d91f7a2"
        let uuid = UUIDv5(description)
        XCTAssertNotNil(uuid)
        XCTAssertEqual(uuid?.description.lowercased(), description)
        XCTAssertNil(UUIDv5("712869ea-f10f-40b7-b192-4f8653973806"))
    }
}
