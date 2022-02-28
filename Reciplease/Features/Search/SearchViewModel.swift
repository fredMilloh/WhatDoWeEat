//
//  IngredientManager.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import Foundation

protocol IngredientDelegate: AnyObject {
    func ingredientsList(with ingredients: [String])
}

protocol AlertDelegate: AnyObject {
    func presentAlert(message: String)
    func presentInfo(message alertInfo: String)
}

class SearchViewModel {

    weak var ingredientDelegate: IngredientDelegate?
    var alertDelegate: AlertDelegate?

    init(delegate: IngredientDelegate, alertDelegate: AlertDelegate) {
        self.ingredientDelegate = delegate
        self.alertDelegate = alertDelegate
    }

// MARK: - Properties

    var listOfIngredients: [String] = [] {
        didSet {
            ingredientDelegate?.ingredientsList(with: listOfIngredients)
        }
    }

    var presentAlert: RecipeError = .invalidData {
        didSet {
            alertDelegate?.presentAlert(message: presentAlert.localizedDescription)
        }
    }

    var presentInfo: String = "Ingredients have been removed" {
        didSet {
            alertDelegate?.presentInfo(message: presentInfo)
        }
    }

    var ingredients = [String]()

// MARK: - Common Methods

    func createIngredientsArray(with inventory: String) {
        if inventory.isLetters {
            let ingredient = inventory.split(separator: ",")
                .map{ "\($0.trimmingCharacters(in: .whitespaces).localizedCapitalized)" }
            self.ingredients = ingredient

            addIngredientToList()
        } else {
            presentAlert = .incorrectElement
        }
    }

    private func listAlreadyContains(this: String) -> Bool {
        return listOfIngredients.contains(this)
    }

// MARK: - Create Update

    private func addIngredientToList() {
        ingredients.forEach { ingredient in
            if !listAlreadyContains(this: ingredient) && ingredient.count > 1 {
                listOfIngredients.append(ingredient)
                listOfIngredients = listOfIngredients.sorted()
            }
        }
    }

// MARK: - Delete

    func removeToList(at index: Int) {
        listOfIngredients.remove(at: index)
        ingredients = [String]()
        presentInfo = "This ingredient has been removed"
    }

    func clearListOfIngredients() {
        listOfIngredients.removeAll()
        presentInfo = "Ingredients have been removed"
    }
}
