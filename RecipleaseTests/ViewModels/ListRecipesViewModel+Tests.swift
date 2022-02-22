//
//  RecipeRepository+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 08/02/2022.
//

import XCTest

@testable import Reciplease

class ListRecipesViewModel_Tests: XCTestCase {

    var getDelegate: GetDelegate?
    lazy var sut = ListRecipesViewModel(delegate: self)
    var recipeRepository = RecipeRepository.shared
    
    let recipesTest = [
        Recipe(name: "one", imageUrl: "", urlDirections: "", yield: 1, ingredientLines: [], ingredients: "", totalTime: 0),
        Recipe(name: "two", imageUrl: "", urlDirections: "", yield: 2, ingredientLines: [], ingredients: "", totalTime: 0),
        Recipe(name: "three", imageUrl: "", urlDirections: "", yield: 3, ingredientLines: [], ingredients: "", totalTime: 0)
    ]

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ListRecipesViewModel(delegate: self)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_currentCount_of_recipes_array_and_good_index() {
        // arrange
        sut.recipes = recipesTest
        // act
        let countShouldBe = sut.currentCount
        let selectedRecipe = sut.recipe(at: 1)
        // assert
        XCTAssertEqual(countShouldBe, 3)
        XCTAssertEqual(selectedRecipe.name, "two")
    }

    func test_calculate_indexPath_to_reload() {
        // arrange
        sut.recipes = recipesTest
        let newRecipesTest = [
            Recipe(name: "four", imageUrl: "", urlDirections: "", yield: 4, ingredientLines: [], ingredients: "", totalTime: 0),
            Recipe(name: "five", imageUrl: "", urlDirections: "", yield: 5, ingredientLines: [], ingredients: "", totalTime: 0)
        ]
        // act
        let newIndex = sut.calculateIndexPathsToReload(from: newRecipesTest)
        // assert
        XCTAssertEqual(newIndex, [[0, 1], [0, 2]])
    }

    func test_given_nextPageUrl_when_get_recipes_then_url_correct() {
        // arrange
        let nextPageUrl = "https://api.edamam.com/api/recipes/v2?q=test"
        sut.nextPageUrl = nextPageUrl
        // act
        let urlShouldBe = URL(string: "https://api.edamam.com/api/recipes/v2?q=test")
        // assert
        XCTAssertEqual(sut.url, urlShouldBe)
    }

    func test_given_url_when_getRecipe_calls_then_nextPageUrl_updated() {
        // arrange
        guard let url = TestCase.stubbedUrl(from: "recipe") else { return }
        // act
        sut.getRecipes()
        sut.recipeRepository.getDelegate?.getRecipes(with: url, callback: { [self] recipePage, error in
            if let newRecipePage = recipePage {
                guard let newUrl = newRecipePage.nextPage else { return }
                sut.nextPageUrl = newUrl
        // assert
                XCTAssertEqual(sut.nextPageUrl, "https://api.edamam.com/api/recipes/v2?q=lemon&app_key=7&")
            }
        })
    }
}
extension ListRecipesViewModel_Tests: ListViewModelDelegate {

    func onFetchFailed(with error: RecipeError) {
    }

    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
    }
}
