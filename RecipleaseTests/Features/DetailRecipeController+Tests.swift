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
        ingredientLines: ["2 cups flour", "1/8 teaspoon kosher salt", "2 1/2 cup granulated sugar"],
        ingredients: "butter, sugar, flour, salt, lemon",
        totalTime: 90)

    let selectedTestithoutImage = Recipe(
        name: "selectedOne",
        imageUrl: nil,
        urlDirections: "https://testDirections.com",
        yield: 4,
        ingredientLines: ["2 cups flour", "1/8 teaspoon kosher salt", "2 1/2 cup granulated sugar"],
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

    func test_given_total_ingredientsLines_when_displayed_then_numberOfRows_is_correct() {
        // arrange
        sut?.selectedRecipe = selectedTestRecipe
        guard let recipe = sut?.selectedRecipe else { return }
        let table = sut?.detailTableView
        let ingredientLinesCount = recipe.ingredientLines.count
        // act
        let numberOfCell = table?.numberOfRows(inSection: 0)
        // assert
        XCTAssertEqual(numberOfCell, ingredientLinesCount)
    }

//    func test_given_selectedRecipe_when_displayed_details_then_labels_corrects() {
//        //arrange
//        sut?.selectedRecipe = selectedTestRecipe
//        let recipeName = selectedTestRecipe.name
//        let yieldsString = String(selectedTestRecipe.yield.withoutDecimal())
//        let timeString = (selectedTestRecipe.totalTime * 60).convertToString(style: .abbreviated)
//        // act
//        sut?.configHeaderView()
//        // assert
//        XCTAssertEqual(sut?.detailRecipeNameLabel.text, recipeName)
//        XCTAssertEqual(sut?.detailTimeView.yieldLabel.text, yieldsString)
//        XCTAssertEqual(sut?.detailTimeView.timeLabel.text, timeString)
//    }

    func test_given_selectedrecipe_when_without_imageUrl_then_displayed_default_image() {
        // arrange
        let defaulImage = UIImage(named: "DefaultImage")
        sut?.selectedRecipe = selectedTestithoutImage
        // act
        sut?.configHeaderView()
        // arrange
        XCTAssertEqual(sut?.detailRecipeImageView.image, defaulImage)
    }

    func test_given_ingredientLines_when_are_displayed_then_cell_title_matches() {
        // arrange
        sut?.selectedRecipe?.ingredientLines = selectedTestRecipe.ingredientLines
        let table = sut?.detailTableView
        guard let cell = sut?.tableView(table ?? UITableView(), cellForRowAt: IndexPath(row: 1, section: 0)) as? IngredientCell, let selectedRecipe = sut?.selectedRecipe else { return }
        // act
        cell.configCell(withIngredient: selectedRecipe.ingredientLines[IndexPath(row: 1, section: 0).row])
        // assert
        XCTAssertEqual(cell.cellIngredientLabel.text, "1/8 teaspoon kosher salt")
    }
}
