//
//  IPAddressDetailsViewModel.swift
//  IPAddressInformationSwift
//
//  Created by Mat Yates on 18/4/2023.
//

import Foundation
import IPAddressAPI
import Combine

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
        case ipAddressDetails(IPAddressInformation)
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
            self.viewState = .ipAddressDetails(ipAddressDetails)
        } catch {
            print("Error fetching IP Address Information: \(error.localizedDescription)")
            self.viewState = .failedLoading
        }
    }
}
