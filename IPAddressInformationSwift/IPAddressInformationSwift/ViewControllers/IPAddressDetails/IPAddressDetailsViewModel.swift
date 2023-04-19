//
//  IPAddressDetailsViewModel.swift
//  IPAddressInformationSwift
//
//  Created by Mat Yates on 18/4/2023.
//

import Foundation
import IPAddressAPI
import Combine
import MapKit

class IPAddressDetailsViewModel {
    
    // MARK: - Properties
    
    /**
     Helper for the  api manager.
     
     - Returns: APIManager.
     */
    lazy var apiManager: APIManager = {
        return APIManager(session: URLSession.shared)
    }()
    
    enum ViewState {
        case loading
        case failedLoading
        case ipAddressDetails([IPAddressDisplayType])
    }
    
    /**
     The current view state, this will determine what views to display.
     
     - Returns: ViewState.
     */
    @Published var viewState: ViewState = .loading
    
    // MARK: - Load Data
    
    /**
     Task to load the IP Address information and sets the correct view state.
     */
    func loadIPAddressInformationTask() {
        Task {
            await self.loadIPAddressInformation()
        }
    }
    
    /**
     Loads the IP Address information and sets the correct view state.
     */
    private func loadIPAddressInformation() async {
        do {
            self.viewState = .loading
            let ipAddressDetails = try await self.apiManager.getUsersIPDetails()
            print("Recieved IP Address details: \(ipAddressDetails)")
            let displayTypes = self.convertToDisplayType(ipAddressInformation: ipAddressDetails)
            self.viewState = .ipAddressDetails(displayTypes)
        } catch {
            print("Error fetching IP Address Information: \(error.localizedDescription)")
            self.viewState = .failedLoading
        }
    }
    
    enum IPAddressDisplayType {
        case regular(String, String)
        case location(Double, Double)
    }
    
    func convertToDisplayType(ipAddressInformation: IPAddressInformation) -> [IPAddressDisplayType] {
        return [
            .regular(Strings.ipAddressTitle, ipAddressInformation.ip),
            .regular(Strings.cityTitle, ipAddressInformation.city),
            .regular(Strings.regionTitle, ipAddressInformation.region),
            .regular(Strings.countryTitle, ipAddressInformation.countryName),
            .regular(Strings.isInEUTitle, ipAddressInformation.isInEU ? Strings.yes : Strings.no),
            .location(ipAddressInformation.latitude, ipAddressInformation.longitude)
        ]
    }
    
    /**
     Opens apple maps and displays the location.
     
     - Parameter latitude: Double.
     - Parameter longitude: Double.
     */
    func openMaps(latutude: Double, longitude: Double) {
        let coordinate = CLLocationCoordinate2DMake(latutude, longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = Strings.appleMapsTitle
        mapItem.openInMaps(launchOptions: [:])
    }
}

extension IPAddressDetailsViewModel {
    
    struct Strings {
        
        static let title = NSLocalizedString("IP Address Details", comment: "")
        static let locationTitle = NSLocalizedString("Location", comment: "")
        static let locationDescription = NSLocalizedString("Select to view in apple maps.", comment: "")
        static let appleMapsTitle = NSLocalizedString("IP address location", comment: "")
        static let yes = NSLocalizedString("Yes", comment: "")
        static let no = NSLocalizedString("No", comment: "")
        static let ipAddressTitle = NSLocalizedString("IP Address", comment: "")
        static let cityTitle = NSLocalizedString("City", comment: "")
        static let regionTitle = NSLocalizedString("Region", comment: "")
        static let countryTitle = NSLocalizedString("Country", comment: "")
        static let isInEUTitle = NSLocalizedString("In EU", comment: "")
    }
}
