# Bitso ![Swift](https://github.com/ajamaica/Bitso.Swift/workflows/Swift/badge.svg)

This is the unofficial (not verified) Bitso Swift SDK. Implements the private , public and live api [documentation](https://bitso.com/api_info/).

The idea is to sustitute the old archived repo using the v3 api. This project is trying to approach this problem with 2 imposed limitation the lowest API possible, the most test possible and less dependencies possible. Its supports the header signature, mocking, pass a custom URLSession, basic logging and websocket connectivity. Keep in mind this is mostly on WIP but most of the tests are comparable with the Python library from the company.

## Features
- [x] Public api (100%)
- [x] Private api (90%)
- [x] Header signature and Authentication 
- [x] Websockets API (100%)
- [x] Less dependencys as possible
- [x] Tested
- [x] Logging support
- [x] SPM
- [x] iOS, Mac OS, TV OS, watch OS

# How to use it

## Bitso

The simplest way to use it is this:
```
import Bitso

let router = Router<BitsoEndPoint>()
let bitso = Bitso(key: "API_KEY", secret: "API_KEY", environment: .developV3, router: router) 
bitso.tradesFor(bookID: "btc_mxn", marker: nil, sort: nil, limit: nil) {  (result) in
    switch result {
    case .success(let trades):
        debugPrint(trades)
    case .failure(let error):
        debugPrint(error)
    }
}
```
This call will ask for the curent trades for btc_mxn and return the trade objects. Note that is using the  *developV3* enviroment. 

Take a look at the Router.  This is the default BitsoEndPoint that enables the calls wrapping URLSession.shared. This also controls the logging. You can implement your Router using your own network library if you want in the future. This can also enable future compatibility for linux, since this has all the networking call sepaeating the logic accordingly.

```
let router = Router<BitsoEndPoint>()
```

To enable logs and another session.
```
let router = Router<BitsoEndPoint>(session: .shared, enableDebugLogs: true)
```

The Bitso object is the most important object it gets the key and secret. This can obtain from the [user panel](https://bitso.com/api_setup). 
```
let bitso = Bitso(key: "API_KEY", secret: "API_KEY", environment: .developV3, router: router) 
```
There are 2 available enviroments :
```
case productionV3 = "https://api.bitso.com/v3/"
case developV3 = "https://api-dev.bitso.com/v3/"
```

This are the available calls for Bitso
```
/* Private */
case available_books
case ticker(bookID: BookSymbol)
case order_book(bookID: BookSymbol, aggregate: Bool?)
case trades(bookID: BookSymbol, marker: Bool?, sort: SortType?, limit: Int?)
/* Private */
case account_status
case phoneNumber(phone_number: String)
case phoneVerification(verification_code: String)
case balance
case fees

case ledger(marker: String?, sort: SortType?, limit: Int?)
case ledgerTrades(marker: String?, sort: SortType?, limit: Int?)
case ledgerFees(marker: String?, sort: SortType?, limit: Int?)
case ledgerFundings(marker: String?, sort: SortType?, limit: Int?)
case ledgerWithdrawals(marker: String?, sort: SortType?, limit: Int?)

case withdrawals(wid: WithdrawalId, marker: String?, limit: Int?, status: Status?, method: String?)
case withdrawalsForWid(wid: WithdrawalId, marker: String?, limit: Int?, status: Status?, method: String?)
case withdrawalsForWids(wids: [WithdrawalId], marker: String?, limit: Int?, status: Status?, method: String?)
case withdrawalsForOrigin(origin_ids: [OriginID], marker: String?, limit: Int?, status: Status?, method: String?)

case fundings(marker: String?, limit: Int?, status: Status?, method: String?, txids: [String]?)
case fundingsTid(marker: String?, limit: Int?, status: Status?, method: String?, txids: [String]?)
case fundingsTidTidTid(marker: String?, limit: Int?, status: Status?, method: String?, txids: [String]?)

case userTrades(book: BookSymbol, sort: SortType?, limit: Int?, marker: String?)
case userTradesTid(book: BookSymbol, sort: SortType?, limit: Int?, marker: String?)
case userTradesTidTidTid(book: BookSymbol, sort: SortType?, limit: Int?, marker: String?)
case orderTrades(oid: OrderId)
case orderTradesWithorigin(origin_id: String)

case openOrders(book: BookSymbol, marker: String?, sort: SortType?, limit: Int?)

case orders(oid: OrderId)
case ordersWithOids(oids: [OrderId])
case ordersWithOrigin(origin_ids: [String])

case cancelOrder(oid: OrderId)
case cancelOrderWithOids(oids: [OrderId])
case cancelOrderWithOrigin(origin_ids: [String])
case cancelAllOrders

case createOrder(book: BookSymbol, side: Side, amount: OrderAmount, origin_id: String?, time_in_force: TimeInForce?)
case createOrderLimit(book: BookSymbol, side: Side, amount: OrderAmount, price: String, stop: String, time_in_force: TimeInForce?, origin_id: String?)
```

Kepp in mind that the Header Signature will be automatically added and *NEVER* stored on the library. Its your responsability to store it in a place that is not accesible. I am not responsable for any leaked secret keys.

## BitsoLive

In addition to the normal api, there is a Live api (realtime, websockets...). This api is using Starscream. I consider this functional and complete but keep inmind that it might change in the future more that the standard api. This api is mostly risk free since there is no user operation involved.

To use it :

```
let live = BitsoLive()
live.start(delegate: self)
```

The delegate must comply the BitsoLiveEvents protocol. I also add a pure websocket implementation using BitsoWebSocketEvents. This last one is optional.

```
let live = BitsoLive()
live.start(delegate: self, webSocketDelegate: self)
```
logging is also available 
```
let live = BitsoLive()
live.start(delegate: self, webSocketDelegate: self, enableDebugLogs: true)
```

To get the output use the delegate

```
extension BitsoLiveCountWrapper: BitsoLiveEvents {
    func onSubscription(response: SubscriptionResponse) {

    }
    
    func onTrade(response: TradeResponse) {

    }
    
    func onDiffOrder(response: DiffOrderResponse) {

    }
    
    func onOrder(response: OrderResponse) {
    
    }
    
    func connected() {

    }
    
    func disconnected(error: Error?) {

    }
}
```

## Requirements

- iOS 11.0+ / macOS 10.13+ / tvOS 11.0+ / watchOS 3.0+
- Swift 5.3+

### Installation

From Xcode 11, you can use [Swift Package Manager](https://swift.org/package-manager/) to add Bitso.swift to your project.

- File > Swift Packages > Add Package Dependency
- Add `https://github.com/ajamaica/Bitso.Swift`
- Select "Up to Next Major" with "1.0.0"

If you encounter any problem or have a question on adding the package to an Xcode project, I suggest reading the [Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)  guide article from Apple.

## Other

### Ideas and plans

The main personal objective was to create an approchable interface to the api using moder (Swifty tools). That is why this project uses SPM, Codable, Networking and CommonCrypto. I consider the API (non live) part of the library (Bitso) architecturally complete and stable, but the websockets part with the biggest oportunity I might rewrite it into callbacks rather that delegates (or booth). I am planing to support this as I can. *Please send a PR I will apreciate help*. 

Tests cover all the uses cases mocking the API from the Bitso official documentation examples. It also tests the Signature code by creating a HMAC 256 from shell and the comparing it with one created at another source (python code). 

Currently there is only one dependency [Starscream](https://github.com/daltoniam/Starscream). I do like this library a lot but I am planning to implement my own websockets library with the networking API. BitsoLive will remain supported until then.


If you like what I did please considering donating:

<img src="https://bitso.com/getqrcode/btc/358ZN8oh2CZPoxZGbghh1qXCfPoX7rXuAQ" alt="BTC" width="200"/>
BTC: 358ZN8oh2CZPoxZGbghh1qXCfPoX7rXuAQ

Questions? [@ajamaica](http://twitter.com/ajamaica)
