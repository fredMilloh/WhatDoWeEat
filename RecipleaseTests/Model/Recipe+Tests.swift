//
//  Recipe+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 08/02/2022.
//

import XCTest
@testable import Reciplease

class Recipe_Tests: XCTestCase {

    func test_Recipe_json_mapping() throws {
        // arrange
        guard let dataRecipe = TestCase.stubbedData(from: "recipe") else { return }
        // act
        let decoder = JSONDecoder()
        let recipes = try decoder.decode(RecipePage.self, from: dataRecipe)
        let recipe = recipes.hits
        // assert
        XCTAssertEqual(recipe[1].name, "Lemon Bars")
    }
}
