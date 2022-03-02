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
    var coreDatastack: TestCoreDataStack?

    let recipeTest = Recipe(
        name: "testRecipe",
        imageUrl: "testImageUrl",
        urlDirections: "testUrlDirections",
        yield: 12,
        ingredientLines: ["test", "ingredient", "lines"],
        ingredients: "ingredient1, ingredient2",
        totalTime: 60
    )

    override func setUpWithError() throws {
        coreDatastack = TestCoreDataStack()
        sut = FavoriteRepository()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        coreDatastack = nil
        sut = nil
        try super.tearDownWithError()
    }

   func test_given_recipeTest_when_call_repository_methods_then_result_is_correct() {

      // arrange SAVE
      guard let sut = sut else { return }
      let recipeUrl = recipeTest.urlDirections
      // act SAVE
     sut.saveFavorite(recipe: recipeTest) { error in }
      // assert SAVE/isFavorite
      XCTAssertTrue(sut.isFavorite(recipeUrl: recipeUrl))

      // arrange GET
      var recipeTestIsFavorite = false
      // act GET
      sut.getFavorite { favorites in
          for favorite in favorites {
              if favorite.name == "testRecipe" {
                  recipeTestIsFavorite = true
              }
          }
      }
      // assert GET
      XCTAssertTrue(recipeTestIsFavorite)

      // act DELETE with let recipeUrl
     sut.deleteFavorite(recipeUrl: recipeUrl) { error in }
      // assert DELETE/isFavorite
      XCTAssertFalse(sut.isFavorite(recipeUrl: recipeUrl))
   }
}
