import XCTest
@testable import Bitso

class BitsoTests: XCTestCase {
    let key = ""
    let secret = ""
    fileprivate func getDencoder() -> JSONDecoder{
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(BitsoDateDecodingStrategy.decode)
        return decoder
    }
    
    func test_order_book() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let session = URLSessionMock()
        let json = stubbedResponse("order_book")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let orderBook = try! getDencoder().decode(BitsoResponse<OrderBook>.self, from: json)
        session.data = json
        let router = Router<BitsoEndPoint>(session:session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.orderBookFor(bookID: "btc_mxn") { (result) in
            debugPrint(result)
            if case let .success(orderbook) = result {
                XCTAssertEqual(orderbook, orderBook.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_order_book_aggregated() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let session = URLSessionMock()
        let json = stubbedResponse("order_book_aggregated")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let orderBook = try! getDencoder().decode(BitsoResponse<OrderBook>.self, from: json)
        session.data = json
        let router = Router<BitsoEndPoint>(session:session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.orderBookFor(bookID: "btc_mxn") { (result) in
            debugPrint(result)
            if case let .success(orderbook) = result {
                XCTAssertEqual(orderbook, orderBook.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_ticker() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let session = URLSessionMock()
        let json = stubbedResponse("ticker")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let stubTick = try! getDencoder().decode(BitsoResponse<Ticker>.self, from: json)
        session.data = json
        let router = Router<BitsoEndPoint>(session:session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.tickerFor(bookID: "btc_mxn") { (result) in
            debugPrint(result)
            if case let .success(ticker) = result {
                XCTAssertEqual(ticker, stubTick.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_available_books() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let session = URLSessionMock()
        let json = stubbedResponse("available_books")
        let stubBook = try! getDencoder().decode(BitsoResponse<[Book]>.self, from: json)
        session.data = json
        
        let router = Router<BitsoEndPoint>(session:session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.available_books { (result) in
            if case let .success(book) = result {
                XCTAssertEqual(book, stubBook.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_trades() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let session = URLSessionMock()
        let json = stubbedResponse("trades")
        let stubTrades = try! getDencoder().decode(BitsoResponse<[Trade]>.self, from: json)
        session.data = json
        
        let router = Router<BitsoEndPoint>(session:session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.tradesFor(bookID: "btc_mxn", marker: nil, sort: nil, limit: nil) { (result) in
            if case let .success(trades) = result {
                XCTAssertEqual(trades, stubTrades.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_account_status() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let session = URLSessionMock()
        let json = stubbedResponse("account_status")
        let stubAccountStatus = try! getDencoder().decode(BitsoResponse<AccountStatus>.self, from: json)
        session.data = json
        let router = Router<BitsoEndPoint>(session:session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.accountStatus { (result) in
            if case let .success(status) = result {
                XCTAssertEqual(status, stubAccountStatus.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_bitso_error() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let session = URLSessionMock()
        let json = stubbedResponse("error")
        let stubError = try! getDencoder().decode(BitsoResponse<String>.self, from: json)
        session.data = json
        
        let router = Router<BitsoEndPoint>(session:session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.available_books { (result) in
            if case let .failure(error) = result {
                XCTAssertEqual(error, stubError.error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_live_call() throws {
        let expectation = XCTestExpectation(description: "True Network Call")
        let router = Router<BitsoEndPoint>(session:URLSession.shared)
        let bitso = Bitso(key: "", secret: "", environment: .developV3, router: router)
        bitso.tradesFor(bookID: "btc_mxn", marker: nil, sort: nil, limit: nil) { (result) in
            switch result {
            case .success(let trades):
                XCTAssertNotNil(trades)
                expectation.fulfill()
            case .failure(let error):
                debugPrint(error)
                XCTFail()
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
    }
}

func stubbedResponse(_ filename: String) -> Data {
    @objc class FeelitTests: NSObject { }
    let thisSourceFile = URL(fileURLWithPath: #file)
    let thisDirectory = thisSourceFile.deletingLastPathComponent()
    let resourceURL = thisDirectory.appendingPathComponent("fixtures/\(filename).json")
    return try! Data(contentsOf: resourceURL)
}

