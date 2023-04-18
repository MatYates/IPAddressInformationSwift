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
        self.tableView.separatorStyle = .none
        self.registerTableViewCells()
        self.viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &self.cancellables)
        self.viewModel.loadIPAddressInformationTask()
    }
    
    /**
     Registers all table view cells for the table view.
     */
    private func registerTableViewCells() {
        self.tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.identifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.viewModel.viewState {
        case .failedLoading, .loading:
            return 1
        case .ipAddressDetails:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.viewState {
        case .loading:
            return self.setupLoadingTableViewCell(indexPath: indexPath)
        default:
            return self.setupLoadingTableViewCell(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - Cell Setup
    
    /**
     Sets up the loading table view cell.
     
     - Parameter indexPath: IndexPath.
     */
    private func setupLoadingTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.identifier) as! LoadingTableViewCell
        cell.title = "Loading IP address details"
        return cell
    }
}
