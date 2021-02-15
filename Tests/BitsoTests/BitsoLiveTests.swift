import XCTest
@testable import Bitso

class BitsoLiveCountWrapper {
    var countConnected = 0
    var countTrade = 0
    var countDiffOrder = 0
    var countOrder = 0
    var countSubscription = 0
    
    var whenConnected: (() -> Void)?
    var whenSubscribed: (() -> Void)?
    
    let live = BitsoLive()
    
    func start(whenConnected: (() -> Void)?){
        self.whenConnected = whenConnected
        live.start(delegate: self)
    }
    
    func subscribeToTrades(){
        let isSuccess = live.subscribeToTrades(book: "btc_mxn")
        debugPrint(isSuccess)
    }
    
    func subscribeToOrders(){
        let isSuccess = live.subscribeToOrders(book: "btc_mxn")
        debugPrint(isSuccess)
    }
    
    func subscribeToDiffOrders(){
        let isSuccess = live.subscribeToDiffOrders(book: "btc_mxn")
        debugPrint(isSuccess)
    }
}

extension BitsoLiveCountWrapper: BitsoLiveEvents {
    func onSubscription(response: SubscriptionResponse) {
        countSubscription += 1
    }
    
    func onTrade(response: TradeResponse) {
        countTrade += 1
    }
    
    func onDiffOrder(response: DiffOrderResponse) {
        countDiffOrder += 1
    }
    
    func onOrder(response: OrderResponse) {
        countOrder += 1
    }
    
    func connected() {
        countConnected += 1
        whenConnected?()
    }
    
    func disconnected(error: Error?) {
        countConnected -= 1
    }
}

class BitsoLiveTests: XCTestCase {
    let timeout = TimeInterval(30)
    func test_conection(){
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let live = BitsoLiveCountWrapper()
        live.start {
            XCTAssertEqual(1, live.countConnected)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_conection_disconnection(){
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let live = BitsoLiveCountWrapper()
        live.start{
            live.disconnected(error: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                XCTAssertEqual(0, live.countConnected)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func test_subscribes(){
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let live = BitsoLiveCountWrapper()
        live.start{
            XCTAssertEqual(1, live.countConnected)
            live.subscribeToTrades()
            live.subscribeToOrders()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                XCTAssertEqual(2, live.countSubscription)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    /*
     Some times there are no trades in seconds.
     This test make the CI fail since it is using the live bitso websocket server
     
     func test_subscribeTrades(){
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let live = BitsoLiveCountWrapper()
        live.start{
            XCTAssertEqual(1, live.countConnected)
            live.subscribeToTrades()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                XCTAssertEqual(1, live.countSubscription)
                XCTAssert(1 < live.countTrade)
                XCTAssertEqual(0, live.countOrder)
                XCTAssertEqual(0, live.countDiffOrder)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }*/
    
    func test_subscribeOrders(){
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let live = BitsoLiveCountWrapper()
        live.start{
            XCTAssertEqual(1, live.countConnected)
            live.subscribeToOrders()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                XCTAssert(1 < live.countOrder)
                XCTAssertEqual(0, live.countTrade)
                XCTAssertEqual(0, live.countDiffOrder)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: timeout)
    }
    
    func test_subscribeDiffOrders(){
        let expectation = XCTestExpectation(description: "Fake Network Call")
        let live = BitsoLiveCountWrapper()
        live.start{
            XCTAssertEqual(1, live.countConnected)
            live.subscribeToDiffOrders()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                XCTAssert(1 < live.countDiffOrder)
                XCTAssertEqual(0, live.countTrade)
                XCTAssertEqual(0, live.countOrder)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
}

