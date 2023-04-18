//
//  ViewController.swift
//  IPAddressInformationSwift
//
//  Created by Mat Yates on 18/4/2023.
//

import UIKit
import IPAddressAPI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.testAPIManager()
    }


    func testAPIManager() {
        Task {
            let apiManager = APIManager(session: URLSession.shared)
            do {
                let ipAddressDetails = try await apiManager.getUsersIPDetails()
                print(ipAddressDetails)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

