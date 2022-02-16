//
//  TabBarController+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 16/02/2022.
//

import XCTest
@testable import Reciplease

class TabBarController_Tests: XCTestCase {

    var sut: TabBarController?

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "TabBarController", bundle: Bundle.main)
        sut = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController
        sut?.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

}
