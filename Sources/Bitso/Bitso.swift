import Foundation

public class Bitso {
    private let environment: BitsoNetworkEnvironment
    private let router: Router<BitsoEndPoint>

    init(router: Router<BitsoEndPoint>, environment: BitsoNetworkEnvironment) {
        self.router = router
        self.environment = environment
    }

    func available_books(completion: @escaping (Result<[Book], BitsoError>) -> Void ) {
        request(apiCall: .available_books, completion: completion)
    }
    
    func ticker(completion: @escaping (Result<Ticker, BitsoError>) -> Void ) {
        request(apiCall: .ticker, completion: completion)
    }

    private func request<Payload: Decodable>(apiCall: BitsoAPICall,
                                             completion: @escaping (Result<Payload, BitsoError>) -> Void ) {
        router.request(.init(enviroment: environment, apiCall: apiCall)) { ( data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(BitsoError.canNotReadError))
            }
            completion(self.handleNetworkResponse(response, data, error))
        }
    }
    
    private func handleNetworkResponse<Payload: Decodable>(_ response: HTTPURLResponse,
                                                           _ data: Data?,
                                                           _ error: Error?) -> Result<Payload, BitsoError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(BitsoDateDecodingStrategy.decode)
        
        if let error = error { return .failure(BitsoError(code: "-2", message: error.localizedDescription)) }
        if let data =  data,
           let response = try? decoder.decode(BitsoResponse<Payload>.self, from: data){
            if let payload = response.payload {
                return .success(payload)
            } else if let error = response.error {
                return .failure(error)
            }
        }
        return .failure(BitsoError.canNotReadError)
    }
}

