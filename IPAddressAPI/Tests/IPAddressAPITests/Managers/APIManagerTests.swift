//
//  APIManagerTests.swift
//
//
//  Created by Mat Yates on 18/4/2023.
//

import XCTest
@testable import IPAddressAPI

final class APIManagerTests: XCTestCase {
    
    func testIPAddressUrlRequest() {
        let manager = self.setupApiManager()
        let ipAddressUrlRequest = manager.ipAddressUrlRequest
        XCTAssertNotNil(ipAddressUrlRequest)
    }
    
    func testCheckStatusCodeValid() throws {
        let statusCodes = Array(200...299)
        for statusCode in statusCodes {
            let result = try self.checkStatusCode(statusCode: statusCode)
            switch result {
            case .success:
                XCTAssert(true)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testCheckStatusCodeBadRequest() throws {
        let statusCodes = Array(400...499)
        for statusCode in statusCodes {
            let result = try self.checkStatusCode(statusCode: statusCode)
            switch result {
            case .success:
                XCTFail("Incorrect result type.")
            case .failure(let error):
                XCTAssert(true)
                if let error = error as? APIManager.APIError {
                    let badRequestError = APIManager.APIError.badRequest
                    XCTAssertEqual(error, badRequestError)
                } else {
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    func testCheckStatusCodeServerError() throws {
        let statusCodes = Array(500...599)
        for statusCode in statusCodes {
            let result = try self.checkStatusCode(statusCode: statusCode)
            switch result {
            case .success:
                XCTFail("Incorrect result type.")
            case .failure(let error):
                XCTAssert(true)
                if let error = error as? APIManager.APIError {
                    let serverError = APIManager.APIError.serverError
                    XCTAssertEqual(error, serverError)
                } else {
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    func testCheckStatusCodeUnknownError() throws {
        let statusCodes: [Int] = [199, 300, 399, 600]
        for statusCode in statusCodes {
            let result = try self.checkStatusCode(statusCode: statusCode)
            switch result {
            case .success:
                XCTFail("Incorrect result type.")
            case .failure(let error):
                XCTAssert(true)
                if let error = error as? APIManager.APIError {
                    let unknownError = APIManager.APIError.unknown
                    XCTAssertEqual(error, unknownError)
                } else {
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    func testGetUsersIPDetailsSuccess() async throws {
        let testIp = "208.67.222.222"
        let testCity = "San Francisco"
        let testRegion = "California"
        let testRegionCode = "CA"
        let testCountry = "US"
        let testCountryName = "United States"
        let testContinentCode = "NA"
        let testIsInEU = false
        let testPostal = "94107"
        let testLatitude = 37.7697
        let testLongitude = -122.3933
        let testTimezone = "America/Los_Angeles"
        let testUtcOffset = "-0700"
        let testCountryCallingCode = "+1"
        let testCurrency = "USD"
        let testLanguages = "en-US,es-US,haw,fr"
        let testAsn = "AS36692"
        let testOrg = "OpenDNS, LLC"
        let mockJSONData = """
                            {
                                "ip": "\(testIp)",
                                "city": "\(testCity)",
                                "region": "\(testRegion)",
                                "region_code": "\(testRegionCode)",
                                "country": "\(testCountry)",
                                "country_name": "\(testCountryName)",
                                "continent_code": "\(testContinentCode)",
                                "in_eu": \(testIsInEU),
                                "postal": "\(testPostal)",
                                "latitude": \(testLatitude),
                                "longitude": \(testLongitude),
                                "timezone": "\(testTimezone)",
                                "utc_offset": "\(testUtcOffset)",
                                "country_calling_code": "\(testCountryCallingCode)",
                                "currency": "\(testCurrency)",
                                "languages": "\(testLanguages)",
                                "asn": "\(testAsn)",
                                "org": "\(testOrg)"
                            }
                            """.data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockJSONData)
        }
        
        let manager = self.setupApiManager()
        let ipDetails = try await manager.getUsersIPDetails()
        XCTAssertEqual(ipDetails.ip, testIp)
        XCTAssertEqual(ipDetails.city, testCity)
        XCTAssertEqual(ipDetails.region, testRegion)
        XCTAssertEqual(ipDetails.regionCode, testRegionCode)
        XCTAssertEqual(ipDetails.country, testCountry)
        XCTAssertEqual(ipDetails.countryName, testCountryName)
        XCTAssertEqual(ipDetails.continentCode, testContinentCode)
        XCTAssertEqual(ipDetails.isInEU, testIsInEU)
        XCTAssertEqual(ipDetails.postal, testPostal)
        XCTAssertEqual(ipDetails.latitude, testLatitude)
        XCTAssertEqual(ipDetails.longitude, testLongitude)
        XCTAssertEqual(ipDetails.timezone, testTimezone)
        XCTAssertEqual(ipDetails.utcOffset, testUtcOffset)
        XCTAssertEqual(ipDetails.countryCallingCode, testCountryCallingCode)
        XCTAssertEqual(ipDetails.currency, testCurrency)
        XCTAssertEqual(ipDetails.languages, testLanguages)
        XCTAssertEqual(ipDetails.asn, testAsn)
        XCTAssertEqual(ipDetails.org, testOrg)
    }
    
    func testGetUsersIPDetailsFail() async throws {
        let testIp = "208.67.222.222"
        let testCity = "San Francisco"
        let testRegion = "California"
        let testRegionCode = "CA"
        let mockJSONData = """
                            {
                                "ip": "\(testIp)",
                                "city": "\(testCity)",
                                "region": "\(testRegion)",
                                "region_code": "\(testRegionCode)",
                            }
                            """.data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockJSONData)
        }
        
        let manager = self.setupApiManager()
        do {
            _ = try await manager.getUsersIPDetails()
            XCTFail()
        } catch {
            XCTAssert(true)
        }
    }
    
    // MARK: - Helpers
    
    /**
     Tests a valid status code for the api manager.
     
     - Parameter statusCode: Int.
     */
    func checkStatusCode(statusCode: Int) throws -> Result<Void, Error> {
        let manager = self.setupApiManager()
        let url = try XCTUnwrap(URL(string: "https://www.google.com"))
        let urlResponse = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil))
        let result = manager.checkStatusCode(response: urlResponse)
        switch result {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /**
     Sets up a url session using the mock url protocol.
     
     - Returns: URLSession.
     */
    func setupUrlSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession.init(configuration: configuration)
    }
    
    /**
     Sets up a APIManager using a mock url session for testing.
     
     - Returns: APIManager.
     */
    func setupApiManager() -> APIManager {
        let session = self.setupUrlSession()
        let baseUrl = ""
        return APIManager(session: session, baseUrl: baseUrl)
    }
}
