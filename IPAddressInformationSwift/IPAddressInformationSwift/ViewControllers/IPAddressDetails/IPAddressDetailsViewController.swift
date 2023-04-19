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
    
    /**
     Reuse identifier for the display type table view cell.
     
     - Returns: String.
     */
    private let displayTypeCellReuseIdentifier = "DisplayTypeCell"
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        self.title = NSLocalizedString("IP Address Details", comment: "")
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
        self.tableView.register(FailedLoadingTableViewCell.self, forCellReuseIdentifier: FailedLoadingTableViewCell.identifier)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.displayTypeCellReuseIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.viewModel.viewState {
        case .failedLoading, .loading:
            return 1
        case .ipAddressDetails(let displayTypes):
            return displayTypes.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.viewModel.viewState {
        case .loading:
            return self.setupLoadingTableViewCell(indexPath: indexPath)
        case .failedLoading:
            return self.setupFailedLoadingTableViewCell(indexPath: indexPath)
        case .ipAddressDetails(let displayTypes):
            let displayType = displayTypes[indexPath.row]
            return self.setupDisplayTypesTableViewCell(indexPath: indexPath, displayType: displayType)
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
        return cell
    }
    
    /**
     Sets up the loading table view cell.
     
     - Parameter indexPath: IndexPath.
     */
    private func setupFailedLoadingTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: FailedLoadingTableViewCell.identifier) as! FailedLoadingTableViewCell
        cell.retryButtonPressedEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                print("Retry button pressed.")
                self?.viewModel.loadIPAddressInformationTask()
            }.store(in: &self.cancellables)
        return cell
    }
    
    private func setupDisplayTypesTableViewCell(indexPath: IndexPath, displayType: IPAddressDetailsViewModel.IPAddressDisplayType) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.displayTypeCellReuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        var content = cell.defaultContentConfiguration()
        switch displayType {
        case .regular(let title, let subtitle):
            content.text = title
            content.secondaryText = subtitle
        case .location:
            content.text = NSLocalizedString("Location", comment: "")
            content.secondaryText = NSLocalizedString("Press to show location in maps.", comment: "")
        }
        cell.contentConfiguration = content
        return cell
    }
}
