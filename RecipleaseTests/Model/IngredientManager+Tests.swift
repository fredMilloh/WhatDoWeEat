//
//  IngredientManager+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 05/02/2022.
//

import XCTest
@testable import Reciplease

class IngredientManager_Tests: XCTestCase, IngredientDelegate {
    func ingredientsList(with ingredients: [String]) {
        _ = ingredients
    }

    var inventory = ""

    func test_given_there_is_no_ingredient_when_tap_add_then_array_is_empty() {
        // arrange
        let sut = IngredientManager(delegate: self)
        sut.createIngredientsArray(with: inventory)
        // act
        sut.addIngredientToList()
        let array = sut.listOfIngredients
        // assert
        XCTAssertEqual(array, [])
    }

    func test_given_ther_is_empty_ingredient_when_tap_add_then_array_is_unchanged() {
        // arrange
        let sut = IngredientManager(delegate: self)
        sut.listOfIngredients = ["item"]
        inventory = " "
        sut.createIngredientsArray(with: inventory)
        // act
        sut.addIngredientToList()
        let array = sut.listOfIngredients
        // assert
        XCTAssertEqual(array, ["item"])
    }

    func test_given_there_is_one_ingredient_when_tap_add_then_array_is_correct() {
        // arrange
        let sut = IngredientManager(delegate: self)
        inventory = "Lemon"
        sut.createIngredientsArray(with: inventory)
        // act
        sut.addIngredientToList()
        let array = sut.listOfIngredients
        // assert
        XCTAssertEqual(array, ["Lemon"])
    }

    func test_given_there_is_lowerCase_ingredient_when_add_then_capitalized_and_sorted() {
        // arrange
        let sut = IngredientManager(delegate: self)
        sut.listOfIngredients = []
        inventory = "Lemon, Tomatoe, mushrooms"
        sut.createIngredientsArray(with: inventory)
        // act
        sut.addIngredientToList()
        let array = sut.listOfIngredients
        // assert
        XCTAssertEqual(array, ["Lemon", "Mushrooms", "Tomatoe"])
    }

    func test_given_ingredient_is_upperCase_Without_and_with_space_when_add_then_capitalized() {
        // arrange
        let sut = IngredientManager(delegate: self)
        sut.listOfIngredients = ["Lemon", "Mushrooms", "Tomatoe"]
        inventory = "eggs,Potatoe,  ,CHEESE"
        sut.createIngredientsArray(with: inventory)
        // act
        sut.addIngredientToList()
        let array = sut.listOfIngredients
        // assert
        XCTAssertEqual(array, ["Cheese", "Eggs", "Lemon", "Mushrooms", "Potatoe", "Tomatoe"])
    }

    func test_given_ingredients_have_same_name_when_add_then_list_updated_only_one() {
        //arrange
        let sut = IngredientManager(delegate: self)
        sut.listOfIngredients = ["Mushrooms", "Tomatoe"]
        inventory = "chocolate, mushrooms,Chocolate"
        sut.createIngredientsArray(with: inventory)
        // act
        sut.addIngredientToList()
        let array = sut.listOfIngredients
        // assert
        XCTAssertEqual(array, ["Chocolate", "Mushrooms", "Tomatoe"])
    }

    func test_given_list_filled_when_clearButton_pressed_then_list_becomes_empty(){
        //arrange
        let sut = IngredientManager(delegate: self)
        sut.listOfIngredients = ["Lemon", "Mushrooms", "Tomatoe"]
        // act
        sut.clearListOfIngredients()
        // assert
        XCTAssertTrue(sut.listOfIngredients.isEmpty)
    }
}
