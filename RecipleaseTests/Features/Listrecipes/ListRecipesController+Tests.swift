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

        // act
        cell?.configCell(with: recipesTest[IndexPath(row: 2, section: 0).row])
        // assert
        XCTAssertEqual(cell?.listCellImageView.image, defaultImage)
        XCTAssertTrue(((cell?.listCellImageView.makeGradient()) != nil))
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

    func test_given_scroll_tableView_when_newPage_is_received_then_calculate_cells_needed() {
        // arrange
        let indexPathsForVisibleRows = sut?.listRecipesTableView.indexPathsForVisibleRows ?? []
        let indexPaths = [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)]
        // act
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        // assert
        XCTAssertEqual(sut?.visibleIndexPathsToReload(intersecting: indexPaths), Array(indexPathsIntersection))

    }

    func test_given_getRecipes_when_failed_fetch_then_delegate_pass_error() {
        // arrange
        let error: RecipeError = .fetchError
        // act
        sut?.onFetchFailed(with: error)
        let alertMessageShouldBe = error.localizedDescription
        // assert
        XCTAssertEqual(sut?.alertMessage.localizedDescription, alertMessageShouldBe)
    }

    func test_given_getFirstrecipes_when_call_repository_get_method_then_receive_RecipePage() {
        // arrange
        guard let url = TestCase.stubbedUrl(from: "recipe") else { return }
        // act
        sut?.getFirstRecipes()
        let urlShouldBe = "https://api.edamam.com/api/recipes/v2?q=lemon&app_key=7&"
        sut?.recipeRepository.getRecipes(with: url, callback: { recipePage, error in
            if let firstRecipePage = recipePage {
                guard let url = firstRecipePage.nextPage else { return }
        // assert
                XCTAssertEqual(url, urlShouldBe)
            }
        })
    }
}
