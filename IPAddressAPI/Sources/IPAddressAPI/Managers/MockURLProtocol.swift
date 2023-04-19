//
//  MockURLProtocol.swift
//  
//
//  Created by Mat Yates on 18/4/2023.
//

import Foundation

public class MockURLProtocol: URLProtocol {
    
    public static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
  
    public override class func canInit(with request: URLRequest) -> Bool {
        // To check if this protocol can handle the given request.
        return true
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Here you return the canonical version of the request but most of the time you pass the orignal one.
        return request
    }

    public override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            let error = NSError(domain: "", code: 1)
            self.client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        do {
            let (response, data) = try handler(request)
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        } catch {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
    }

    public override func stopLoading() {
        // This is called if the request gets canceled or completed.
    }
}
