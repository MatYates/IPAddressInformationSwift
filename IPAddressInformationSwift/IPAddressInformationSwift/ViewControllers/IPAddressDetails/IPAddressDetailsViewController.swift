//
//  IPAddressDetailsViewController.swift
//  IPAddressInformationSwift
//
//  Created by Mat Yates on 18/4/2023.
//

import UIKit
import Combine

class IPAddressDetailsViewController: UITableViewController {
    
    // MARK: - Properties
    
    /**
     View model helper.
     
     - Returns: IPAddressDetailsViewModel.
     */
    private let viewModel = IPAddressDetailsViewModel()
    
    /**
     Cancellables for combine functions.
     
     - Returns: Set of AnyCancellable.
     */
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        self.viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &self.cancellables)
        self.viewModel.loadIPAddressInformationTask()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
