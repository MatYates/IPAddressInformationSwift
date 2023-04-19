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
        let isInEU = ipAddressInformation.isInEU ? NSLocalizedString("Yes", comment: "") : NSLocalizedString("No", comment: "")
        return [
            .regular(NSLocalizedString("IP Address", comment: ""), ipAddressInformation.ip),
            .regular(NSLocalizedString("City", comment: ""), ipAddressInformation.city),
            .regular(NSLocalizedString("Region", comment: ""), ipAddressInformation.region),
            .regular(NSLocalizedString("Country", comment: ""), ipAddressInformation.countryName),
            .regular(NSLocalizedString("In EU", comment: ""), isInEU),
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
        mapItem.name = NSLocalizedString("IP address location", comment: "")
        mapItem.openInMaps(launchOptions: [:])
    }
}
