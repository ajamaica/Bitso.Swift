import XCTest
@testable import Bitso

class BitsoTests: XCTestCase {
    let key = ""
    let secret = ""

    fileprivate func getDencoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(BitsoDateDecodingStrategy.decode)
        return decoder
    }

    fileprivate func getMockURLSession<Payload>(fileName: String) -> (URLSession, BitsoResponse<Payload>) {

        let json = stubbedResponse(fileName)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let orderBook = try! getDencoder().decode(BitsoResponse<Payload>.self, from: json)

        URLProtocolMock.testData = json
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return (URLSession(configuration: config), orderBook)
    }

    func test_order_book() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")

        let tuple: (session: URLSession, stub: BitsoResponse<OrderBook>) = getMockURLSession(fileName: "order_book")

        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.orderBookFor(bookID: "btc_mxn") { (result) in
            if case let .success(orderbook) = result {
                XCTAssertEqual(orderbook, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_order_book_aggregated() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")

        let tuple: (session: URLSession, stub: BitsoResponse<OrderBook>) = getMockURLSession(fileName: "order_book_aggregated")

        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.orderBookFor(bookID: "btc_mxn") { (result) in
            if case let .success(orderbook) = result {
                XCTAssertEqual(orderbook, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_ticker() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")

        let tuple: (session: URLSession, stub: BitsoResponse<Ticker>) = getMockURLSession(fileName: "ticker")

        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.tickerFor(bookID: "btc_mxn") { (result) in
            if case let .success(ticker) = result {
                XCTAssertEqual(ticker, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_available_books() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<[Book]>) = getMockURLSession(fileName: "available_books")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.available_books { (result) in
            if case let .success(book) = result {
                XCTAssertEqual(book, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_trades() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")

        let tuple: (session: URLSession, stub: BitsoResponse<[Trade]>) = getMockURLSession(fileName: "trades")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.tradesFor(bookID: "btc_mxn", marker: nil, sort: nil, limit: nil) { (result) in
            if case let .success(trades) = result {
                XCTAssertEqual(trades, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_account_status() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")

        let tuple: (session: URLSession, stub: BitsoResponse<AccountStatus>) = getMockURLSession(fileName: "account_status")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.accountStatus { (result) in
            if case let .success(status) = result {
                XCTAssertEqual(status, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_phone_number() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<Phone>) = getMockURLSession(fileName: "phone_number")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.phoneNumber(phone_number: "5552525252") { result in
            if case let .success(phone) = result {
                XCTAssertEqual(phone, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_phone_verification() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<Phone>) = getMockURLSession(fileName: "phone_verification")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.phoneVerification(verification_code: "1234") { result in
            if case let .success(phone) = result {
                XCTAssertEqual(phone, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_balance() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<CustomerFees>) = getMockURLSession(fileName: "fees")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.fees { result in
            if case let .success(fees) = result {
                XCTAssertEqual(fees, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_ledger() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<[Ledger]>) = getMockURLSession(fileName: "ledger")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.ledger(marker: nil, sort: nil, limit: nil) { (result) in
            if case let .success(ledger) = result {
                XCTAssertEqual(ledger, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_ledger_tades() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<[Ledger]>) = getMockURLSession(fileName: "ledger")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.ledgerTrades(marker: nil, sort: nil, limit: nil) { (result) in
            if case let .success(ledger) = result {
                XCTAssertEqual(ledger, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_ledger_fees() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<[Ledger]>) = getMockURLSession(fileName: "ledger")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.ledgerFees(marker: nil, sort: nil, limit: nil) { (result) in
            if case let .success(ledger) = result {
                XCTAssertEqual(ledger, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_ledger_withdrawals() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<[Ledger]>) = getMockURLSession(fileName: "ledger")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.ledgerWithdrawals(marker: nil, sort: nil, limit: nil) { (result) in
            if case let .success(ledger) = result {
                XCTAssertEqual(ledger, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_withdrawals() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<[Withdrawal]>) = getMockURLSession(fileName: "withdrawals")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.withdrawals(wid: "", marker: nil, limit: nil, status: nil, method: nil) { (result) in
            if case let .success(withdrawals) = result {
                XCTAssertEqual(withdrawals, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_withdrawalsForWid() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<[Withdrawal]>) = getMockURLSession(fileName: "withdrawals")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.withdrawalsForWid(wid: "", marker: nil, limit: nil, status: nil, method: nil) { (result) in
            if case let .success(withdrawals) = result {
                XCTAssertEqual(withdrawals, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_withdrawalsForWids() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<[Withdrawal]>) = getMockURLSession(fileName: "withdrawals")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.withdrawalsForWids(wids: [""], marker: nil, limit: nil, status: nil, method: nil) { (result) in
            if case let .success(withdrawals) = result {
                XCTAssertEqual(withdrawals, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_withdrawalsForOrigin() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<[Withdrawal]>) = getMockURLSession(fileName: "withdrawals")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.withdrawalsForOrigin(origin_ids: [""], marker: nil, limit: nil, status: nil, method: nil) { (result) in
            if case let .success(withdrawals) = result {
                XCTAssertEqual(withdrawals, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_fundings() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<[Funding]>) = getMockURLSession(fileName: "fundings")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.fundings(txids: [""]) { (result) in
            if case let .success(funding) = result {
                XCTAssertEqual(funding, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_userTrades() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let tuple: (session: URLSession, stub: BitsoResponse<[UserTrade]>) = getMockURLSession(fileName: "user_trades")
        let router = Router<BitsoEndPoint>(session: tuple.session)
        let bitso = Bitso(key: key, secret: secret, environment: .developV3, router: router)
        bitso.userTrades(book: "", sort: nil, limit: nil, marker: nil){ result in
            if case let .success(userTrades) = result {
                XCTAssertEqual(userTrades, tuple.stub.payload)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_bitso_error() throws {
        let expectation = XCTestExpectation(description: "Fake Network Call")

        let json = stubbedResponse("error")
        let stubError = try! getDencoder().decode(BitsoResponse<String>.self, from: json)

        URLProtocolMock.testData = json
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]

        let router = Router<BitsoEndPoint>(session: URLSession(configuration: config))
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
        let router = Router<BitsoEndPoint>(session: URLSession.shared)
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
    
    /*func test_live_call_account() throws {
        let expectation = XCTestExpectation(description: "True Network Call")
        let router = Router<BitsoEndPoint>(session: URLSession.shared, enableDebugLogs: true)
        let bitso = Bitso(key: "", secret: "", environment: .productionV3, router: router)
        bitso.balance { (result) in
            debugPrint(result)
            switch result {
            case .success(let trades):
                XCTAssertNotNil(trades)
                expectation.fulfill()
            case .failure(let error):
                debugPrint(error)
                XCTFail()
                expectation.fulfill()
            }        }
        wait(for: [expectation], timeout: 5)
    }*/
}

func stubbedResponse(_ filename: String) -> Data {
    @objc class FeelitTests: NSObject { }
    let thisSourceFile = URL(fileURLWithPath: #file)
    let thisDirectory = thisSourceFile.deletingLastPathComponent()
    let resourceURL = thisDirectory.appendingPathComponent("fixtures/\(filename).json")
    return try! Data(contentsOf: resourceURL)
}
