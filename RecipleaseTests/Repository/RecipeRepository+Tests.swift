//
//  RecipeRepository+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 20/02/2022.
//

import XCTest
@testable import Reciplease

class RecipeRepository_Tests: XCTestCase {

   class MockRecipeRepositoryFetcher: RecipeRepositoryFetcher {

      override func getRecipes(with url: URL, callback: @escaping RecipePageOrError) {
         guard let data = TestCase.stubbedData(from: "recipe") else { return }
         let recipePage = parse(data)
         callback(recipePage, nil)
      }
    }
    var sut: RecipeRepository?

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RecipeRepository(repositoryFetcher: MockRecipeRepositoryFetcher())
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_ingredients_when_search_recipe_then_getUrl_is_correct() {
        // arrange
        let ingredients = ["Tomatoe", "Mozzarella", "Ham"]
        // act
        sut?.appId = "appTest"
        sut?.apiKey = "apiKeyTest"
        let urlShouldBe = URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=Tomatoe,Mozzarella,Ham&app_id=appTest&app_key=apiKeyTest")
        // assert
        XCTAssertEqual(sut?.getUrl(with: ingredients), urlShouldBe)
    }

    func test_given_good_mock_data_when_getRecipes_then_get_data() {
        // arrange
        guard let url = TestCase.stubbedUrl(from: "recipe") else { return }
        // act
       sut?.getRecipes(with: url, callback: { recipe, error in
          guard let recipesPage = recipe else { return }
          let imageShouldBe = "https://www.edamam.com/web-img/52c/52c39fac86eb11ae14c5d36fc54e5022.jpg"
       // assert
          XCTAssertEqual(recipesPage.hits[1].imageUrl, imageShouldBe)
       })
    }

    func test_given_bad_mock_data_when_getRecipes_then_get_error() {
        // arrange
        //sut = RecipeRepository.shared
        guard let url = TestCase.stubbedUrl(from: "badrecipe") else { return }
        // act
        sut?.getRecipes(with: url, callback: { recipe, error in
        guard let error = error else { return }
        // assert
        XCTAssertNil(recipe)
        XCTAssertEqual(error, .invalidData)
        XCTAssertEqual(error.localizedDescription, "Sorry, no recipe was found, try with other ingredients. Check your network connection if necessary.")
        })
    }
}
