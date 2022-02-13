//
//  RecipeRepository+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 08/02/2022.
//

import XCTest

@testable import Reciplease

class RecipeRepository_Tests: XCTestCase {

    var sut: RecipeRepository?

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RecipeRepository(apiKey: "abcde", appId: "12345")
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_getUrl() {
        // arrange
        let ingredients = ["Tomatoe", "Mozzarella", "Ham"]
        let urlShouldBe = URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=Tomatoe,Mozzarella,Ham&app_id=12345&app_key=abcde")
        // assert
        XCTAssertEqual(sut?.getUrl(with: ingredients), urlShouldBe)
    }

    func test_getRecipes_with_good_dataMock() {
        // arrange
        let data = TestCase.stubbedData(from: "recipe")
        // act
        sut?.getRecipes(data: data, error: nil, callback: { recipes, error in
            guard let recipes = recipes?.hits else { return }
        // assert
            XCTAssertEqual(recipes[0].name, "Baking with Dorie: Lemon-Lemon Lemon Cream Recipe")
        })
    }

    func test_getrecipes_with_bad_dataMock() {
        // arrange
        let data = TestCase.stubbedData(from: "badrecipe")
        // act
        sut?.getRecipes(data: data, error: nil, callback: { recipes, error in
            guard let recipes = recipes?.hits else { return }
        // assert
            XCTAssertEqual(recipes[1].totalTime, nil)
            XCTAssertEqual(error?.localizedDescription, "There is no corresponding recipe. Add an ingredient if necessary.")
        })
    }
}
