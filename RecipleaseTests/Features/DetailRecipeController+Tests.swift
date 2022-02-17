//
//  DetailRecipe+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 17/02/2022.
//

import XCTest
@testable import Reciplease

class DetailRecipeController_Tests: XCTestCase {

    var sut: DetailRecipeController?

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "DetailRecipe", bundle: Bundle.main)
        sut = storyboard.instantiateViewController(withIdentifier: "DetailRecipe") as? DetailRecipeController
        sut?.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }


}
