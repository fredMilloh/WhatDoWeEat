//
//  RecipeRepository+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 08/02/2022.
//

import XCTest

@testable import Reciplease

class ListViewModel_Tests: XCTestCase {

    var sut = ListViewModel.shared
    let recipesTest = [
        Recipe(name: "one", imageUrl: "", urlDirections: "", yield: 1, ingredientLines: [], ingredients: "", totalTime: 0),
        Recipe(name: "two", imageUrl: "", urlDirections: "", yield: 2, ingredientLines: [], ingredients: "", totalTime: 0),
        Recipe(name: "three", imageUrl: "", urlDirections: "", yield: 3, ingredientLines: [], ingredients: "", totalTime: 0)
    ]

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ListViewModel.shared
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_totalCount_return_total() {
        // arrange
        sut.total = 12
        //act
        let totalCountshouldBe = sut.totalCount
        // assert
        XCTAssertEqual(totalCountshouldBe, 12)
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


//    func test_getRecipes_with_good_dataMock() {
//        // arrange
//        let data = TestCase.stubbedData(from: "recipe")
//        // act
//        sut?.getRecipes(data: data, error: nil, callback: { recipes, error in
//            guard let recipes = recipes?.hits else { return }
//        // assert
//            XCTAssertEqual(recipes[0].name, "Baking with Dorie: Lemon-Lemon Lemon Cream Recipe")
//        })
//    }

//    func test_getrecipes_with_bad_dataMock() {
//        // arrange
//        let data = TestCase.stubbedData(from: "badrecipe")
//        // act
//        sut?.getRecipes(data: data, error: nil, callback: { recipes, error in
//            guard let recipes = recipes?.hits else { return }
//        // assert
//            XCTAssertEqual(recipes[1].totalTime, nil)
//            XCTAssertEqual(error?.localizedDescription, "There is no corresponding recipe. Add an ingredient if necessary.")
//        })
//    }
}
