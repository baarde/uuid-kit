import XCTest
@testable import UUIDKit

final class VersionTests: XCTestCase {
    func testVersions() {
        XCTAssertEqual(UUID(uuidString: "00000000-0000-0000-0000-000000000000")?.version, nil)
        XCTAssertEqual(UUID(uuidString: "3314538a-c85d-11ea-87d0-0242ac130003")?.version, 1)
        XCTAssertEqual(UUID(uuidString: "5ddf162e-388c-492a-9a2d-ecac0aa0aaf1")?.version, 4)
        XCTAssertEqual(UUID(uuidString: "00000131-0000-0000-c000-000000000046")?.version, nil)
        XCTAssertEqual(UUID(uuidString: "ffffffff-ffff-ffff-ffff-ffffffffffff")?.version, nil)
    }
}
