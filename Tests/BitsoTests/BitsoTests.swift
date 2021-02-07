import XCTest
@testable import Bitso

class BitsoTests: XCTestCase {

    func test_available_books() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let session = URLSessionMock()
        let json = stubbedResponse("available_books")
        let stubBook = try! JSONDecoder().decode(BitsoResponse<[Book]>.self, from: json)
        session.data = json
        
        let router = Router<BitsoEndPoint>(session:session)
        let bitso = Bitso(router: router, environment: .developV3)
        bitso.available_books { (result) in
            if case let .success(book) = result {
                XCTAssertEqual(book, stubBook.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_bitso_error() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let session = URLSessionMock()
        let json = stubbedResponse("error")
        let stubError = try! JSONDecoder().decode(BitsoResponse<String>.self, from: json)
        session.data = json
        
        let router = Router<BitsoEndPoint>(session:session)
        let bitso = Bitso(router: router, environment: .developV3)
        bitso.available_books { (result) in
            if case let .failure(error) = result {
                XCTAssertEqual(error, stubError.error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
}

func stubbedResponse(_ filename: String) -> Data {
    @objc class FeelitTests: NSObject { }
    let thisSourceFile = URL(fileURLWithPath: #file)
    let thisDirectory = thisSourceFile.deletingLastPathComponent()
    let resourceURL = thisDirectory.appendingPathComponent("fixtures/\(filename).json")
    return try! Data(contentsOf: resourceURL)
}

