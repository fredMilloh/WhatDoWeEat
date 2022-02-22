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

    let selectedTestRecipe = Recipe(
        name: "selectedOne",
        imageUrl: "https://testImage.com",
        urlDirections: "https://testDirections.com",
        yield: 4,
        ingredientLines: ["1/2 pound unsalted butter, at room temperature", "1/2 cup granulated sugar", "2 cups flour", "1/8 teaspoon kosher salt", "For the full-size lemon layer:", "2 1/2 cup granulated sugar"],
        ingredients: "butter, sugar, flour, salt, lemon",
        totalTime: 90)

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "DetailRecipeController", bundle: Bundle.main)
        sut = storyboard.instantiateViewController(withIdentifier: "DetailRecipeController") as? DetailRecipeController
        sut?.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

//    func test_given_total_ingredientsLines_when_displayed_then_numberOfRows_is_correct() {
//        // arrange
//        sut?.selectedRecipe = selectedTestRecipe
//        let table = sut?.detailTableView
//        let ingredientLinesCount = selectedTestRecipe.ingredientLines.count
//        // act
//        let numberOfCell = table?.numberOfRows(inSection: 0)
//        // assert
//        XCTAssertEqual(numberOfCell, ingredientLinesCount)
//    }
}
