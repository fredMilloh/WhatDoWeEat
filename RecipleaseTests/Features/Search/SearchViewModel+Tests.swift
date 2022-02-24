//
//  IngredientManager+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 05/02/2022.
//

import XCTest
@testable import Reciplease

class SearchViewModel_Tests: XCTestCase, IngredientDelegate, AlertDelegate {

    func presentInfo(message alertInfo: String) {
    }

    func presentAlert(message: String) {
    }

    func ingredientsList(with ingredients: [String]) {
        _ = ingredients
    }

    var inventory = ""

    func test_given_there_is_no_ingredient_when_tap_add_then_array_is_empty() {
        // arrange
        let sut = SearchViewModel(delegate: self, alertDelegate: self)
        let array = sut.listOfIngredients
        // act
        sut.createIngredientsArray(with: inventory)
        // assert
        XCTAssertEqual(array, [])
    }

    func test_given_there_is_empty_ingredient_when_tap_add_then_array_is_unchanged() {
        // arrange
        let sut = SearchViewModel(delegate: self, alertDelegate: self)
        sut.listOfIngredients = ["item"]
        inventory = " "
        let array = sut.listOfIngredients
        // act
        sut.createIngredientsArray(with: inventory)
        // assert
        XCTAssertEqual(array, ["item"])
    }

    func test_given_there_is_one_ingredient_when_tap_add_then_array_is_correct() {
        // arrange
        let sut = SearchViewModel(delegate: self, alertDelegate: self)
        inventory = "Lemon"
        // act
        sut.createIngredientsArray(with: inventory)
        let array = sut.listOfIngredients
        // assert
        XCTAssertEqual(array, ["Lemon"])
    }

    func test_given_there_is_lowerCase_ingredient_when_add_then_capitalized_and_sorted() {
        // arrange
        let sut = SearchViewModel(delegate: self, alertDelegate: self)
        sut.listOfIngredients = []
        inventory = "Lemon, Tomatoe, mushrooms"
        // act
        sut.createIngredientsArray(with: inventory)
        let array = sut.listOfIngredients
        // assert
        XCTAssertEqual(array, ["Lemon", "Mushrooms", "Tomatoe"])
    }

    func test_given_ingredient_is_upperCase_Without_and_with_space_when_add_then_capitalized() {
        // arrange
        let sut = SearchViewModel(delegate: self, alertDelegate: self)
        sut.listOfIngredients = ["Lemon", "Mushrooms", "Tomatoe"]
        inventory = "eggs,Potatoe,  ,CHEESE"
        // act
        sut.createIngredientsArray(with: inventory)
        let array = sut.listOfIngredients
        // assert
        XCTAssertEqual(array, ["Cheese", "Eggs", "Lemon", "Mushrooms", "Potatoe", "Tomatoe"])
    }

    func test_given_ingredients_have_same_name_when_add_then_list_updated_only_one() {
        //arrange
        let sut = SearchViewModel(delegate: self, alertDelegate: self)
        sut.listOfIngredients = ["Mushrooms", "Tomatoe"]
        inventory = "chocolate, mushrooms,Chocolate"
        // act
        sut.createIngredientsArray(with: inventory)
        let array = sut.listOfIngredients
        // assert
        XCTAssertEqual(array, ["Chocolate", "Mushrooms", "Tomatoe"])
    }

    func test_given_list_filled_when_clearButton_pressed_then_list_becomes_empty(){
        //arrange
        let sut = SearchViewModel(delegate: self, alertDelegate: self)
        sut.listOfIngredients = ["Lemon", "Mushrooms", "Tomatoe"]
        // act
        sut.clearListOfIngredients()
        // assert
        XCTAssertTrue(sut.listOfIngredients.isEmpty)
        XCTAssertEqual(sut.presentInfo, "Ingredients have been removed")
    }

    func test_given_list_filled_when_remove_one_ingredient_then_list_updated() {
        // arrange
        let sut = SearchViewModel(delegate: self, alertDelegate: self)
        sut.listOfIngredients = ["Cheese", "Eggs", "Lemon", "Mushrooms", "Potatoe", "Tomatoe"]
        // act
        sut.removeToList(at: 3)
        // assert
        XCTAssertEqual(sut.listOfIngredients, ["Cheese", "Eggs", "Lemon", "Potatoe", "Tomatoe"])
        XCTAssertEqual(sut.presentInfo, "This ingredient has been removed")
    }

    func test_given_inventory_is_number_when_add_pressed_then_not_added_and_alert_displayed() {
        // arrange
        let sut = SearchViewModel(delegate: self, alertDelegate: self)
        sut.listOfIngredients = ["Lemon", "Mushrooms", "Tomatoe"]
        inventory = "34"
        // act
        sut.createIngredientsArray(with: inventory)
        // arrange
        XCTAssertEqual(sut.presentAlert.localizedDescription, "Only words and comma are correct.")
        XCTAssertEqual(sut.listOfIngredients, ["Lemon", "Mushrooms", "Tomatoe"])
    }
}
