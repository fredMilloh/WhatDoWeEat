//
//  SearchController+Tests.swift
//  RecipleaseTests
//
//  Created by fred on 16/02/2022.
//

import XCTest
@testable import Reciplease

class SearchController_Tests: XCTestCase {

    var sut: SearchController?

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "SearchRecipes", bundle: Bundle.main)
        sut = storyboard.instantiateViewController(withIdentifier: "SearchController") as? SearchController
        sut?.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_given_keyboard_display_when_clic_return_then_keyboard_dismiss() {
        // arrange
        guard let textfield = sut?.ingredientTextField else { return }
        textfield.becomeFirstResponder()
        // act
        if ((sut?.textFieldShouldReturn(textfield)) != nil) {
            // assert
            XCTAssertFalse(textfield.isFirstResponder)
        }
    }

    func test_given_textFiel_when_selected_then_keyboard_appears() {
        // arrange
        guard let textField = sut?.ingredientTextField else { return }
        // act
        if ((sut?.textFieldDidBeginEditing(textField)) != nil) {
            // arrange
            XCTAssertEqual(textField.placeholder, "")
        }
    }

    func test_given_ingredients_when_are_displayed_then_cell_title_matches() {
        // arrange
        let ingredients = ["apple", "pears", "banana"]
        sut?.listOfIngredients = ingredients
        let table = sut?.ingredientTableView
        let cell = sut?.tableView(table ?? UITableView(), cellForRowAt: IndexPath(row: 1, section: 0)) as? IngredientCell
        // act
        cell?.configCell(withIngredient: ingredients[IndexPath(row: 1, section: 0).row])
        // assert
        XCTAssertEqual(cell?.cellIngredientLabel.text, "pears")
    }

    func test() {
        // arrange
        sut?.ingredientTextField.text = "pineapple, orange"
        // act
        sut?.addButton(UIButton())
        let listOfIngredients = sut?.ingredientManager.listOfIngredients
        // assert
        XCTAssertEqual(sut?.inventory, "One more thing ? ...")
        XCTAssertEqual(listOfIngredients, ["Orange", "Pineapple"])
    }
    
        
}
