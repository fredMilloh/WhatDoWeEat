//
//  FavoriteController+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 17/02/2022.
//

import XCTest
@testable import Reciplease
import CoreData

class FavoriteController_Tests: XCTestCase {

    var sut: FavoriteController?

    var favoritesRecipes = [Favorite]()

    func getFavorites() {
        sut?.favoriteRepository.getFavorite(completion: { favorites in
            for favorite in favorites {
                self.favoritesRecipes.append(favorite)
            }
        })
    }

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "FavoriteController", bundle: Bundle.main)
        sut = storyboard.instantiateViewController(withIdentifier: "FavoriteController") as? FavoriteController
        sut?.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_given_total_favorites_when_displayed_then_numbersOfRows_is_correct() {
        // arrange
        getFavorites()
        if favoritesRecipes.count > 0 {
            sut?.favoritesRecipes = favoritesRecipes
            let table = sut?.listFavoriteTableView
            let totalFavorites = favoritesRecipes.count
            // act
            let numberOfCell = table?.numberOfRows(inSection: 0)
            // assert
            XCTAssertEqual(numberOfCell, totalFavorites)
        }
    }
    func test_given_favoritesRecipes_when_convertToRecipes_then_attributes_matches() {
        // arrange
        getFavorites()
        if favoritesRecipes.count > 0 {
            let favoriteOne = favoritesRecipes[0]
        // act
            let recipeOne = sut?.convertionIntoRecipeFrom(favorite: favoriteOne)
        // assert
            XCTAssertEqual(favoriteOne.name, recipeOne?.name)
            XCTAssertEqual(favoriteOne.imageUrl, recipeOne?.imageUrl)
        }

    }

    func test_given_favoritesRecipes_when_are_displayed_then_cell_title_matches() {
        // arrange
        getFavorites()
        if favoritesRecipes.count > 0 {
            sut?.favoritesRecipes = favoritesRecipes
            let table = sut?.listFavoriteTableView
            let cell = sut?.tableView(table ?? UITableView(), cellForRowAt: IndexPath(row: 0, section: 0)) as? ListRecipeCell
        // act
            let recipe = sut?.convertionIntoRecipeFrom(favorite: favoritesRecipes[0])
            let nameShouldBe = recipe?.name
            cell?.configCell(with: recipe)
        // assert
            XCTAssertEqual(cell?.listCellNameLabel.text, nameShouldBe)
        }
    }
}
