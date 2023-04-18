//
//  IPAddressInformation.swift
//  
//
//  Created by Mat Yates on 18/4/2023.
//

import Foundation

public struct IPAddressInformation: Codable {
    
    /**
     The IP Address.
     
     - Returns: String.
     */
    let ip: String
    
    /**
     The city of the IP Address.
     
     - Returns: String.
     */
    let city: String
    
    /**
     The region of the IP Address.
     
     - Returns: String.
     */
    let region: String
    
    /**
     The region code of the IP Address.
     
     - Returns: String.
     */
    let regionCode: String
    
    /**
     The country code of the IP Address.
     
     - Returns: String.
     */
    let country: String
    
    /**
     The country name of the IP Address.
     
     - Returns: String.
     */
    let countryName: String
    
    /**
     The continent code of the IP Address.
     
     - Returns: String.
     */
    let continentCode: String
    
    /**
     Determines if the IP address is in the Europena Union.
     
     - Returns: Bool.
     */
    let isInEU: Bool
    
    /**
     The postcode of the IP Address.
     
     - Returns: String.
     */
    let postal: String
    
    /**
     The lattitude of the IP Address.
     
     - Returns: Double.
     */
    let latitude: Double
    
    /**
     The longitude of the IP Address.
     
     - Returns: Double.
     */
    let longitude: Double
    
    /**
     The timezone of the IP Address.
     
     - Returns: String.
     */
    let timezone: String
    
    /**
     The UTC offset of the IP Address.
     
     - Returns: String.
     */
    let utcOffset: String
    
    /**
     The country calling code of the IP Address.
     
     - Returns: String.
     */
    let countryCallingCode: String
    
    /**
     The currency of the IP Address.
     
     - Returns: String.
     */
    let currency: String
    
    /**
     The languages of the IP Address.
     
     - Returns: String.
     */
    let languages: String
    
    /**
     The Autonomous System Number of the IP Address.
     
     - Returns: String.
     */
    let asn: String
    
    /**
     The org of the IP Address.
     
     - Returns: String.
     */
    let org: String
    
    enum CodingKeys: String, CodingKey {
        case ip
        case city
        case region
        case regionCode = "region_code"
        case country
        case countryName = "country_name"
        case continentCode = "continent_code"
        case isInEU = "in_eu"
        case postal
        case latitude
        case longitude
        case timezone
        case utcOffset = "utc_offset"
        case countryCallingCode = "country_calling_code"
        case currency
        case languages
        case asn
        case org
    }
}

