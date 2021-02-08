import Foundation

class URLProtocolMock: URLProtocol {
    // this dictionary maps URLs to test data
    static var testData = Data()
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        let response = HTTPURLResponse(
            url: URL(string: "http://localhost.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)

        self.client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
        self.client?.urlProtocol(self, didLoad: URLProtocolMock.testData)
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}
