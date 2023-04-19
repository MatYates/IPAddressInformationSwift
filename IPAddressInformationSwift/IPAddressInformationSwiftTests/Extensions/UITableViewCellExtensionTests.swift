//
//  UITableViewCellExtensionTests.swift
//  IPAddressInformationSwiftTests
//
//  Created by Mat Yates on 19/4/2023.
//

import XCTest
@testable import IPAddressInformationSwift

final class UITableViewCellExtensionTests: XCTestCase {

    func testIdentifier() {
        XCTAssertEqual(LoadingTableViewCell.identifier, "LoadingTableViewCell")
        XCTAssertEqual(FailedLoadingTableViewCell.identifier, "FailedLoadingTableViewCell")
    }
}
