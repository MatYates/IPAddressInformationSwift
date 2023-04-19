//
//  IPAddressDetailsViewModelTests.swift
//  IPAddressInformationSwiftTests
//
//  Created by Mat Yates on 19/4/2023.
//

import XCTest
@testable import IPAddressInformationSwift
import IPAddressAPI
import Combine

final class IPAddressDetailsViewModelTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        self.cancellables = []
    }
    
    func testLoadIPAddressInformationTaskSuccess() throws {
        let viewModel = self.setupViewModel(mockJSONData: self.validData())
        let expectation = self.expectation(description: "IP Address Information Available")
        viewModel.loadIPAddressInformationTask()
        var state: IPAddressDetailsViewModel.ViewState = .loading
        viewModel.$viewState
            .dropFirst()
            .sink { viewState in
                state = viewState
                switch viewState {
                case .ipAddressDetails:
                    expectation.fulfill()
                default:
                    break
                }
            }.store(in: &self.cancellables)
        waitForExpectations(timeout: 10)
        
        switch state {
        case .ipAddressDetails:
            XCTAssert(true)
        default:
            XCTFail("Incorrect state")
        }
    }
    
    func testLoadIPAddressInformationTaskFail() throws {
        let viewModel = self.setupViewModel(mockJSONData: self.invalidData())
        let expectation = self.expectation(description: "IP Address Information Failed")
        viewModel.loadIPAddressInformationTask()
        var state: IPAddressDetailsViewModel.ViewState = .loading
        viewModel.$viewState
            .dropFirst()
            .sink { viewState in
                state = viewState
                switch viewState {
                case .failedLoading:
                    expectation.fulfill()
                default:
                    break
                }
            }.store(in: &self.cancellables)
        waitForExpectations(timeout: 10)
        
        switch state {
        case .failedLoading:
            XCTAssert(true)
        default:
            XCTFail("Incorrect state")
        }
    }
    
    func testConvertToDisplayType() throws {
        let ipAddressInformation = try XCTUnwrap(try JSONDecoder().decode(IPAddressInformation.self, from: self.validData()))
        let viewModel = self.setupViewModel(mockJSONData: self.validData())
        let output = viewModel.convertToDisplayType(ipAddressInformation: ipAddressInformation)
        XCTAssertEqual(output.count, 17)
    }
    
    // MARK: - Helpers
    
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
    func setupApiManager(mockJSONData: Data) -> APIManager {
        let session = self.setupUrlSession()
        let baseUrl = ""
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockJSONData)
        }
        return APIManager(session: session, baseUrl: baseUrl)
    }
    
    /**
     Helper to setup the view model for testing.
     
     - Parameter mockJSONData: Data.
     - Returns: IPAddressDetailsViewModel.
     */
    func setupViewModel(mockJSONData: Data) -> IPAddressDetailsViewModel {
        let apiManager = self.setupApiManager(mockJSONData: mockJSONData)
        return IPAddressDetailsViewModel(apiManager: apiManager)
    }
    
    /**
     Valid json data.
     
     - Returns: Data.
     */
    func validData() -> Data {
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
        return mockJSONData
    }
    
    /**
     Valid json data.
     
     - Returns: Data.
     */
    func invalidData() -> Data {
        let testIp = "208.67.222.222"
        let mockJSONData = """
                            {
                                "ip": "\(testIp)",
                            }
                            """.data(using: .utf8)!
        return mockJSONData
    }
}

