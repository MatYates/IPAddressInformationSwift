//
//  FailedLoadingTableViewCell.swift
//  IPAddressInformationSwift
//
//  Created by Mat Yates on 18/4/2023.
//

import UIKit
import Combine

class FailedLoadingTableViewCell: UITableViewCell {
    
    // MARK: - Properties

    var retryButtonPressedEvent = PassthroughSubject<Void, Never>()

    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Unable to get IP address details, please try again.", comment: "")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonTitle = NSLocalizedString("Retry", comment: "")
        button.setTitle(buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(self.retryButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.commonInnit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.commonInnit()
    }
    
    // MARK: - Setup
    
    private func commonInnit() {
        self.selectionStyle = .none
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.retryButton)
        self.setupConstraints()
    }
    
    /**
     Activates all constraints for the table view cell.
     */
    private func setupConstraints() {
        let allConstraints = self.titleLabelConstraints + self.retryButtonConstraints
        NSLayoutConstraint.activate(allConstraints)
    }
    
    // MARK: - Constraints
    
    /**
     Constraints for the title label.
     
     - Returns: Array of NSLayoutConstraint.
     */
    private var titleLabelConstraints: [NSLayoutConstraint] {
        return [self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
                self.titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 12),
                self.contentView.trailingAnchor.constraint(greaterThanOrEqualTo: self.titleLabel.trailingAnchor, constant: 12),
                self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)]
    }
    
    /**
     Constraints for the retry button.
     
     - Returns: Array of NSLayoutConstraint.
     */
    private var retryButtonConstraints: [NSLayoutConstraint] {
        return [self.retryButton.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
                self.retryButton.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 12),
                self.contentView.trailingAnchor.constraint(greaterThanOrEqualTo: self.retryButton.trailingAnchor, constant: 12),
                self.contentView.bottomAnchor.constraint(equalTo: self.retryButton.bottomAnchor, constant: 12),
                self.retryButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)]
    }
    
    // MARK: - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.retryButtonPressedEvent = PassthroughSubject<Void, Never>()
    }
    
    @IBAction private func retryButtonPressed() {
        self.retryButtonPressedEvent.send()
    }
}
