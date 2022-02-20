//
//  ListRecipesController+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 17/02/2022.
//

import XCTest
@testable import Reciplease

class ListRecipesController_Tests: XCTestCase {

    var sut: ListRecipesController?

    let recipesTest = [
        Recipe(name: "one", imageUrl: "", urlDirections: "", yield: 1, ingredientLines: [], ingredients: "", totalTime: 0),
        Recipe(name: "two", imageUrl: "", urlDirections: "", yield: 2, ingredientLines: [], ingredients: "", totalTime: 0),
        Recipe(name: "three", imageUrl: nil, urlDirections: "", yield: 3, ingredientLines: [], ingredients: "", totalTime: 0)
    ]

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "ListRecipesController", bundle: Bundle.main)
        sut = storyboard.instantiateViewController(withIdentifier: "ListRecipesController") as? ListRecipesController
        sut?.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_given_recipes_when_displayed_then_cell_label_matches() {
        // arrange
        sut?.viewModel.recipes = recipesTest
        let table = sut?.listRecipesTableView
        let cell = sut?.tableView(table ?? UITableView(), cellForRowAt: IndexPath(row: 1, section: 0)) as? ListRecipeCell
        // act
        cell?.configCell(with: recipesTest[IndexPath(row: 1, section: 0).row])
        // assert
        XCTAssertEqual(cell?.listCellNameLabel.text, "two")
    }

    func test_given_recipes_without_image_when_displayed_then_cell_image_is_default() {
        // arrange
        sut?.viewModel.recipes = recipesTest
        let table = sut?.listRecipesTableView
        let cell = sut?.tableView(table ?? UITableView(), cellForRowAt: IndexPath(row: 2, section: 0)) as? ListRecipeCell
        let defaultImage = UIImage(named: "DefaultImage")
        guard let imageView = cell?.listCellImageView else { return }
        // act
        cell?.configCell(with: recipesTest[IndexPath(row: 2, section: 0).row])
        // assert
        XCTAssertEqual(cell?.listCellImageView.image, defaultImage)
        XCTAssertTrue(((cell?.listCellImageView.makeGradient(to: imageView)) != nil))
    }

    func test_given_recipes_outOf_currentRange_when_displayed_then_cell_default() {
        // arrange
        sut?.viewModel.recipes = recipesTest
        let table = sut?.listRecipesTableView
        // act
        let cell = sut?.tableView(table ?? UITableView(), cellForRowAt: IndexPath(row: 4, section: 0)) as? ListRecipeCell
        // assert
        XCTAssertTrue(((cell?.configCell(with: .none)) != nil))
    }

    func test_given_total_recipes_when_displayed_then_numberOfRows_is_correct() {
        // arrange
        sut?.count = recipesTest.count
        let table = sut?.listRecipesTableView
        let totalRow = sut?.totalCount
        // act
        let numberOfCell = table?.numberOfRows(inSection: 0)
        // assert
        XCTAssertEqual(numberOfCell, totalRow)
    }
}
