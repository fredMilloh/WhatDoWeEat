//
//  Parserrepository+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 15/02/2022.
//

import XCTest
@testable import Reciplease

class ParserRepository_Tests: XCTestCase {

    var sut: ParserRepository?

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ParserRepository(apiKey: "abcde", appId: "123456")
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

    func test_parse_recipe_mock_data() {
        // arrange
        let data = TestCase.stubbedData(from: "recipe")
        // act
        let recipes = sut?.parse(data)
        // assert
        XCTAssertEqual(recipes?.hits[0].name, "Baking with Dorie: Lemon-Lemon Lemon Cream Recipe")
    }

}
