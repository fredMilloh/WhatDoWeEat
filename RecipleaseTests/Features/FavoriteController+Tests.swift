//
//  FavoriteController+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 17/02/2022.
//

import XCTest
@testable import Reciplease

class FavoriteController_Tests: XCTestCase {

    var sut: FavoriteController?

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Favorite", bundle: Bundle.main)
        sut = storyboard.instantiateViewController(withIdentifier: "FavoriteList") as? FavoriteController
        sut?.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}
