//
//  IPAddressInformationTests.swift
//  
//
//  Created by Mat Yates on 18/4/2023.
//

import XCTest
@testable import IPAddressAPI

final class IPAddressInformationTests: XCTestCase {
    
    func testIPAddressInformation() throws {
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
 
        let ipAddressInformation = IPAddressInformation(ip: testIp,
                                                        city: testCity,
                                                        region: testRegion,
                                                        regionCode: testRegionCode,
                                                        country: testCountry,
                                                        countryName: testCountryName,
                                                        continentCode: testContinentCode,
                                                        isInEU: testIsInEU,
                                                        postal: testPostal,
                                                        latitude: testLatitude,
                                                        longitude: testLongitude,
                                                        timezone: testTimezone,
                                                        utcOffset: testUtcOffset,
                                                        countryCallingCode: testCountryCallingCode,
                                                        currency: testCurrency,
                                                        languages: testLanguages,
                                                        asn: testAsn,
                                                        org: testOrg)
        XCTAssertEqual(ipAddressInformation.ip, testIp)
        XCTAssertEqual(ipAddressInformation.city, testCity)
        XCTAssertEqual(ipAddressInformation.region, testRegion)
        XCTAssertEqual(ipAddressInformation.regionCode, testRegionCode)
        XCTAssertEqual(ipAddressInformation.country, testCountry)
        XCTAssertEqual(ipAddressInformation.countryName, testCountryName)
        XCTAssertEqual(ipAddressInformation.continentCode, testContinentCode)
        XCTAssertEqual(ipAddressInformation.isInEU, testIsInEU)
        XCTAssertEqual(ipAddressInformation.postal, testPostal)
        XCTAssertEqual(ipAddressInformation.latitude, testLatitude)
        XCTAssertEqual(ipAddressInformation.longitude, testLongitude)
        XCTAssertEqual(ipAddressInformation.timezone, testTimezone)
        XCTAssertEqual(ipAddressInformation.utcOffset, testUtcOffset)
        XCTAssertEqual(ipAddressInformation.countryCallingCode, testCountryCallingCode)
        XCTAssertEqual(ipAddressInformation.currency, testCurrency)
        XCTAssertEqual(ipAddressInformation.languages, testLanguages)
        XCTAssertEqual(ipAddressInformation.asn, testAsn)
        XCTAssertEqual(ipAddressInformation.org, testOrg)
    }
    
    func testJson() throws {
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
        
        let ipAddressInformation = try XCTUnwrap(try JSONDecoder().decode(IPAddressInformation.self, from: mockJSONData))
        XCTAssertEqual(ipAddressInformation.ip, testIp)
        XCTAssertEqual(ipAddressInformation.city, testCity)
        XCTAssertEqual(ipAddressInformation.region, testRegion)
        XCTAssertEqual(ipAddressInformation.regionCode, testRegionCode)
        XCTAssertEqual(ipAddressInformation.country, testCountry)
        XCTAssertEqual(ipAddressInformation.countryName, testCountryName)
        XCTAssertEqual(ipAddressInformation.continentCode, testContinentCode)
        XCTAssertEqual(ipAddressInformation.isInEU, testIsInEU)
        XCTAssertEqual(ipAddressInformation.postal, testPostal)
        XCTAssertEqual(ipAddressInformation.latitude, testLatitude)
        XCTAssertEqual(ipAddressInformation.longitude, testLongitude)
        XCTAssertEqual(ipAddressInformation.timezone, testTimezone)
        XCTAssertEqual(ipAddressInformation.utcOffset, testUtcOffset)
        XCTAssertEqual(ipAddressInformation.countryCallingCode, testCountryCallingCode)
        XCTAssertEqual(ipAddressInformation.currency, testCurrency)
        XCTAssertEqual(ipAddressInformation.languages, testLanguages)
        XCTAssertEqual(ipAddressInformation.asn, testAsn)
        XCTAssertEqual(ipAddressInformation.org, testOrg)
    }
}
