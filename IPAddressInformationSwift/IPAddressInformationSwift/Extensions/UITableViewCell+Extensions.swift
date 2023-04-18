//
//  UITableViewCell+Extensions.swift
//  IPAddressInformationSwift
//
//  Created by Mat Yates on 18/4/2023.
//

import UIKit

extension UITableViewCell {
    
    /**
     Creates an identifier for the table view cell based on the class name.
     
     - Returns: String.
     */
    static var identifier: String {
        return String(describing: self)
    }
}
