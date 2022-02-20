//
//  RecipeRepository+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 20/02/2022.
//

import XCTest
@testable import Reciplease

class RecipeRepository_Tests: XCTestCase {

    var sut: RecipeRepository?

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RecipeRepository(apiKey: "abcde", appId: "123456")
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_getUrl() {
        // arrange
        let ingredients = ["Tomatoe", "Mozzarella", "Ham"]
        let urlShouldBe = URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=Tomatoe,Mozzarella,Ham&app_id=123456&app_key=abcde")
        // assert
        XCTAssertEqual(sut?.getUrl(with: ingredients), urlShouldBe)
    }

    func test_parse_recipe_mock_data() {
        // arrange
        sut = RecipeRepository.shared
        guard let data = TestCase.stubbedData(from: "recipe") else { return }
        // act
        let recipePage = sut?.parse(data)
        // assert
        XCTAssertEqual(recipePage?.hits[0].name, "Baking with Dorie: Lemon-Lemon Lemon Cream Recipe")
    }
}
