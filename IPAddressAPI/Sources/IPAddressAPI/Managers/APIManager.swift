//
//  APIManager.swift
//  CodeDemoSwift
//
//  Created by Mat Yates on 18/4/2023.
//

import Foundation

/**
 In a real app this would contain a lot more logic, as this app only requires 1 API it is quite a simple class.
 */
public class APIManager {
    
    // MARK: - Properties
    
    /**
     Reusable url session.
     
     - Returns: URLSession.
     */
    private let session: URLSession
    
    /**
     Base url to be used for API calls.
     
     - Returns: String.
     */
    private let baseUrl: String
    
    // MARK: - Init
    
    public init(session: URLSession, baseUrl: String = "https://ipapi.co/") {
        self.session = session
        self.baseUrl = baseUrl
    }
    
    /**
     Url request to get the IP address information.
     
     - Returns: Optional URLRequest.
     */
    public var ipAddressUrlRequest: URLRequest? {
        let urlString = self.baseUrl + "json"
        guard let url = URL(string: urlString) else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
    
    /**
     Gets the users ip address details.
     
     - Returns: IPAddressInformation.
     */
    public func getUsersIPDetails() async throws -> IPAddressInformation {
        guard let urlRequest = self.ipAddressUrlRequest else { throw APIError.badUrl }
        let (data, response) = try await self.session.data(for: urlRequest)
        let result = self.checkStatusCode(response: response)
        switch result {
        case .success:
            return try JSONDecoder().decode(IPAddressInformation.self, from: data)
        case .failure(let error):
            throw error
        }
    }
    
    // MARK: - Helpers
    
    /**
     Checks if the http response status code is valid.
     
     - Parameter response: URLResponse.
     - Returns: Result type of Void or Error.
     */
    public func checkStatusCode(response: URLResponse) -> Result<Void, Error> {
        guard let httpResponse = response as? HTTPURLResponse else { return .failure(APIError.unknown) }
        
        switch httpResponse.statusCode {
        case 200...299:
            return .success(())
        case 400...499:
            return .failure(APIError.badRequest)
        case 500...599:
            return .failure(APIError.serverError)
        default:
            return .failure(APIError.unknown)
        }
    }
    
    public enum APIError: Error {
        case badRequest, serverError, unknown, badUrl
    }
}
