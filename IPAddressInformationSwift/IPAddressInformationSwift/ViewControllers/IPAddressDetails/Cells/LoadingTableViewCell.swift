//
//  LoadingTableViewCell.swift
//  IPAddressInformationSwift
//
//  Created by Mat Yates on 18/4/2023.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    /**
     Title to be displayed.
     
     - Returns: String.
     */
    var title: String? {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    
    // MARK: - UI
    
    /**
     Label to display the title text.
     
     - Returns: UILabel.
     */
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.title
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        self.setupConstraints()
    }
    
    /**
     Activates all constraints for the table view cell.
     */
    private func setupConstraints() {
        NSLayoutConstraint.activate(self.titleLabelConstraints)
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
                self.contentView.bottomAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
                self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)]
    }
    
    // MARK: - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.title = nil
    }
}
