// swiftlint:disable identifier_name
import Foundation
import Starscream

public enum Type: String, Codable {
    case trades
    case diff_orders = "diff-orders"
    case orders
}

public enum Action: String, Codable {
    case subscribe
}

public struct LiveRequest: Encodable {
    let action: Action
    let book: BookSymbol
    let type: Type
}

public protocol LiveResponse {
    var type: Type { get }
}

public struct SubscriptionResponse: LiveResponse, Decodable {
    let action: Action
    public let type: Type
    let time: Int
    let response: String
}

public struct LiveTrade: Decodable {
    let i: Int
    let a: String
    let r: String
    let v: String
    let mo: String?
    let to: String?
    let t: Int?
}

public struct TradeResponse: LiveResponse, Decodable {
    let book: BookSymbol
    public let type: Type
    let payload: [LiveTrade]
}

public struct LiveOrder: Decodable {
    let o: String
    let r: Float
    let a: Float
    let v: Float
    let t: Int
    let d: Int
    let s: String
}

public struct OrderPayload: Decodable {
    let bids: [LiveOrder]?
    let asks: [LiveOrder]?
}

public struct OrderResponse: LiveResponse, Decodable {
    let book: BookSymbol
    public let type: Type
    let payload: OrderPayload
}

public struct LiveDiffOrder: Decodable {
    let d: Int
    let r: String
    let t: Int
    let a: String?
    let v: String?
    let o: String
}

public struct DiffOrderResponse: LiveResponse, Decodable {
    public let type: Type
    let book: BookSymbol
    let sequence: Int
    let payload: [LiveDiffOrder]
}

public protocol BitsoLiveEvents: class {
    func connected()
    func disconnected(error: Error?)
    func onSubscription(response: SubscriptionResponse)
    func onTrade(response: TradeResponse)
    func onDiffOrder(response: DiffOrderResponse)
    func onOrder(response: OrderResponse)
}

public protocol BitsoWebSocketEvents: class {
    func connected(_: [String: String])
    func disconnected(_: String, _: UInt16)
    func text(_: String)
    func binary(_: Data)
    func pong(_: Data?)
    func ping(_: Data?)
    func error(_: Error?)
    func viabilityChanged(_: Bool)
    func reconnectSuggested(_: Bool)
    func cancelled()
}

public class BitsoLive {
    private var socket: WebSocket?
    private weak var delegate: BitsoLiveEvents?
    private weak var webSocketDelegate: BitsoWebSocketEvents?
    private var enableDebugLogs: Bool = false

    public init() {}

    public func start(delegate: BitsoLiveEvents, webSocketDelegate: BitsoWebSocketEvents? = nil, enableDebugLogs: Bool = false) {
        self.enableDebugLogs = enableDebugLogs
        var request = URLRequest(url: URL(string: "wss://ws.bitso.com")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
        self.delegate = delegate
        self.webSocketDelegate = webSocketDelegate
    }

    public func subscribeToTrades(book: BookSymbol) -> Bool {
        let request = LiveRequest(action: .subscribe, book: book, type: .trades)
        return writeToSocket(request: request)
    }

    public func subscribeToDiffOrders(book: BookSymbol) -> Bool {
        let request = LiveRequest(action: .subscribe, book: book, type: .diff_orders)
        return writeToSocket(request: request)
    }

    public func subscribeToOrders(book: BookSymbol) -> Bool {
        let request = LiveRequest(action: .subscribe, book: book, type: .orders)
        return writeToSocket(request: request)
    }

    private func writeToSocket(request: LiveRequest) -> Bool {
        guard let jsonData = try? JSONEncoder().encode(request) else { return false }
        guard let socket = socket else { return false }
        socket.write(data: jsonData)
        return true
    }

    public func disconnect() {
        socket?.disconnect()
        socket = nil
        delegate = nil
    }
}

extension BitsoLive: WebSocketDelegate {
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            if enableDebugLogs { debugPrint("conected with headers \(headers)") }
            webSocketDelegate?.connected(headers)
            delegate?.connected()
        case .disconnected(let reason, let code):
            if enableDebugLogs { debugPrint("disconnected with reason \(reason) \(code)") }
            webSocketDelegate?.disconnected(reason, code)
            delegate?.disconnected(error: nil)
        case .text(let string):
            if enableDebugLogs { debugPrint("text \(string)") }
            webSocketDelegate?.text(string)
            onText(string: string)
        case .binary(let data):
            if enableDebugLogs { debugPrint("binary") }
            webSocketDelegate?.binary(data)
        case .ping(let data):
            if enableDebugLogs { debugPrint("ping") }
            webSocketDelegate?.ping(data)
        case .pong(let data):
            if enableDebugLogs { debugPrint("pong") }
            webSocketDelegate?.pong(data)
        case .viabilityChanged(let visible):
            if enableDebugLogs { debugPrint("viabilityChanged \(visible)") }
            webSocketDelegate?.viabilityChanged(visible)
        case .reconnectSuggested(let reconnect):
            if enableDebugLogs { debugPrint("reconnectSuggested \(reconnect)") }
            webSocketDelegate?.reconnectSuggested(reconnect)
        case .cancelled:
            if enableDebugLogs { debugPrint("cancelled") }
            webSocketDelegate?.cancelled()
        case .error(let error):
            if enableDebugLogs { debugPrint("error \(error?.localizedDescription ?? "")") }
            webSocketDelegate?.error(error)
            debugPrint(error!)
        }
    }

    private func onText(string: String) {
        guard let data = string.data(using: .utf8) else { return }
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }

        guard let jsonType = jsonResponse["type"] as? String, let type = Type(rawValue: jsonType) else { return }

        if let jsonAction = jsonResponse["action"] as? String,
           let action = Action(rawValue: jsonAction),
           action == .subscribe {
            guard let response = try? JSONDecoder().decode(SubscriptionResponse.self, from: data) else { return }
            delegate?.onSubscription(response: response)
            return
        }
        switch type {
        case .orders:
            guard let response = try? JSONDecoder().decode(OrderResponse.self, from: data) else { return }
            delegate?.onOrder(response: response)
        case .diff_orders:
            guard let response = try? JSONDecoder().decode(DiffOrderResponse.self, from: data)  else { return }
            delegate?.onDiffOrder(response: response)
        case .trades:
            guard let response = try? JSONDecoder().decode(TradeResponse.self, from: data) else { return }
            delegate?.onTrade(response: response)
        }
    }
}
