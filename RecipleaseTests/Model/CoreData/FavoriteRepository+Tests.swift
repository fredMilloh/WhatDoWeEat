//
//  FavoriteRepository+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 13/02/2022.
//

import XCTest
import CoreData
@testable import Reciplease

class FavoriteRepository_Tests: XCTestCase {

    var sut: FavoriteRepository?
    let recipe = Recipe(
        name: "testRecipe",
        imageUrl: "testImageUrl",
        urlDirections: "testUrlDirections",
        yield: 12,
        ingredientLines: ["test", "ingredient", "lines"],
        ingredients: "ingredient1, ingredient2",
        totalTime: 60
    )

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = FavoriteRepository()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_recipe_when_save_then_isFavorite_true() {
        // arrange
        guard let sut = sut else { return }
        let recipeUrl = recipe.urlDirections
        // act
       sut.saveFavorite(recipe: recipe) { error in }
        // assert
        XCTAssertTrue(sut.isFavorite(recipeUrl: recipeUrl))
    }

    func test_given_testRecipe_saved_when_get_Favorites_then_testRecipe_is_present() {
        // assert
        guard let sut = sut else { return }
        var recipeTestIsFavorite = false
        // act
        sut.getFavorite { favorites in
            for favorite in favorites {
                if favorite.name == "testRecipe" {
                    recipeTestIsFavorite = true
                }
            }
        }
        // assert
        XCTAssertTrue(recipeTestIsFavorite)
    }

    func test_given_testRecipe_when_delete_then_testRecipe_is_not_favorite() {
        //arrange
        guard let sut = sut else { return }
        let recipeUrl = recipe.urlDirections
        // act
       sut.deleteFavorite(recipeUrl: recipeUrl) { error in }
        // assert
        XCTAssertFalse(sut.isFavorite(recipeUrl: recipeUrl))
    }
}
