import XCTest
@testable import MobileContentManager

final class WebServiceTests: XCTestCase {
    func testServiceModel() throws {
        let serviceModel = NovelReaderWebService()
        serviceModel.requestQuery = ["page": "2"]
        let queryItems = serviceModel.queryItems()
        XCTAssertEqual(queryItems.count, 1)
        XCTAssertEqual(queryItems.first.name, "page")
        XCTAssertEqual(queryItems.first.value, "2")
    }
}
